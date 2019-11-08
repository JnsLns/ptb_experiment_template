%% Illusory conjunction task for motion tracker hardware
% Jonas Lins, October 2019

% See readme.md for help.


%%%% Settings

% This will be appended to each results file name
experimentName = 'my_exp';

% actual screen size in mm (actual image area)
%e.s.expScreenSize_mm = [474, 291]; % Miro
e.s.expScreenSize_mm = [531 299]; % Gecko

% Participant's distance from screen in millimeters
e.s.viewingDistance_mm = 500;

% name of key to press to pause experiment (to pause, the key needs to be
% depressed at the start of a trial)
pauseKey = 'Pause';
       
% save results to file?
doSave = true;


%%%% Settings specific to IC / trajectory-based paradigm

% Define column numbers for trajectory matrices 
e.s.trajCols.x = 1; % pointer coordinates
e.s.trajCols.y = 2;
e.s.trajCols.z = 3;
e.s.trajCols.t = 4; % tracker time stamps (compatible with time measure-
                    % ments in e.results if they are postfixed '_tr').

% marker IDs [TCMID1,LEDID1;TCMID2,LEDID2]
e.s.markers.pad_tipID = [3,1];                  % calibration pad: ID of tip marker
e.s.markers.pad_IDs = [3,2; 3,3; 3,4];          % calibration pad: ID of other markers
e.s.markers.pointer_IDs = [3,6; 3,7; 3,8];      % pointer: IDs of markers on pointer
e.s.markers.coordinate_IDs = [3, 10; 3,9; 3,11];% IDs of markers defining coordinate
                                                % frame (origin, pos x axis, x-y-plane)

% Spatial offset applied to pointer tip position data in order to fully
% align it with the experimental screen (so that screen surface lies at
% z=0 despite LEDs being somewhat elevated above the surface).
% More generally speaking, this is an offset of the reference frame used
% for tip position in the experimental code and in the results data, where
% the offset is relative to the coordinate frame derived from the
% screen-mounted markers (e.s.markers.coordinate_IDs). The values set here
% will be added to the x,y,z data values in the latter frame. E.g., if
% the LEDs are positioned 10 millimeter above the screen surface and you
% want the screen surface to correspond to z=0 in the results data, set
% this to [0 0 10].
e.s.markerCRFoffset_xyz_mm = [0 0 12];

e.s.pointer.VelocityThreshold = 2000;  % velocity threshold beyond which 
                                       % marker movement is considered 
                                       % marker jump and discarded [mm/second]
e.s.pointer.DistanceThreshold = 1;     % distance threshold for marker 
                                       % distance check [mm}

% Regarding recording of trajectories:
% If e.s.dontRecordConstantTrajData == 1, then only the first of any directly
% successive data points that have the same position data is kept.
% Setting e.s.dontRecordConstantTrajData to 0 will store the redundant data
% points.
e.s.dontRecordConstantTrajData = 1;



                       %%%% END OF SETTINGS %%%%

                       
%%%% Warn in case saving is disabled
                       
if ~doSave   
    resp = ...
    questdlg('Saving is disabled, results will not be recorded.', 'Warning', ...
                'Continue without saving','Abort', 2);
    if strcmp(resp, 'Abort')
        return
    end    
end
                       

%%%% Load list of trials and settings from file

[e.s.trialsFileName, trialsPath] = uigetfile('*.mat', 'Select trial file.');
load([trialsPath, e.s.trialsFileName]);


%%%% Ask for save path
if doSave
    savePath = requestSavePath(experimentName);
end


%%%% Psychtoolbox settings
                       
PsychDefaultSetup(2);               % some default Psychtoolbox settings
Screen('Preference', 'VisualDebuglevel', 3); % suppress PTB splash screen
% Screen('Preference','SkipSyncTests',1); % use when debugging in windowed mode


%%%% Determine experimental screen

screens = Screen('Screens');        % get all connected screens
expScreen = max(screens);           % use last screen as stimulus display


%%%% Complete settings struct e.s.

