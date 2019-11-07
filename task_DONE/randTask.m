%% Illusory conjunction task for motion tracker hardware
% Jonas Lins, October 2019



%                  _____Script input and output_____
%
%
% Trial generation --> struct 'tg', stored in each trial file and loaded
%                      in the current script anew for each participant.
%                      Fields:
%
%                      tg.triallist     Matrix, rows are individual trials
%                                       columns are trial properties
%                      tg.s.triallistCols Struct, each of whose fields holds
%                                       an integer that can be used to
%                                       address into the columns of
%                                       tg.triallist. Used to address trial
%                                       properties "by name" instead of
%                                       column number.
%                      tg.s             Struct with various fields that hold
%                                       settings for the experiment that
%                                       apply across trials (e.g.,
%                                       background color).
%
% Experiment (this script) --> struct 'e', stored in each results file
%                              Fields:
%
%                       e.results       Matrix, each row corresponding to
%                                       one presented trial, and columns
%                                       pertaining to different response or
%                                       trial properties.
%                       e.s.resCols     Struct, function analogous to
%                                       'tg.s.triallistCols' (see above)
%                                       but for 'e.results'.
%                       e.s             Struct with various fields that
%                                       hold settings for the experiment
%                                       (including copies of all fields of
%                                       'tg.s', except 'triallistCols')
%
%
%                   _____Specifying outputs_____
%
% An empty struct 'out' is created at the start of the trial loop (i.e.,
% before each trial). Fields can be created in this struct during the trial
% (preferably in singleTrial.m). Values stored in these fields will be
% written to the results matrix in 'e.results', which is generated automatically.
% Also, a struct 'e.s.resCols' is generated, whose fields hold integers that
% can be used to address into columns of e.results "by name". The fields of
% e.s.resCols are named after the fields that exist in 'out' at the end of
% a trial. For instance, if there is a field "out.responseTime = 1150",
% then there will be a field e.s.resCols.responseTime, holding an
% integer. During analysis, the respective column of e.results where
% response time (1150 in this case) is stored can be addressed through
% "e.results(:, e.s.resCols.responseTime)". If the value of a field of 'out'
% is a column vector, then two fields will be generated in e.s.resCols,
% having the same name as the field in 'out', except for the postfix 'Start'
% for one, and 'End' for the other field name. The column vector will be written
% to that span of columns in e.results. For instance, if there is a field
% "out.itemColors = [1,2,3,4]", then there could be fields in e.s.resCols
% such as "e.s.resCols.itemColorsStart = 10" and
% "e.s.resCols.itemColorsEnd = 13" (where the absolute value depends on how
% many fields were created before that); the span of columns can then later
% be addressed through "e.results(:, e.s.resCols.itemColorsStart:e.s.resCols.itemColorsEnd)".
% It is possible to add fields to 'out' that were not used in earlier trials.
% In this case, rows in e.results from preceding trials will be filled with
% nans in these rows. Note however that once a field has been used, the
% objects stored in it must be of the same size in each trial (pad with
% nans if needed); also, the objects in 'out' must be either integers or
% column vectors.

