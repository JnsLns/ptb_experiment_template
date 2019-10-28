%% Illusory conjunction task for motion tracker hardware
% Jonas Lins, October 2019



% New things for documentation %%%%%%%%%%%%%%%%%%
%
% There are three reference frames at work here: PTB (only used temporally
% for drawing etc., stored nowhere), presentation area (used in trial
% generation and for anything stored in struct e, i.e., results and trial
% info), screen-marker based* (the frame in which pointer position is
% obtained from transformedTipPosition; only used when obtaining that
% position; transformed to presentation-area-frame for results). In other
% words, *everything* stored anywhere is in the presentation-area-based
% frame.
% * the origin marker is at the lower left of the screen's visible image,
%   the marker on the x-axis at the lower right, and the marker in the
%   positive x-y-plane needs to be on the top border of the visible image.

% Trial abort codes
%
% 0     trial completed
% 1     not moved to starting position in time
% 2     moved off starting position in fixation phase
% 3     moved off starting position during stimulus presentation
% 4     exceeded max RT for location response
% 5     exceeded max RT for target presence response
%
% note that any missing results values for aborted trials will be
% nan in e.results, while cells in e.trajectories will contain an empty
% matrix.


% viewing distance as well as screen size (both in millimeters and pixels
% can be set (more or less) freely during the experiment, allowing to use
% the same setup on different monitors, all sizes etc will be computed
% based on settings from trial generation. Make help such as, when the
% monitor is smaller than the required size of the presentation area,
% prompt the user to decrease viewing distance.


% Conditions, responses and response types (and codes)
%
%    TRIAL TYPE     PRESENT RESPONSE       RESPONSE TYPE
% -------------------------------------------------------------
% tgt present (1) | tgt present (1) | hit                   (1)
% tgt present (1) | tgt absent  (0) | miss                  (2)
% both present(2) | tgt present (1) | illusory conjunction  (3)
% both present(2) | tgt absent  (0) | correct rejection BP  (4)
% color only  (3) | tgt present (1) | feature error         (5)
% color only  (3) | tgt absent  (0) | correct rejection CO  (6)


% Units and coordinate frames in tg, e.results, and e.trajectories:
%
% -- tg:
% Distance and position values from trial generation (i.e., those in tg.s
% as well as in tg.triallist) are in visual angle unless the corresponding
% fieldname in tg.s or tg.triallistCols is postfixed with '_mm'. They are
% defined in a coordinate frame with origin at the bottom left of the
% presentation area, x-axis increasing to the right, y-axis increasing
% upward. Z-axis, where applicable, is taken to extend toward the
% participant.
%
% -- e.results:
% The same is true for position values in e.results: they are in visual
% and in the presentation-area-based coordinate frame.
%
% -- e.trajectories: 
% Trajectory data in e.trajectories is in the same coordinate frame but in
% millimeters (since visual angle does not make sense for the z-axis)!

% Any pseudo-randomization in terms of trial order has to be done when
% constructing the triallists... (i.e., outside the experiment script)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%% NECESSARY CHANGES TO ANALYSIS %%%%%%%%%%%%%%%%%%%%%%%

% Aborted trials are now stored, i.e., there are now empty trajectory
% matrices in e.trajectories and partially incomplete results rows (nans).
% This has to be dealt with during analysis.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% GENERAL TODO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Enable multisampling for onscreen window (does it have to be enabled for
% offscreen windows separately?), like this (here, 20 samples are used):
% w =  PsychImaging('openWindow', 0, [0 0 0], [100 100 500 500], [], [], [], 20);

% Pointer calibration... validate it in some way before proceeding.

% The checks for starting position being assumed and held throughout
% fixation phase may (didn't test) need some sluggishness over time to not
% be disrupted by marker jumps. on the other hand, bad data should be
% filtered out anyway and replaced by last good data, so that should do the
% trick unless there are types of marker jumps that are not caught by this.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





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
% TODO : These should perhaps be set during trial generation (tg.s)
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

% Fields and number of columns for e.s.resCols (struct holding column
% indices of results matrix). Note that all data about the corresponding
% trial is appended to each results row (column indices for these are later
% also added to e.s.resCols).
resColsFields = ...
    { ...
    'sequNum', 1; ...
    'reponseID', 1; ...
    'abortCode', 1; ...
    'responseCorrect', 1; ...
    'tgtPresentResponse', 1; ...
    'tgtPresentResponseRT', 1; ...
    'responseType', 1; ...
    'tFixOnset_pc', 1; ...
    'tStimOnset_pc', 1; ...
    'tLocResponseOnset_pc', 1; ...
    'tLocResponseOffset_pc', 1; ...
    'tLocResponseOnset_tr', 1; ...
    'tLocResponseOffset_tr', 1; ...
    'tTgtPresentResponseOnset_pc', 1 ...    
    };

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
e.s.markerCRFoffset_xyz = [0 0 12];

e.s.pointer.VelocityThreshold = 2000;  % velocity threshold beyond which 
                                       % marker movement is considered 
                                       % marker jump and discarded [mm/second]
e.s.pointer.DistanceThreshold = 1;     % distance threshold for marker 
                                       % distance check [mm}

% Regarding recording of trajectories:
% If e.s.dontRecordConstantTrajData == 1, then only the first one of any directly
% successive data points that have the same position data is kept.
% Setting e.s.dontRecordConstantTrajData to 0 will store the redundant data
% points.
e.s.dontRecordConstantTrajData = 1;



                       %%%% END OF SETTINGS %%%%

                       

%%%% Complete settings struct e.s.

% Get/store spatial configuration of experimental setup

% Gather all values defining actual spatial setup with respect to the
% specific hardware and arrangement used when the experiment was conducted.
% --> struct 'e.s.spatialConfig'. Serves as input to CRF/unit conversion
% functions that are found in private directory.
tmp = get(expScreen,'ScreenSize');
e.s.expScreenSize_px = tmp(3:4);         % get screen res
e.s.spatialConfig.viewingDistance_mm = e.s.viewingDistance_mm;
e.s.spatialConfig.expScreenSize_mm = e.s.expScreenSize_mm;
e.s.spatialConfig.expScreenSize_px = e.s.expScreenSize_px;
e.s.spatialConfig.presArea_va = tg.s.presArea_va;

% copy experimental setup data (not trials) from trial generation struct
% (tg.s) to experimental output struct (e.s).

for fn = fieldnames(tg.s)'
    if isfield(e.s, fn{1})
        error(['Field ', fn{1}, ' was about to be copied from tg.s', ...
            ' to e.s, but already exists in e.s']);
    end
    e.s.(fn{1}) = tg.s.(fn{1});
end



%%%% Build e.s.resCols (holds result matrix column number)

% compute numbers for columns of results matrix from definition in the
% experiment settings and store in e.s.resCols

e.s.resCols = struct;
for row = 1:size(resColsFields, 1)
    fName = resColsFields{row, 1};
    nCols = resColsFields{row, 2};
    e.s.resCols = colStruct(fName, nCols, e.s.resCols);
end

% add row numbers to e.s.resCols that correspond to trial data

% When results are written to e.results, each trial row will be appended
% to the corresponding results row. Thus, addressing the resulting columns
% will be possible through the numbers in tg.triallistCols plus the length
% of each results column.
maxCol = max(structfun(@(x) x, e.s.resCols)); % max column in use
% iterate over fields of tg.triallistCols, add maxCol to each entry, and
% store in new field with same name in e.s.resCols.
for fn = fieldnames(tg.triallistCols)'
    if isfield(e.s.resCols, fn{1})
        error(['Field ', fn{1}, ' was about to be copied from tg.triallistCols', ...
            ' to e.s.resCols, but already exists in e.s.resCols.']);
    end
    e.s.resCols.(fn{1}) = tg.triallistCols.(fn{1}) + maxCol;
end



%%%% Trial data variables (used in rest of experiment)

trials = tg.triallist;
triallistCols = tg.triallistCols;




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

% note: add offscreen windows if images (e.g. fixation) are repeatedly used.
% onscreen window handle is stored in struct winOn.h, as well as other
% properties, e.g., winOn.rect. offscreen window handles are stored in
% winsOff.windowname.h, as well as properties in other fields, e.g.,
% 'winsOff.windowname.rect'. Additional offscreen windows should be
% stored accordingly, E.g., winsOff.windowname2.h (etc.).

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
    sequNum = sequNum + 1;
    singleTrial;
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





