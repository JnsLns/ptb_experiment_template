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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% GENERAL TODO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check that all necessary things are converted from trial generation frame
% to PTB frame (and back if required).

% Pointer calibration

% set e.s.pointer.VelocityThreshold and e.s.pointer.DistanceThreshold
% somwhere

% tip position must be transformed to Psychtoolbox frame for drawing (but
% not for results (?)

% Adjust trial abortion codes to the new phases

% Experiment struct should be self-contained, so that struct tg is not
% required for analysis (in other words, copy everything to that struct)

% Add experiment/settings identifier to trial generation data and carry
% that over to the experiment output data

% The checks for starting position being assumed and held throughout
% fixation phase may (didn't test) need some sluggishness over time to not
% be disrupted by marker jumps. on the other hand, bad data should be
% filtered out anyway and replaced by last good data, so that should do the
% trick unless there are types of marker jumps that are not caught by this.

% Prepare target response screen

% TODO: Adjust for stimulus line width when defining size in trial
% generation (stims should still be as large as defined by h and v).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% NOTES FOR TRIAL GENERATION %%%%%%%%%%%%%%%%%%%%%%%%%
tg.presArea_va = [20, 15]; % size of presentation angle in degrees visual angle
                           % must be specified during trial generation

% item positions   in visual angle, relative to presentation area bottom left
% item w/h         visual angle

% viewing distance as well as screen size (both in millimeters and pixels
% can be set (more or less) freely during the experiment, allowing to use
% the same setup on different monitors, all sizes etc will be computed
% based on settings from trial generation. Make help such as, when the
% monitor is smaller than the required size of the presentation area,
% prompt the user to decrease viewing distance.

% Radius of fixation cross (visual angle)
% tg.fixRadius_va = 0.5;

% Line width of fixation cross (visual angle)
% tg.fixLineWidth_va = 0.1;

% Color of fixation cross
% tg.fixColor = white;

% Pointer tip starting position that has to be assumed at the outset of
% trial. Row vector x,y,z in presentation area frame (mm). Should be in the
% center
% tg.startPos_mm 

% Radius around tg.startPos_mm in which pointer tip has to be to count as
% being on the starting position
% tg.startRadius_mm 

% tg.cursorRad_va

% tg.circleLineWidth_va

% tg.durOnStart

% tg.durPreStimFixation

% tg.durItemPresentation

% tg.allowedLocResponseTime

% tg.allowedTgtResponseTime

% tg.zZeroTolerance % pointer's absolute z-value must be below this value
                    % for response to be registered

% tg.pointerStartAngle  % max angle (deg) of lines from pointer tip to
                        % pointer markers with z-axis during start phase
                    
% tg.circleColor_Ok
% tg.circleColor_notOk

% tg.yesKeyName % should be 'return'
% tg.noKeyName; % should be '.'

% needed in tg.triallistCols (the values in these should be in visual angle)
%tg.triallistCols.vertPosStart;  % positions
%tg.triallistCols.vertPosEnd;
%tg.triallistCols.horzPosStart;
%tg.triallistCols.horzPosEnd;
%tg.triallistCols.vertExtStart;  % extent
%tg.triallistCols.vertExtEnd;
%tg.triallistCols.horzExtStart;
%tg.triallistCols.horzExtEnd;
%tg.triallistCols.stimIdentitiesStart;   % shape codes corresponding to tg.StimShapes        
%tg.triallistCols.stimIdentitiesEnd;        
%tg.triallistCols.stimColorsEnd;         % stim color codes corresponding to tg.stimColors
%tg.triallistCols.stimColorsEnd;   
%tg.triallistCols.stimLineWidthsStart;   % actual line width (not codes)     
%tg.triallistCols.stimLineWidthsEnd;     

% NOTE: Regardless of the length of the number of elements covered by the
% above spans of columns, items can be left unspecified by putting nan in
% the stimIdentities column.


% cell array with letter specifications for function lineItem
                                           % 0  = O (tgt)
%tg.stimShapes{1} = {[1,3,9]};             % 1  = L
%tg.stimShapes{2} = {[1,9],[3,7]};         % 2  = X
%tg.stimShapes{3} = {[4,6],[1,7],[3,6]};   % 3  = I
%tg.stimShapes{4} = {[1,3,5,9,7]};         % 4  = W
%tg.stimShapes{5} = {[7,1,3],[2,8]};       % 5  = F
%tg.stimShapes{6} = {[3,1,5,7,9]};         % 6  = M
%tg.stimShapes{7} = {[7,1,3,9],[2,8]};     % 7  = E
%tg.stimShapes{8} = {[1,3],[2,8],[7,9]};   % 8  = H
%tg.stimShapes{9} = {[1,6,7]};             % 9  = V
%tg.stimShapes{10} = {[1,7,3,9]};          % 10 = Z
%tg.stimShapes{11} = {[1,7],[4,6]};        % 11 = T
%tg.stimShapes{12} = {[1,5,7],[5,6]};      % 12 = Y
%tg.stimShapes{13} = {[3,1,9,7]};          % 13 = N
                                           

% stim color specification. color codes in triallist should correspond to
% element number in this array. Adjust these to have the correct colors
% used by Hazeltine!
%tg.stimColors{1} = [1 0 0]; % red
%tg.stimColors{2} = [0 1 0]; % green
%tg.stimColors{3} = [0 0 1]; % blue
%tg.stimColors{4} = [1 1 0]; % yellow
%tg.stimColors{5} = [0 0 0]; % black
%tg.stimColors{6} = [1 1 1]; % white                                               
                                               

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% NOTES FOR ANALYSIS %%%%%%%%%%%%%%%%%%%%%%%%%

% e.trials_main is now e.trials

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
load('trials_main.mat');

% Fields and number of columns for e.s.resCols (struct holding column
% indices of results matrix)
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
             

% Regarding recording of trajectories:
% If e.s.dontRecordConstantTrajData == 1, then only the first one of any directly
% successive data points that have the same position data is kept.
% Setting e.s.dontRecordConstantTrajData to 0 will store the redundant data
% points.
e.s.dontRecordConstantTrajData = 1;



                        %%%% END OF SETTINGS %%%

                        
%% Preparations



%%%%% Unit / coordinate frame conversions from trial list to Psychtoolbox

% Explanation: Position and size values in the trial list are given as
% either millimeters or degrees of visual angle, in a coordinate frame with
% origin at the bottom left of the presentation area, x-axis increasing to
% the right, and y-axis increasing upward. Psychtoolbox needs them in
% pixels in a coordinate frame with origin at top left of visible screen
% area, x-axis increasing to the right, and y-axis increasing downward.
% There are functions in the private directory that allow converting
% between, degrees visual angle, millimeters, pixels and the different
% coordinate.  

% Get/store spatial configuration of experimental setup

% Gather all values defining spatial configuration of experimental setup in
% struct 'e.s.spatialConfig'. Serves as input to the conversion functions in
% private directory. 
e.s.expScreenSize_px = get(expScreen,'ScreenSize');
e.s.expScreenSize_px = e.s.expScreenSize_px(3:4);         % get screen res
e.s.spatialConfig.viewingDistance_mm = e.s.viewingDistance_mm;
e.s.spatialConfig.expScreenSize_mm = e.s.expScreenSize_mm;
e.s.spatialConfig.expScreenSize_px = e.s.expScreenSize_px;
e.s.spatialConfig.presArea_va = tg.presArea_va;


% Transfer data from trial generation to experiment struct (so that it is
% self-contained and not data from trial generation needs to be used during
% analysis).
e.trials = tg.triallist;
e.s.triallistCols = tg.triallistCols;
e.s.fixRadius_va = tg.fixRadius_va;
e.s.fixLineWidth_va = tg.fixLineWidth_va;
e.s.fixColor = tg.fixColor;
e.s.startPos_mm = tg.startPos_mm;
e.s.startRadius_mm = tg.startRadius_mm;
e.s.cursorRad_va = tg.cursorRad_va;
e.s.circleLineWidth_va = tg.circleLineWidth_va;
e.s.durOnStart = tg.durOnStart;
e.s.durWaitForStart = tg.durWaitForStart;
e.s.durPreStimFixation = tg.durPreStimFixation;
e.s.durItemPresentation = tg.durItemPresentation;
e.s.allowedLocResponseTime = tg.allowedLocResponseTime;
e.s.allowedTgtResponseTime = tg.allowedTgtResponseTime;
e.s.zZeroTolerance = tg.zZeroTolerance;
e.s.pointerStartAngle = tg.pointerStartAngle;
e.s.circleColor_notOk = tg.circleColor_notOk;
e.s.circleColor_ok = tg.circleColor_ok;
e.s.yesKeyName = tg.yesKeyName;
e.s.noKeyName = tg.noKeyName;
e.s.stimShapes = tg.stimShapes;
e.s.stimColors = tg.stimColors;
 



% -------------------------------------------------------------------------
% NOT ANY MORE.... !!! FROM HERE ON POSITIONS IN PIXELS AND PTB-COORDINATES; UNTIL RESULTS...
% -------------------------------------------------------------------------
% TODO: Is that required???? Actually, PTB coordinates are needed only for
% drawing! Everything else can stay in the pres area based frame, since
% this frame is also used when storing results... so maybe this conversion
% from trial generation to PTB frame should better be done on demand at
% those locations where the values are used. may even be more transparent.
% Also, it is easier to remember transforming where it is relevant (and
% remembering which values have already been transofmred, as it is done "on
% site".
% HOWEVER, a new conversion function is needed that converts from/to(?) the
% screen-marker based reference frame, in order to map between pointer
% positions and the other frames! And since item positions etc are stored
% in the results matrix in the crf relative to the bottom left corner of the
% presentation are, we also need to convert from the trajectories in the
% screen-marker based crf to the presentation area frame.

%%%% Pointer Calibration

% while 1 % left when calibration successful
%     
%     [e.s.pointer.coefficients, e.s.pointer.expectedDistances, ...
%       e.s.pointer.markerPairings, e.s.pointer.markerIDs] = ...
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



%%%% Initialize output arrays

e.results = []; 
e.trajectories = cell(size(e.trials,1),1);



%%%% Create results file (and save calibration data in it)

save(savePath, ...
    'e', ...    % from experiment (settings, triallist, results, trajectories)
    'tg'...     % data from trial generation
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



%%%% Temporary conversions for convenience, used in the single trial script.

cursorRad_px = vaToPx(e.s.cursorRad_va, e.s.spatialConfig);
circleLineWidth_px = vaToPx(e.s.circleLineWidth_va, e.s.spatialConfig);


%%%% Things to be presented before the experiment (e.g., instructions)

% Show welcome text and wait for button press
ShowTextAndWait(...
    'Bereit. Zum Starten des Experiments beliebige Taste dr�cken!', ...
    e.s.textColor, winOn.h, 0.5, true);



%%%% Trial loop

curTrial = 1;

while curTrial <= size(e.trials,1)
    
    singleTrial;  
        
    curTrial = curTrial + 1;
    
end



%%%% Things to be presented after the experiment

% Show goodbye message and wait for button press
ShowTextAndWait(...
    'Experiment beendet. Vielen Dank f�r die Teilnahme!', ...
    e.s.textColor, winOn.h, 0.5, true);



%%% Clean up

Screen('closeall');
ShowCursor;