%
%                   _____Experiment settings_____
%
% Most settings for the experiment have to be defined already during trial
% generation and are assumed to be found in struct 'tg.s' loaded from a
% trial file. This ensures that once trials have been generated and saved,
% experiment settings are not changed accidently halfway through
% participants. Note that all fields found in 'tg.s' will be copied to
% 'e.s' here (except for field 'triallistCols') so that 'tg' will not be
% needed for analysis.
%
% There are only a few settings that must be set here in the experimental
% script itself (these are as well stored in 'e.s'), namely those that
% pertain to specific properties of the hardware used or the spatial
% arrangement, such as screen size or viewing distance of the participant.
% These are set here in order to allow things like switching to a different
% screen halfway through participants. The actual sizes of stimuli on
% the screen as well as other spatial properties are computed dynamically
% in the current script based on these settings, so that all distances and
% sizes will automatically adhere to the desired visual angle values
% specified in the trial list.
%
%
%
%                    _____Spatial reference frames_____
%
% SUMMARY: All input and output to and from this script is in the
% presentation-area-based frame and in degrees visual angle EXCEPT for
% trajectory data (which is in the same frame but in millimeters) and very
% few settings that make sense only in millimeters (like physical screen
% size; these are postfixed '_mm') or pixels (like screen resolution;
% postfixed '_px'). 
%
% LONG VERSION: There are three spatial reference frames used here:
%
% -- Presentation-area-based-frame (pa):
% 
% Used for all input to and output from this script, that is, in trial
% generation (struct 'tg' loaded from trial file) and for results output,
% that is, everything that is stored in the output struct 'e'. The origin
% is at the bottom left of the presentation area (rectangular area whose
% size is defined in 'tg' and which is inset in and centered within the
% screen), x-axis increases to the right, y-axis increases upward. Units
% used in conjunction with this frame are degrees of visual angle (va),
% except for very few exceptions, which are: (1) Trajectory data (in
% e.trajectories), which uses this frame but is in millimeters (as visual
% angle does not make much sense for 3D data; the positive z-axis extends
% toward the viewer and is orthogonal to the screen surface) and (2) a few
% settings that make sense only in millimeters (these settings are clearly
% marked by the postfix '_mm' in the fieldname in struct 'e.s').
%
% -- Psychtoolbox frame (ptb):
%
% Used *only* in the internals of the trial script (singleTrial.m) when
% drawing things to the screen via Psychtoolbox. The origin is at the top
% left of the screen, x-axis increasing to the right, y-axis increasing
% downward. Units used in conjunction with this frame are pixels.
%
% -- Screen-marker-based frame (scr):
%
% This is the frame in which pointer position is obtained from function
% getTip_pa (see private folder) during the experiment.
% (Apart from a prespecified offset, as explained below) its origin is at
% the position of the marker mounted at the lower left of the screen's
% visible image area, its positive x-axis points in the direction
% of the marker mounted at the lower right corner of the visible image
% area, the positive x-y-plane is defined by the marker on the top border
% of the visible image (at a positive x-value). The z-axis extends toward
% the viewer. As hinted above, this frame (i.e., what is obtained from
% getTip_pa) is offset in x/y/z direction by the three-element vector in
% e.s.markerCRFoffset_xyz_mm, the main use of which is to shift the
% x-y-plane(z=0) right onto the screen surface despite marker diodes being
% mounted somewhat above the screen surface.
%
%
%
%                 ____CRF/unit conversion functions____
%
% The private folder contains functions that allow converting between the
% different reference frames, by passing the values to be converted 
% plus the struct 'e.s.spatialConfig' (which holds all relevant information
% about the spatial setup, such as viewing distance, screen extent etc).
% All these functions follow the same naming scheme (see the individual
% functions' documentations for more info). Naming examples:
%
% paVaToPtbPx  -->  convert from presentation-area-based frame (pa) in
%                   degrees visual angle (va) to Psychtoolbox frame (ptb)
%                   in pixels (px).
%
% scrMmToPaMm  -->  convert from screen-marker-based frame (scr) in
%                   millimeters (mm) to presentation-area-based frame (pa)
%                   in millimeters (mm).
%
% pxToMm       -->  convert from pixels (px) to millimeters (mm).
%
%
%
%                 _____Conditions, responses & codes_____
%
% Conditions, responses, and response types, plus corresponding column
% names and codes used in 'e.results':
%
%                 TRIAL TYPE     PRESENT RESPONSE       RESPONSE TYPE
% -------------------------------------------------------------------------
% e.s.resCols     .trialType   .tgtPresentResponse      .responseType  
% -------------------------------------------------------------------------
%              tgt present (1) | tgt present (1) | hit                  (1)
%              tgt present (1) | tgt absent  (0) | miss                 (2)
%              both present(2) | tgt present (1) | illusory conjunction (3)
%              both present(2) | tgt absent  (0) | correct rejection BP (4)
%              color only  (3) | tgt present (1) | feature error        (5)
%              color only  (3) | tgt absent  (0) | correct rejection CO (6)
%
%
%
%                   _____Trial abortion & codes_____
%
% Trials may be aborted before completion due to various reasons. Any data
% pertaining to aborted trials will nonetheless be stored in e.results,
% including an abort code (column number is e.s.resCols.abortCode) giving
% the reason for abortion. These are:
%
% 0     trial completed
% 1     not moved to starting position in time
% 2     moved off starting position during fixation phase
% 3     moved off starting position during stimulus presentation
% 4     exceeded max RT for location response
% 5     exceeded max RT for target presence response
%
% Any missing results values for prematurely aborted trials (e.g., response
% correctness) will be nan in 'e.results' and cells in 'e.trajectories' will
% contain an empty matrix if recording has not started yet (if abortion
% instead occurs during recording, an incomplete trajectory will be stored).



%%%% Basic settings

PsychDefaultSetup(2);               % call some settings for Psychtoolbox
screens = Screen('Screens');        % get connected screens
expScreen = max(screens);           % use last screen as stimulus display
Screen('Preference', 'VisualDebuglevel', 3); % suppress PTB splash screen
Screen('Preference','SkipSyncTests',1); % use when debugging without
% in windowed mode


%%%% Settings needed for every paradigm

% will be appended to each results file name
experimentName = 'my_exp';

% actual screen size in mm (actual image area)
%e.s.expScreenSize_mm = [474, 291]; % Miro
e.s.expScreenSize_mm = [531 299]; % Gecko

% Participant's distance from screen in millimeters
e.s.viewingDistance_mm = 500;

% Define colors
white = WhiteIndex(expScreen);
black = BlackIndex(expScreen);
grey = white/2;
e.s.bgColor = grey; % background
e.s.textColor = black;

% name of key to press to pause experiment (to pause, the key needs to be
% depressed at the start of a trial)
pauseKey = 'Pause';

% Load list of trials from mat file
% trials are assumed to be in variable tg.triallist
% column number indices into trials assumed to be in struct triallistCols
load('trials.mat');

% Define column numbers for trajectory matrices 
e.s.trajCols.x = 1; % pointer coordinates
e.s.trajCols.y = 2;
e.s.trajCols.z = 3;
e.s.trajCols.t = 4; % tracker time stamps (compatible with time measure-
                    % ments in e.results if they are postfixed '_tr').
                    
                    
                    
%%% Settings that are specific to the current paradigm

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



%%%% Trial data variables (used in rest of experiment)

trials = tg.triallist;
triallistCols = tg.s.triallistCols;




%%%% Initialize output arrays

e.results = [];
e.trajectories = cell();




%%%% Ask for save path

savePath = requestSavePath(experimentName);



%%%% Pointer Calibration

[e.s.pointer.coefficients, e.s.pointer.expectedDistances, ...
    e.s.pointer.markerPairings, e.s.pointer.markerIDs] = ...
    doCalibrationProcedure(pad_tipID, pad_IDs, pointer_IDs);



%%%% Create results file

save(savePath, 'e');



%%%% Open PTB windows & hide cursor

% note: if certain images (e.g. fixation) are repeatedly used in your
% experiment, make a separate offscreen window for each of them. This way
% you need to draw that image once and afterwards only need to copy the
% offscreen window to the onscreen window when the image is needed.
%
% The onscreen window handle is stored in struct winOn.h, as well as the
% window's other properties, e.g., winOn.rect. Offscreen window handles are
% stored as winsOff.windowname.h, and window properties in other fields,
% such as% winsOff.windowname.rect. Additional offscreen windows should be
% stored accordingly, e.g., winsOff.windowname2.h (etc.).

% onscreen window for actual display
winOn.bgColor = e.s.bgColor;
winOn.screen = expScreen;
winOn.rect = [0 0 e.s.expScreenSize_px];
[winOn.center(1), winOn.center(2)] = RectCenter(winOn.rect);
winOn.font = 'Arial';
winOn.fontSize = 25;

[winOn.h, winOn.rect] = ...
    PsychImaging('openWindow', winOn.screen, winOn.bgColor, winOn.rect);
Screen('TextFont', winOn.h, winOn.font);
Screen('TextSize', winOn.h, winOn.fontSize);

% offscreen window to draw stimuli to
winsOff.stims.bgColor = e.s.bgColor;
winsOff.stims.screen = expScreen;
winsOff.stims.rect = winOn.rect;
[winsOff.stims.center(1), winsOff.stims.center(2)] = ...
    RectCenter(winsOff.stims.rect);
[winsOff.stims.h, winsOff.stims.rect] = ...
    Screen('OpenOffScreenWindow', winsOff.stims.screen, ...
    winsOff.stims.bgColor, winsOff.stims.rect);

% empty offscreen window
winsOff.empty.bgColor = e.s.bgColor;
winsOff.empty.screen = expScreen;
winsOff.empty.rect = winOn.rect;
[winsOff.empty.center(1), winsOff.empty.center(2)] = ...
    RectCenter(winsOff.empty.rect);
[winsOff.empty.h, winsOff.empty.rect] = ...
    Screen('OpenOffScreenWindow', winsOff.empty.screen, ...
    winsOff.empty.bgColor, winsOff.empty.rect);

% offscreen window for fixation cross
winsOff.fix.bgColor = e.s.bgColor;
winsOff.fix.screen = expScreen;
winsOff.fix.rect = winOn.rect;
[winsOff.fix.center(1), winsOff.fix.center(2)] = ...
    RectCenter(winsOff.fix.rect);
[winsOff.fix.h, winsOff.fix.rect] = ...
    Screen('OpenOffScreenWindow', winsOff.fix.screen, ...
    winsOff.fix.bgColor, winsOff.fix.rect);

% offscreen window for target presence response
winsOff.targetResponse.bgColor = e.s.bgColor;
winsOff.targetResponse.screen = expScreen;
winsOff.targetResponse.rect = winOn.rect;
[winsOff.targetResponse.center(1), winsOff.targetResponse.center(2)] = ...
    RectCenter(winsOff.targetResponse.rect);
[winsOff.targetResponse.h, winsOff.targetResponse.rect] = ...
    Screen('OpenOffScreenWindow', winsOff.targetResponse.screen, ...
    winsOff.targetResponse.bgColor, winsOff.targetResponse.rect);

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