% Get/store spatial configuration of experimental setup.
% Gather all values defining actual spatial setup with respect to the
% specific hardware and arrangement used when the experiment was conducted
% ans store them in struct 'e.s.spatialConfig'. Serves as input to CRF/unit
% conversion functions that are found in private directory.
tmp = get(expScreen,'ScreenSize');
e.s.expScreenSize_px = tmp(3:4);         % get screen res
e.s.spatialConfig.viewingDistance_mm = e.s.viewingDistance_mm;
e.s.spatialConfig.expScreenSize_mm = e.s.expScreenSize_mm;
e.s.spatialConfig.expScreenSize_px = e.s.expScreenSize_px;
e.s.spatialConfig.presArea_va = tg.s.presArea_va;

% copy experimental setup data (not trials) from trial generation struct
% (tg.s) to experimental output struct (e.s); except for
% tg.s.triallistCols.
for fn = fieldnames(tg.s)'    
    if strcmp(fn{1}, 'triallistCols')
        continue; 
    end    
    if isfield(e.s, fn{1})
        error(['Field ', fn{1}, ' was about to be copied from tg.s', ...
            ' to e.s, but already exists in e.s']);
    end
    e.s.(fn{1}) = tg.s.(fn{1});    
end


%%%% Trial data variables (remove tg... it won't be needed anymore)

trials = tg.triallist;
triallistCols = tg.s.triallistCols;
clear tg; 


%%%% Pointer Calibration

[e.s.pointer.coefficients, e.s.pointer.expectedDistances, ...
    e.s.pointer.markerPairings, e.s.pointer.markerIDs] = ...
    doCalibrationProcedure(pad_tipID, pad_IDs, pointer_IDs);


%%%% Initialize output arrays

e.results = [];
e.trajectories = cell();


%%%% Create results file

if doSave
    save(savePath, 'e');
end


%%%% ConVert color-defining field in e.s from strings to RGB

colorDefinition;


%%%% Open PTB windows & hide cursor

% create psychtoolbox onscreen and offscreen windows. NOTE: See this script
% for info on how to create additional offscreen windows (it is useful to
% create an offscreen window for displays that reoccur mutliple times.
openPTBwindows;

% Hide mouse cursor
HideCursor;


%%%% Things to be presented before the experiment

% Show welcome text and wait for button press
ShowTextAndWait(...
    'Bereit. Zum Starten des Experiments beliebige Taste drücken!', ...
    e.s.textColor, winOn.h, 0.5, true);


%%%% Trial loop

curTrial = 1;
sequNum = 0;
while curTrial <= size(trials,1)
    
    % Initialize / empty some things        
    for osw = fieldnames(winsOff)'        
        Screen('FillRect', winsOff.(osw), winsOff.(osw).bgColor);
    end
    out = struct();    
    trajectory = nan(20000, max(structfun(@(x) x, e.s.trajCols)));
    
    % increment sequential number for output
    sequNum = sequNum + 1;       
    
    % Check whether pause key is being pressed, if so, halt execution and
    % close PTB windows. Reopen if resumed.
    pauseAndResume;
    
    
    % run trial (only this script assigns to fields of struct 'out')
    singleTrial;          
            
    
    constructResCols; % construct/extend e.s.resCols based on the field
                      % names of struct 'out' and those of triallistCols
    storeResults;     % store contents of fields of 'out' in the correspon-
                      % dingly named columns of e.results.    
    storeTrajectory;  % store trajectory in e.trajectories (empty cell if
                      % trial was aborted before recording started)
    insertAbortedTrial; % if trial was aborted, shuffle it into the
                        % remaining trial list to be redone later at a
                        % random time point (only if
    
    if doSave
        save(savePath, 'e', '-append');
    end
    
    % go to next trial... 
    curTrial = curTrial + 1; 
    
end


%%%% Things to be presented after the experiment

% Show goodbye message and wait for button press
ShowTextAndWait(...
    'Experiment beendet. Vielen Dank für die Teilnahme!', ...
    e.s.textColor, winOn.h, 0.5, true);



%%% Clean up

Screen('closeall');
ShowCursor;





