%% Illusory conjunction task for motion tracker hardware
% Jonas Lins, October 2019


% The columns of one trajectory matrix contain the following data:
%
e.s.trajCols.x = 1;
e.s.trajCols.y = 2;
%   -- 3: time values for each data points in seconds since system
%         startup (compatible with other time values stored in e.results).
e.s.trajCols.t = 3;

% PRELIMINARY NOTE
%
% All input and output is now in millimeters and in a coordinate system
% with origin at bottom left of presentation area (the size of whcih is
% determined by tg.presArea_mm loaded from trial file) and with y-axis
% increasing upward, x-axis increasing rightward. The inner workings of
% this script use PTB- coordinate frame in pixels (see conversion below).
% Output is again in the former coordinate frame and in millimeters (so
% no need to convert coordinates in analysis)

% struct tg is loaded from trials file and supplies all settings defined
% during trial generation; spatial coordinates in it are in millimeters and
% in a frame with origin at bottom left of the presentation area (defined
% itself by presArea_mm providing horizontal and vertical extent on the
% screen), x-axis increasing to the right, y-axis increasing upwards).
%
% struct e is created in this script and holds settings for the current
% run of the experiment as well as results and information about each trial
% (e.results) and corresponding trajectories (e.trajectories).







%%%% Basic settings

experimentName = 'my_exp'; % will be appended to each results file name

PsychDefaultSetup(2);               % call some settings for Psychtoolbox
screens = Screen('Screens');        % get connected screens
expScreen = max(screens);           % use last screen as stimulus display
Screen('Preference', 'VisualDebuglevel', 3); % suppress PTB splash screen
Screen('Preference','SkipSyncTests',1); % use when debugging without
% in windowed mode



%%%% Hardware settings

% actual screen size in mm (actual image area)
%e.s.expScreenSize_mm = [474, 291]; % Miro
e.s.expScreenSize_mm = [531 299]; % Gecko

% marker IDs [TCMID1,LEDID1;TCMID2,LEDID2]
e.s.markers.pad_tipID = [3,1];                  % calibration pad: ID of tip marker
e.s.markers.pad_IDs = [3,2; 3,3; 3,4];          % calibration pad: ID of other markers
e.s.markers.pointer_IDs = [3,6; 3,7; 3,8];      % pointer: IDs of markers on pointer
e.s.markers.coordinate_IDs = [3, 10; 3,9; 3,11];% IDs of markers defining coordinate
% frame (origin, pos x axis, x-y-plane)



%%%% Misc settings

% Define colors
white = WhiteIndex(expScreen);
black = BlackIndex(expScreen);
grey = white/2;
e.s.bgColor = grey; % background
e.s.textColor = black;

% Participant's distance from screen in millimeter
e.s.viewingDistance_mm = 500;

% Radius of fixation cross (visual angle)
e.s.fixRadius_va = 0.5;

% Line width of fixation cross (visual angle)
e.s.fixLineWidth_va = 0.1;

% Color of fixation cross
e.s.fixColor = white;

% name of key to press to pause experiment (to pause, the key needs to be
% depressed at the start of a trial)
pauseKey = 'Pause';

% Regarding recording of trajectories:
% If e.s.dontRecordConstantTrajData == 1, then only the first one of any directly
% successive data points that have the same position data is kept.
% Setting e.s.dontRecordConstantTrajData to 0 will store the redundant data
% points.
e.s.dontRecordConstantTrajData = 1;

% Load list of trials from mat file
% trials are assumed to be in variable tg.triallist
% column number indices into trials assumed to be in struct triallistCols
load('trials_main.mat');
e.trials_main = tg.triallist;

% Fields and number of columns for e.s.resCols (columns of results matrix)
resColsFields = ...
    {'trialID', 1; ...
     'correct', 1; ...
     'stimOnset_pc', 1; ...
     'moveOnset_pc', 1; ...
     'moveOffset_pc', 1; ...
     'reactionTime_pc', 1; ...
     'movementTime_pc', 1; ...
     'responseTime_pc', 1; ...
     'horzPos', tg.gen.noOfItems; ...
     'vertPos', tg.gen.noOfItems; ...
     'colors', tg.gen.noOfItems ...
     };

 
%% Preparation of CRF and unit conversion

% ---TODO---
% tg.presArea_va  define in trial generation 
% item positions   define in trial generation (visual angle, relative to presentation area bottom left)
% item w/h         define in trial generation (visual angle) 

e.s.expScreenSize_px = get(expScreen,'ScreenSize');
e.s.expScreenSize_px = e.s.expScreenSize_px(3:4);

