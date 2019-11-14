%% Illusory conjunction mouse tracking task
% Jonas Lins, October 2019

% NOTE:
%
% Most code here and in the private directory is infrastucture that should
% usually not be modified to implement a new experiment.
%
% Things that should be modified to implement a new experiment are:
% 
% -- The other files in the experiment directory (they are used in the current
%    script).
%
% -- Passages marked "MODIFY THIS" in the below code. 
%
% -- Settings at the top of this script may of course as well be modified.
%
% See readme.md for further help.



% General settings

% Note: All properties of the paradigm itself should be defined in trial
% generation. Here only things that might be changed halfway through
% participants (such as the screen used) should be listed.

% save results to file?
doSave = true;

% For antialiasing: higher values = smoother graphics but worse
% performance. Reduce if bad performance or graphics memory problems.
e.s.multisampling = 3;

% actual screen size in mm (visible image) as accurately as possible.
%e.s.expScreenSize_mm = [474, 291]; % Miro
e.s.expScreenSize_mm = [531 299]; % Gecko

% Participant's distance from screen in millimeters
e.s.viewingDistance_mm = 500;

% name of key to press to pause experiment (to pause, the key needs to be
% depressed at the start of a trial)
pauseKey = 'Pause';
       

% Settings specific to trajectory-based paradigm

% Define column numbers for trajectory matrices 
e.s.trajCols.x = 1; % pointer coordinates
e.s.trajCols.y = 2;
e.s.trajCols.t = 3; % pc time

% Regarding recording of trajectories:
% If e.s.dontRecordConstantTrajData == 1, then only the first of any directly
% successive data points that have the same position data is kept.
% Setting e.s.dontRecordConstantTrajData to 0 will store the redundant data
% points.
e.s.dontRecordConstantTrajData = 1;



%%%%%%%%%%%%%%%%%%%%%%%%%%%% END OF SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



 
%--------------------------V   MODIFY THIS   V-----------------------------

% Initialize fields of struct e with arrays to store any results data 
% that does not fit into the results matrix ('e.results'), that is,
% anything that is not a scalar or a vector with a fixed number of elements.
% Whatever is specified here should be filled trial-by-trial during the
% experiment so that the order of elements corresponds to rows of
% 'e.results'. Do not forget to insert or skip rows for aborted trials to
% keep that order. Example here: Mouse movement paths for each trial.

e.trajectories = cell(0);

%--------------------------------------------------------------------------


% Initialize results matrix
e.results = [];

% Psychtoolbox settings                       
PsychDefaultSetup(2);               % some default Psychtoolbox settings
Screen('Preference', 'VisualDebuglevel', 3); % suppress PTB splash screen

% Determine experimental screen
screens = Screen('Screens');        % get all connected screens
expScreen = max(screens);           % use last screen as stimulus display

% Load list of trials and settings from file
[e.s.trialsFileName, trialsPath] = uigetfile('*.mat', 'Select trial file.');
load([trialsPath, e.s.trialsFileName]);

% Get/store spatial configuration of experimental setup (serves as input
% to CRF/unit conversion functions)
tmp = get(expScreen,'ScreenSize');
e.s.expScreenSize_px = tmp(3:4);         % get screen res
e.s.spatialConfig.viewingDistance_mm = e.s.viewingDistance_mm;
e.s.spatialConfig.expScreenSize_mm = e.s.expScreenSize_mm;
e.s.spatialConfig.expScreenSize_px = e.s.expScreenSize_px;
e.s.spatialConfig.presArea_va = tg.s.presArea_va;   

% copy experimental setup data (not trials) from trial generation struct
% (tg.s) to experimental output struct (e.s); except for tg.s.triallistCols.
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
 
% Request save path or warn in case saving is disabled
if doSave   
    savePath = requestSavePath(e.s.experimentName);    
else
    resp = ...
    questdlg('Saving is disabled, results will not be recorded.', 'Warning', ...
                'Continue without saving','Abort', 2);
    if strcmp(resp, 'Abort')
        return
    end  
end

% Transfer trial data to variables that will be used throughout rest of code  
trials = tg.triallist;
triallistCols = tg.s.triallistCols;
clear tg; % tg won't be needed anymore

% Convert color-defining field in e.s from strings to RGB
colorDefinition;

% Hide mouse cursor
HideCursor;

% Construct e.s.resCols (holds column indices for 'e.results'. It is
% initialized here by transferring the indices from 'triallistCols', since
% on each trial not only results are stored in 'e.results', but also all
% trial properties).
createResCols;



%--------------------------V   MODIFY THIS   V-----------------------------

% Add any PTB windows that you may need in this file.

% Open PTB windows
openPTBWindows;

%--------------------------------------------------------------------------


%--------------------------V   MODIFY THIS   V-----------------------------

% Modify this file as needed to draw static graphics like fixation cross etc.

% Draw graphics that are reused in same form each trial.
drawStaticGraphics;

%--------------------------------------------------------------------------


%--------------------------V   MODIFY THIS   V-----------------------------

% Add any instructions that you need to show to the participants. Use
% ShowTextAndWait multiple times if you need multiple successive panels.

% Show welcome text and wait for button press
ShowTextAndWait(...
    'Bereit. Zum Starten des Experiments beliebige Taste drück en!', ...
    e.s.instructionTextColor, winOn.h, 0.5, true);

%--------------------------------------------------------------------------



%%%% Trial loop

curTrial = 1;
sequNum = 0;
while curTrial <= size(trials,1)
    
    % Initialize / empty some things            
    for osw = fieldnames(winsOff)'  
        osw = osw{1};
        Screen('FillRect', winsOff.(osw).h, winsOff.(osw).bgColor);
    end
    out = struct();    
    trajectory = nan(20000, max(structfun(@(x) x, e.s.trajCols)));
    
    % increment sequential number for output
    sequNum = sequNum + 1;       
    
    % Check whether pause key is being pressed, if so, halt execution and
    % close PTB windows. Reopen if resumed.
    pauseAndResume;
    
    
    %--------------------------V   MODIFY THIS   V-------------------------    
       
    % Draw things that change from trial to trial (i.e., stimuli) to
    % offscreen windows, to use it in singleTrial.m below.
    drawStimuli;
    
    % Edit this script to adjust what happens in each trial. Only this file
    % should assign to struct 'out'.
    singleTrial;          

    %----------------------------------------------------------------------
    
    
    updateResCols;    % extend e.s.resCols with column numbers for fields
                      % in struct 'out' (which stores results of one trial)
    storeResults;     % store contents of fields of 'out' in the correspon-
                      % dingly named columns of e.results.    
    storeTrajectory;  % store trajectory in e.trajectories (empty cell if
                      % trial was aborted before recording started)
    insertAbortedTrial; % if trial was aborted, shuffle it into the
                        % remaining trial list to be redone later at a
                        % random time point 
     
    if doSave
        save(savePath, 'e');
    end
    
    % go to next trial... 
    curTrial = curTrial + 1; 
    
end


    
%--------------------------V   MODIFY THIS   V-----------------------------  

% Use ShowTextAndWait multiple times if required.

% Things to be presented after the experiment

% Show goodbye message and wait for button press
ShowTextAndWait(...
    'Experiment beendet. Vielen Dank für die Teilnahme!', ...
    e.s.instructionTextColor, winOn.h, 0.5, true);

%--------------------------------------------------------------------------



%%% Clean up

Screen('closeall');
ShowCursor;