% TODO TEMP ... !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
tg.presArea_va = [20, 15]; % must be specified during trial generation!

% TEST THE CONVERSION /TRANSFORMATION FUNCTIONS!!!

% TODO TEMP ... !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



% All values defining spatial configuration of experimental setup are
% gathered here. This may serve as input to CRF and unit conversion
% functions.
spatialConfig.viewingDistance_mm = e.s.viewingDistance_mm;
spatialConfig.expScreenSize_mm = e.s.expScreenSize_mm;
spatialConfig.expScreenSize_px = e.s.expScreenSize_px;
spatialConfig.presArea_va = tg.presArea_va;




%%%% Convert triallist data to PTB-coordinates in pixels

% TODO: Other stimulus aspects might need conversion as well.

trials = e.trials_main;

vps = tg.triallistCols.vertPosStart;  vpe = tg.triallistCols.vertPosEnd;
hps = tg.triallistCols.horzPosStart;  hpe = tg.triallistCols.horzPosEnd;

trials(:, hps:hpe) = paVaToPtbMm(trials(:, hps:hpe));
trials(:, vps:vpe) = paVaToPtbMm(trials(:, vps:vpe));



 
 
%% Preparations


%%%% Pointer Calibration

% while 1 % left when calibration successful
%     
%     [coeffs, expectedDistances, markerPairings, TCM_LED_IDs] = ...
%         doCalibrationProcedure(pad_tipID, pad_IDs, pointer_IDs);
%     
%     % TODO: Validate calibration in some way
%     break
%     
% end



%%%% compute numbers for columns of results matrix and store in e.s.resCols

tg.gen.noOfItems = 5;

e.s.resCols = struct;
for row = 1:size(resColsFields, 1)
    fName = resColsFields{row, 1};
    nCols = resColsFields{row, 2};
    e.s.resCols = colStruct(fName, nCols, e.s.resCols);
end



%%%% Ask for save path 

savePath = requestSavePath(experimentName);



% -------------------------------------------------------------------------
% FROM HERE ON POSITIONS IN PIXELS AND PTB-COORDINATES; UNTIL RESULTS...
% -------------------------------------------------------------------------



%%%% Initialize output arrays

e.results = []; 
e.trajectories = cell(size(trials,1),1);



%%%% Create results file (and save calibration data in it)

save(savePath, ...
    'e', ...    % from experiment (settings, results, trajectories)
    'tg'...     % from trial generation
    );



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
    Screen('OpenOffScreenWindow', winsOff.stims.screen, winsOff.stims.bgColor, winsOff.stims.rect);

% empty offscreen window
winsOff.empty.bgColor = e.s.bgColor;
winsOff.empty.screen = expScreen;
winsOff.empty.rect = winOn.rect;
[winsOff.empty.center(1), winsOff.empty.center(2)] = ...
    RectCenter(winsOff.empty.rect);
[winsOff.empty.h, winsOff.empty.rect] = ...
    Screen('OpenOffScreenWindow', winsOff.empty.screen, winsOff.empty.bgColor, winsOff.empty.rect);

% offscreen window for fixation cross
winsOff.fix.bgColor = e.s.bgColor;
winsOff.fix.screen = expScreen;
winsOff.fix.rect = winOn.rect;
[winsOff.fix.center(1), winsOff.fix.center(2)] = ...
    RectCenter(winsOff.fix.rect);
[winsOff.fix.h, winsOff.fix.rect] = ...
    Screen('OpenOffScreenWindow', winsOff.fix.screen, winsOff.fix.bgColor, winsOff.fix.rect);


% Hide mouse cursor
HideCursor;



%%%% Things to be presented before the experiment (e.g., instructions)

% Show welcome text and wait for button press

DrawFormattedText(winOn.h, ...
    'Bereit. Zum Starten des Experiments beliebige Taste drücken!', ...
    'center', 'center', e.s.textColor);

Screen('Flip', winOn.h, []);

KbWait;

WaitSecs(0.5);
 


%%% Trial loop

curTrial = 1;

while curTrial <= size(trials,1)
    
    singleTrial;  
        
    curTrial = curTrial + 1;
    
end



%%%% Things to be presented after the experiment

DrawFormattedText(winOn.h, ...
    'Experiment beendet. Vielen Dank für die Teilnahme!', ...
    'center', 'center', e.s.textColor);

Screen('Flip', winOn.h, []);

KbWait;

WaitSecs(0.5); 

Screen('closeall');



%%% Unhide cursor
ShowCursor;




