% Relational pointing task
% Jonas Lins, March 2015

% Todo Note: The RT adjustment block if-condition has been
% changed to avoid being triggered on trial 1 (check again whether 
% that is correct). This also has to be done in the mouse based
% version. Second, the start circle has been increased in size 
% a little, which also hasn't been transferred. Third, the distance
% of the array and no-region has been reduced, likewise not trasnferred.


% IMORTANT NOTE: PTB-SynctestS are disabled due to problems with the Samsung
%                screen, millisecond-precision timing on Matlab side is
%               therefore not ensured.
%
%
%
% General notes:
%
% - General procedure to start experiment, with current marker setup:
%   (1) Start VzAutoCal and calibrate, (2) start VzSoft, use the following
%   settings (those are overridden by above settings!!! need to be updated!):
%
%   -- AutoCal Settings
%      - jumping filter: yes
%      - smoothing filter: no
%      - adaptive calibration control sample size: 955 (prob. not so relevant)
%
%   -- Operating options in VZsoft
%      - Double sampling on
%      - display each frame: no
%      - use previos good data: no
%      - Minimum signal: 0
%      - Signal quality: 0
%      - Max Z: 10,000
%      - Accumulate data in memory (!)
%   -- Sampling Timing (for 16 markers)
%      - Period: 275 microseconds
%      - Fps (do not set by hand, do not dominate): 181.81 Hz
%      - Signal intermission period: 275 microseconds
%   -- Exposure
%      - Use auto
%      - Auto rate
%   -- Filters
%      - all filters off, except jumping (probably not relevant)
%
%   (3) capture short take with screen-mounted markers 303 (top left),
%   302 (top right), and 304 (bottom left), (4) use to set take-based
%   coordinate frame in VzSoft, where 303 is origin, 302 is on x-axis,
%   and 304 is in x-y plane. (5) Enable markers 301-308 and 201-207
%   (203-207 are mounted on the pointers; 302-304 for CRF; 307 & 308 for
%   pointer calibration) (6) Enable data storing in VzSoft (7) Start capture,
%   (8) Verify that markers are all there in VzSoft GUI and their positions
%   are steady, (9) Run this script.
%
% - Press Pause key at the start of a trial to halt execution and
%   close PsychToolbox windows. After clicking ok in the messagebox, the
%   experiment will resume at the same point.
%
% - Missing trials (due to trials being aborted after moving hand to early
%   or not moving at all for durWaitForReaction seconds) is no problem, 
%   enabling participants to take a break whenever they like by not respon-
%   ding. The respective trials are appended to the end of the experiment
%   (and it is taken care that alternating hand order is retained correctly)
%
% - To construct different trial orders or new trials, use the script
%   generateTrialList.m. Note that the codes used there for colors, spatial
%   terms etc. gain meaning from the concrete assignments in the current
%   script's settings. Note that generateTrialList.m allows only to change
%   colors of stimuli. Anything else needs further trial-specific
%   modifications to the matrix 'stimuli', which require changes not only
%   to the triallist but also to the code in the 'stimuli' section of the
%   current script. (moreover, changing the shape and/or orientation of
%   stimuli requires implementing additional mechanisms for presentation and
%   detecting selection, i.e., whether pointer hovers over stimuli)


% --Output of this script:
%
% - File [ptsID]_results_adjustment.mat (only if adjustment trial are
%   enabled), holding the results of the trials in triallist_RTadjustment.mat
%
% - File [ptsID]_results_main.mat holding the results of the trials in triallist_main.mat
%
% - File [ptsID]_results_practice.mat holding the results of the trials in triallist_practice.mat
%   
% Note: Aborted trials (due to long inactivtiy, moving too early, marker jumps,
% or empty batteries) are not recorded in results (but the trials are
% re-done after all other trials).
%
%
% Each of the files above contains the following data:
%
%
% - calibration data that is needed to directly analyze *.vzp data, namely
%   the variables 'lambdas_right', 'lambdas_left', 'markerIDs', and 'markerRows' (the last two are
%   in fact redundant, but convenient).
%
% - a cell array 'trajectories', where each cell holds the trajectory data
%   of one trial(tip position, not raw markers; in the coordinate reference
%   frame set in VzSoft, that is, usually, origin at top left corner of the
%   screen). The columns of one trajectory matrix contain the following data:
%
%       -- 1,2: x,y coordinates
%       -- TODO...
%
% - a matrix 'results', with each row holding data about one trial.
%   Columns:
%
%   -- 1:   1 if time from stimulus onset to response (item selection) was
%           longer than maxRT for this trial (this does not mean that the
%           data is useless), 0 otherwise
resCols.slow = 1;
%   -- 2:   number of item chosen by participant (the number refers to the
%           item having the color described by the color code given in column
%           [5+theNumber] i.e. (6-10) in the matrix 'trials';
%           the same information is stored in column [15+theNumber] (i.e.,
%           16-20) of the matrix 'results'.
%           Note that the item colors are given in these matrices as arranged
%           in the stimulus array from left to right, so that the relative position
%           of the chosen item within the array can be discerned from it
%           (as long as the stimulus matrix is constructed that way, i.e.,
%           left to right; this needs to be reconsidered if more complex
%           stimulus arrays are used; ultimately, what the number refer to,
%           are the rows of the stimuli matrix in which the respective
%           stimuli are defined)
resCols.chosen = 2;
%   -- 3:   blockType (1 = spatial phrase, 1 correct item;
%           2 = color-only, two or threecorrect items)
resCols.type = 3;
%   -- 4:   onset of stimulus display, pc time (seconds since system startup)
resCols.stimOnset_pc = 4;
%   -- 5:   start time of movement, pc time (seconds since system startup)
resCols.moveOnset_pc = 5;
%   -- 6:   end time of movement, pc time (seconds since system startup)
resCols.moveOffset_pc = 6;
%   -- 7:   start time of movement, tracker time (the tracker timestamp stored
%           here is that of the pointer-mounted marker that was sampled last in the
%           tracker's sampling sequence, usually the one with the highest
%           marker ID. Only the markers of the pointer relevant for the
%           current trial are considered (left pointer or right pointer).
resCols.moveOnset_tr = 7;
%   -- 8:   end time of movement, tracker time (note from above applies)
resCols.moveOffset_tr = 8;
%   -- 9:   1 if participant passed over a stimulus but did not stay on it;
%           (mostly, this happens when a participant re-decides on the fly
%           which item to choose, but may also result from initial overshoot
%           when quickly pointing at the response item (?); 0 otherwise)
resCols.passed = 9;
%   --10:   maxRT in seconds for this trial (constant for all main trials)
resCols.maxRT = 10;
%
%   ...remaining columns are trial parameters copied from matrix 'trials':
%
%   --11:   trial ID, allowing alignment with input trial matrix loaded at
%           start.
resCols.trialID = 11;
%   --12:   trial type (1 = spatial, 0 = color Only) (same as type above)
resCols.typeFromTriallist = 12;
%   --13:   number of the correct target item (number refers to those
%           columns that hold item information; see notes for column 2)
resCols.tgt = 13;
%   --14:   number of the reference item (notes from 11 apply)
resCols.ref = 14;
%   --15:   code of spatial term used in the trial (actual term depends
%           which one is assigned to the code in the experiment, see settings
%           below for that)
resCols.spt = 15;
%   --16:   The hand with which this trial must be responded to (1 = right, 2 =
%           left)
resCols.hand = 16;
%   --17:   1 if response was correct, 0 otherwise (independent of whether
%           response was fast enough).
resCols.correct = 17;
%   --18:   18 and the remaining columns hold the color codes for the items
%           in the stimulus array, from left to right.
resCols.colorsStart = 18;
resCols.colorsEnd = 29;



%% Basic settings

% Call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
% check screens
screens = Screen('Screens'); % check connected screens
expScreen = max(screens); % use last screen as stimulus display
expScreenSize = get(expScreen,'ScreenSize');
% Hide mouse
HideCursor;

%% Paradigm settings

% suppress PTB splash screen
Screen('Preference', 'VisualDebuglevel', 3);
% Use only when debugging with non-fullscreen (suppresses sync error warning)
Screen('Preference','SkipSyncTests',1);

% actual screen size in mm (refers to visible picture, according to
% position of markers placed in corners)
screen_mm = [1099 617];

% marker IDs [TCMID1,LEDID1;TCMID2,LEDID2;...] of the markers used to determine
% pointer position (the three markers mounted on the pointer); order sensitive!
% Markers must be listed in this matrix in the same order as below and as
% during calibration (with respect to their relative spatial positioning).
% left and right refer to the hand on which the respective pointer is worn
markerIDs_left = [2,2; 2,6; 2,7];
markerIDs_right = [2,3; 2,4; 2,5];

% marker IDs [TCMID1,LEDID1;TCMID2,LEDID2] for pointer calibration (left to
% right, with calibration point below the left-to-right line connecting the
% markers).
markerIDs_calib = [3,8;3,7];
% distance between these markers in mm
markerDist_calib = 80;
% length of perpendicular from line connecting markers to tip position.
markerPerpFromDot_calib = 50;

% general settings

% displacement [x,y] of stimulus array center from screen center in pixels
array_pos_fixed = [0,expScreenSize(4)*0.1];
% displacement [x,y] of "no-area" from screen center in pixels
noArea_pos_fixed = array_pos_fixed + [0 100];
% displacement [x,y] of feedback from screen center in pixels
feedb_pos_fixed = [0,expScreenSize(4)*0.4];
% default horizontal distance between stimus centers (pixels)
stimdist_horz = 110;
% default vertical distance between stimus centers (pixels)
% (only relevant if any stimuli are used that are at different vertical
% positions from each other in the stimulus grid)
stimdist_vert = 110;
% stimulus radius in pixels (if using irregular polygons, this determines
% the radius of the circular "response-sensitive" region around the stimuli)
stim_r = 50;

% Setting for irregular polygon stimuli
% number of vertices for each polygon
polysVerts_num = 12; 
% minimum distance of vertices from stim center (pixels)
polysMin_r = 10;        
% maximum distance of vertices from stim center (pixels)
polysMax_r = stim_r;     
% width of cue-outline around target (in trial type 4)
cueLineWidth = 15; 
% Color of the spatial cue
spatialCueColor = BlackIndex(expScreen);      

% displacement [x,y] of start marker from screen center in pixels
start_pos_fixed = [0,expScreenSize(4)*-0.35];
% start marker radius in pixels
start_r = 16;
% height of "no-area" in pixels
noArea_height = 50;
% magnitude of random offset of phrase string from
% array center (to counteract potential effects of fixed text position)
stringOffset = [expScreenSize(3)*0.2,expScreenSize(4)*0.2];
% number of consecutive seconds that pointer needs to rest on start marker
% before trial proceeds to spatial phrase
durOnStart = 1;
% duration (secs) that spatial phrase is shown
% and spread of random time added to this duration (+/-, uniformly distributed)
durPhraseBase = 2;
durPhraseRand = 0.5;
% distance of pointer from center of start marker that when exceeded is con-
% sidered as marking movement onset (relevant for RT measurement and extract-
% ing trajectories from vzp-data). Should usually be the same as the radius
% of the start marker.
movementOnsetDist = start_r;
% time in seconds that pointer needs to stay within one stimulus in order
% for it to be considered as a response (note. this does not add to the
% measured movement or response time, which both end as the pointer crosses
% the border of the stimulus that is selected as the final response).
durPointerDwell = 0.3;
% time in seconds after which the start marker screen and the stimulus
% display disappear if no response occurs (primarily for case that
% something is wrong with the trackers)
durWaitForReaction = 5;
% display duration of feedback (seconds)
durFeedback = 1;
% absolute z-value [mm] that pointer tip may not exceed. If this values
% is exceeded, the trial is aborted and an appropriate feedback is shown
% (string is defined below). Note that z=0 is about 5 millimeters above
% the surface of the screen, owed to the position of the CRF diodes.
allowedPointerZ = 25;
% allowed variation in distance between fixed marker on pointer glove, 
% compared to their distance during calibration (if exceeded, trial is
% aborted due to probable marker jump) [mm]
markerDistanceThreshold = 10;
% number of marker jumps that need to be detected during movement phase for 
% abort condition to trigger.
jumpAbortCriterion = 5;

% ---- parameters for adjusting array presentation time to pts performance:

% (the trials in the file trials_RTadjustment are used to adjust allowed
% reaction time incrementally, in order to ensure that participants have a
% sense of time pressure and do not dwell about their decision too long
% starting to move only after processing) Note: The adjustment is based only
% on the spatial trials (i.e., trial type 1), not the color-only trials, as the
% latter are typically responded to faster anyway.

% do adjustment? if yes, there needs to be a mat-file called
% 'triallist_RTadjustment.mat', holding a matrix 'adjustmentTrials', in
% which the desired trials for adjustment are specified. These trials are
% presented prior to the actual trials in random order; the length of the
% matrix determines the number of those trials (as it is complete once).
% Note that the number of adjustment trials should be even - otherwise
% there will be two trials for the same hand at the transition from the
% adjustment to the main trial list.
adjustMaxRT = true;
% allowed RT prior to adjustment (timespan from onset of item array to pointer
% crossing the border of the item that is selected for response).
% If this time is exceeded, the trial is not aborted, but subsequent feed-
% back says "too slow" and the trial is marked in column 1 of the results
% matrix (all other data for the trial is recorded as usual).
maxRT_base = 1;
% number of trials after which the proportion of "fast enough" responses is
% checked for the last n trials, and adjustment is performed, if required.
adjustmentEachNTrials = 10;
% desired proportion of "fast enough" trials (aim of adjustment process)
adjustmentTarget = 0.80;
% if adjustment is enabled, the current maxRT is changed by an amount
% of seconds equal to [(adjustmentTarget-propFast)*adjustmentStep] where
% propFast is the proportion of "fast enough" responses in the most recent
% bin of adjustmentEachNTrials trials.
adjustmentStep = 0.25;
        

% ---- practice

% do practice trials? if yes, there needs to be a mat-file called
% 'triallist_practice.mat', holding a matrix 'practiceTrials', in
% which the desired trials for practice are specified. These trials are
% presented prior to the adjustment trials in random order; the length of the
% matrix determines the number of those trials (as it is complete once).
% These trials do not contribute to RT adjustment, nor are any results from
% these trials saved!
% Note that the number of adjustment trials should be even - otherwise
% there will be two trials for the same hand at the transition from the
% practice to the adjustment trial list.
doPractice = true;


% Define colors
white = WhiteIndex(expScreen);
black = BlackIndex(expScreen);
grey = white/2;
stimColors(1,:) = [1 0 0]; % red
stimColors(2,:) = [0 1 0]; % green
stimColors(3,:) = [0 0 1]; % blue
stimColors(4,:) = [1 1 0]; % yellow
% stimColors(5,:) = [1 0 1]; % pink
% stimColors(6,:) = [0 1 1]; % turquoise
noColor = white/1.25;
bgColor = grey; % background
startColor = black; % color of start marker
phraseColor = black;
textColor = black;

% Define color words (should correspond to order of colors defined above)
colStrings{1,1} = 'Rote';  colStrings{1,2} = 'Roten';
colStrings{2,1} = 'Grüne'; colStrings{2,2} = 'Grünen';
colStrings{3,1} = 'Blaue'; colStrings{3,2} = 'Blauen';
colStrings{4,1} = 'Gelbe'; colStrings{4,2} = 'Gelben';
% colStrings{5,1} = 'Pinke'; colStrings{5,2} = 'Pinken';

% Define spatial terms
sptStrings{1} = ' links ';
sptStrings{2} = ' rechts ';

% Feedback text shown when pointer is moved away from start marker
% too early (i.e., during display of the spatial phrase)
earlyString = ['Bitte den Startpunkt erst verlassen, wenn die Punkte erscheinen!', ...
    '\nStarte neuen Durchgang...'];
% Feedback shown when pointer was not moved onto start marker or onto one
% of the stimuli within durWaitForReaction (see above)
noResponseString = ['Maximale Zeit überschritten! ', ...
    '\nStarte neuen Durchgang...'];
% Feedback shown when pointer was moved above allowed z-threshold
% (allowedPointerZ)
liftedPointerString = ['Bitte die Fingerspitze nicht vom Bildschirm abheben! ', ...
    '\nStarte neuen Durchgang...'];
% Feedback shown when marker jump was detectd and trial was aborted due to
% this
markerJumpString = 'Interner Fehler. \nStarte neuen Durchgang...';
% Feedback shown when trial aborted due to empty battery
batteryString = 'Akku erschöpft, bitte ersetzen und Taste drücken. \nWarte...';


% name of key to press to pause experiment (to pause, the key needs to be
% depressed at the start of a trial)
pauseKey = 'Pause';

% shuffle trials (otherwise trials are present in the order as they appeart
% in the matrix loaded)?
shuffleTrials = 1;

% if 1, each trial uses the response hand given in the respective column in
% the loaded trial matrix (the shuffling is automatically adjusted so that
% hands still alternate); if 0, trials are first shuffled, and then the
% hand-column of the resulting matrix is overwritten so that hands
% alternate from trial to trial, starting with the right hand. 
% Thus, with useHandFromTriallist=0 the trial-hand pairing is randomly
% determined for each participant anew (useful if not each trial is done
% for each hand, since in this case it may be difficult to assign hands to
% trial types in a balanced manner). Note1: This only comes to effect if
% shuffleTrials=1. Note2: The results matrix includes the randomly assigned
% hand numbers (i.e., the actual ones) instead of the ones given in the
% loaded file.
useHandFromTriallist = 1;

%% Ask for save path & load/prepare triallists

ptsTag = {''};
while 1
    % Ask for participant number and where to save
    ptsTag = inputdlg('Enter participant code.','Particpant code',1,ptsTag);
    savePath = uigetdir('S:\','Select folder to save results');
    
    % check whether file already exists (if not, break)
    if exist([savePath,[ptsTag{1},'_results_main.mat']],'file') || ...
            exist([savePath,[ptsTag{1},'_results_adjustment.mat']],'file')
        uiwait(msgbox  (['A file with the tag ''' ptsTag{1} ''' already exists at ' savePath '. Click OK to choose another tag or path.'], ...
            'Already exists','modal'));
    else
        break;
    end
end

% Load list of trials from mat file (plus struct triallistCols, which holds column numbers
% for the different trial properties)
load('triallist_main.mat');
practiceTrials = [];
if doPractice
    load('triallist_practice.mat');
end
adjustmentTrials = [];
if adjustMaxRT
    load('triallist_RTadjustment.mat');
end

% Shuffle trial order such that right and left hand trials alternate,
% starting with a right hand trial
if shuffleTrials && useHandFromTriallist
    
    mainTrials_rightHandTrials = mainTrials(mainTrials(:,triallistCols.hand) == 1,:);
    mainTrials_leftHandTrials = mainTrials(mainTrials(:,triallistCols.hand) == 2,:);
    mainTrials_rightHandTrials = mainTrials_rightHandTrials(randperm(size(mainTrials_rightHandTrials,1)),:);
    mainTrials_leftHandTrials = mainTrials_leftHandTrials(randperm(size(mainTrials_leftHandTrials,1)),:);
    mainTrials(1:2:end,:) = mainTrials_rightHandTrials;
    mainTrials(2:2:end,:) = mainTrials_leftHandTrials;
    
    adjustmentTrials_rightHandTrials = adjustmentTrials(adjustmentTrials(:,triallistCols.hand) == 1,:);
    adjustmentTrials_leftHandTrials = adjustmentTrials(adjustmentTrials(:,triallistCols.hand) == 2,:);
    adjustmentTrials_rightHandTrials = adjustmentTrials_rightHandTrials(randperm(size(adjustmentTrials_rightHandTrials,1)),:);
    adjustmentTrials_leftHandTrials = adjustmentTrials_leftHandTrials(randperm(size(adjustmentTrials_leftHandTrials,1)),:);
    adjustmentTrials(1:2:end,:) = adjustmentTrials_rightHandTrials;
    adjustmentTrials(2:2:end,:) = adjustmentTrials_leftHandTrials;
    
    practiceTrials_rightHandTrials = practiceTrials(practiceTrials(:,triallistCols.hand) == 1,:);
    practiceTrials_leftHandTrials = practiceTrials(practiceTrials(:,triallistCols.hand) == 2,:);
    practiceTrials_rightHandTrials = practiceTrials_rightHandTrials(randperm(size(practiceTrials_rightHandTrials,1)),:);
    practiceTrials_leftHandTrials = practiceTrials_leftHandTrials(randperm(size(practiceTrials_leftHandTrials,1)),:);
    practiceTrials(1:2:end,:) = practiceTrials_rightHandTrials;
    practiceTrials(2:2:end,:) = practiceTrials_leftHandTrials;
    
% ... or first shuffle trials and then overwrite hand-column with alternating 
% hands, starting with right hand (thus, the trial-hand pairing is random
% for each participant)
elseif shuffleTrials && ~useHandFromTriallist    
    
    % Shuffle trial order
    mainTrials = mainTrials(randperm(size(mainTrials,1)),:);
    adjustmentTrials = adjustmentTrials(randperm(size(adjustmentTrials,1)),:);
    practiceTrials = practiceTrials(randperm(size(practiceTrials,1)),:);
     
    mainTrials(1:2:end,triallistCols.hand) = 1;
    mainTrials(2:2:end,triallistCols.hand) = 2;
    adjustmentTrials(1:2:end,triallistCols.hand) = 1;
    adjustmentTrials(2:2:end,triallistCols.hand) = 2;
    practiceTrials(1:2:end,triallistCols.hand) = 1;
    practiceTrials(2:2:end,triallistCols.hand) = 2;
end


%% open PTB windows

% onscreen window for actual display
[win, winRect] = PsychImaging('openWindow', expScreen, bgColor);
% Setup text type for onscreen window
Screen('TextFont', win, 'Arial');
Screen('TextSize', win, 25);

% offscreen window for start marker (plus offscreen window for start marker
% version shown when pointer is within start marker)
offwinStartWidth = winRect(3) * 1; % width is 100 percent of onscreen window
offwinStartHeight = winRect(4) * 0.2; % height is 20 percent of onscreen window
[offwinStart, offwinStartRect]  = Screen('OpenOffScreenWindow', expScreen, ...
    bgColor, [0 0 offwinStartWidth offwinStartHeight]);
[offwinStart_on]  = Screen('OpenOffScreenWindow', expScreen, ...
    bgColor, [0 0 offwinStartWidth offwinStartHeight]);

% offscreen window to draw stimuli to
offwinStimsWidth = winRect(3) * 1; % Width is 100 percent of onscreen window
offwinStimsHeight = winRect(4) - offwinStartRect(4); % height is rest of onscreen window
[offwinStims, offwinStimsRect]  = Screen('OpenOffScreenWindow', expScreen, ...
    bgColor, [0 0 offwinStimsWidth offwinStimsHeight]);

% center of offscreen start marker window
[center_offwinStart(1), center_offwinStart(2)] = RectCenter(offwinStartRect);
% center of offscreen stimulus window
[center_offwinStims(1), center_offwinStims(2)] = RectCenter(offwinStimsRect);
% center of onscreen window
[center_win(1), center_win(2)] = RectCenter(winRect);


%% convert positions/sizes to absolute pixel-/mm-based coordinates

% array center and start marker (etc): to pixels to be supplied to PTB functions
array_pos =  [center_win(1) + array_pos_fixed(1), center_win(2) - array_pos_fixed(2)];
feedb_pos =  [center_win(1) + feedb_pos_fixed(1), center_win(2) - feedb_pos_fixed(2)];
start_pos =  [center_win(1) + start_pos_fixed(1), center_win(2) - start_pos_fixed(2)];
noArea_pos = [center_win(1) + noArea_pos_fixed(1), center_win(2) - noArea_pos_fixed(2)];

% start marker and movement onset distance: millimeters (for use with tracker position)
pxPerMm = expScreenSize(3:4)./screen_mm; % conversion factor from px to mm
start_pos_mm = start_pos./pxPerMm;
start_r_mm = start_r/mean(pxPerMm); 
noArea_pos_mm = noArea_pos./pxPerMm;
noArea_height_mm = noArea_height/pxPerMm(2);
movementOnsetDist_mm = movementOnsetDist/mean(pxPerMm);
% the following values are not used in this script, but are saved to the
% results file to be used later in trajectory analysis 
array_pos_mm = array_pos./pxPerMm; 
stimdist_horz_mm = stimdist_horz/pxPerMm(1);
stimdist_vert_mm = stimdist_vert/pxPerMm(2);


%% Pointer Calibration

% parameters of calibration test point (is used after calibration to test
% whether it was successful)
testDot_r = start_r;
testDot_pos = center_win;
testDot_rect = CenterRectOnPoint([0 0 testDot_r*2 testDot_r*2],testDot_pos(1),testDot_pos(2));
testDot_r_mm = testDot_r / mean(pxPerMm);
testDot_pos_mm = testDot_pos ./ pxPerMm;


% do calibration for each hand
handStrings = {'RECHTE','LINKE'};
for currentHand = 1:2
    
    currentHandString = handStrings{currentHand};
    
    while 1 % is left through break if calibration successful
        
        WaitSecs(0.25);
        DrawFormattedText(win, ['Bitte ', currentHandString, ' Fingerspitze auf den roten Punkt legen\nund beliebige Taste drücken!'], ...
            'center', array_pos(2), phraseColor,[],[],[],2);
        Screen('Flip', win, []); % flip from backbuffer to onscreen window (backbuffer is cleared)
        KbWait();
                
        % actual calibration
        
        % calibration uses 2 markers fixed on a plane (note: z coordinate is set to that
        % of the mean of the two marker positions)
        calibPositions = VzGetDat;
        for j = 1:2
            calibMarkerRows(j) = find(calibPositions(:,1) == markerIDs_calib(j,1) & calibPositions(:,2) == markerIDs_calib(j,2));
        end
        calibPositions = calibPositions(calibMarkerRows,3:5);
        cp1 = calibPositions(1,:)';
        cp2 = calibPositions(2,:)';
        v2d = (cp2(1:2)-cp1(1:2));
        v2d = v2d/sqrt(dot(v2d,v2d)); % norm
        u2d = [-v2d(2);v2d(1)];
        posCalibPoint = cp1(1:2) + v2d * markerDist_calib/2 + u2d * markerPerpFromDot_calib;
        posCalibPoint = [posCalibPoint',mean([cp1(3),cp2(3)])];
        
        if currentHand == 1
            [lambdas_right, markerRows_right] = pointerCalibration(markerIDs_right,posCalibPoint);            
            markerRows = markerRows_right;
            lambdas = lambdas_right;
            markerDistances_right = getMarkerDistances(markerRows_right); % also get marker distances            
        elseif currentHand == 2
            [lambdas_left, markerRows_left] = pointerCalibration(markerIDs_left,posCalibPoint);
            markerRows = markerRows_left;
            lambdas = lambdas_left;
            markerDistances_left = getMarkerDistances(markerRows_left); % also get marker distances
        end
        
        WaitSecs(0.5);
        
        % DEBUG (shows pointer pos after calibration)
%         while ~KbCheck  
%         tipPos = tipPosition3d(markerRows,lambdas);
%           Screen('CopyWindow', offwinStart, win, [], AlignRect(offwinStartRect,winRect,'center','bottom'));
%           Screen('DrawDots', win, tipPos(1:2).*pxPerMm, min(63,max(1,round(abs(tipPos(3)/10)))) , white, [], 1);
%           Screen('Flip',win,[]);
%         end
%         WaitSecs(0.5)
        
        % Test calibration by having pts move pointer to known location (if unsuccessful, repeat)
        Screen('FillOval', win, startColor, testDot_rect);
        DrawFormattedText(win, ['Bitte ', currentHandString, ' Fingerspitze auf den Punkt bewegen und beliebige Taste drücken!'], ...
            'center', array_pos(2), phraseColor);
        Screen('Flip', win, []);
        KbWait;
        
        if dist3d(tipPosition3d(markerRows,lambdas),[testDot_pos_mm, 0],[0 0 1]) < testDot_r_mm
            WaitSecs(0.25);
            break;
        else
            DrawFormattedText(win, 'Wiederholung nötig. Starte neu...',  'center', array_pos(2), phraseColor);
            Screen('Flip', win, []);
            WaitSecs(1);
        end
        
    end
    
end

DrawFormattedText(win, 'Bereit. Zum Starten des Experiments beliebige Taste drücken!', ...
    'center', array_pos(2), phraseColor);
Screen('Flip', win, []); % flip from backbuffer to onscreen window (backbuffer is cleared)
KbWait;
WaitSecs(0.5);


%% Trials (initialization ends here)

maxRT = maxRT_base;

%% first (blockType == 0) do practice trials (no adjustment)
% then (blockType == 1) do adjustment trials (determine maxRT)
% then (blockType == 2) do main trials (with fixed maxRT)
for blockType = 0:2 
    
    % Determine the trial type at hand
    switch blockType
        case 0 % practice
            if ~isempty(practiceTrials) % set trial type to 0 if these trials exist
                results = []; % create/ clear results matrix
                saveToFile = [savePath,[ptsTag{1},'_results_practice.mat']]; % string pointing to results file
                trials = practiceTrials; % fill trial matrix with correct trials
            else
                continue; % if no practice trials in the list, got to adjustment trials
            end
        case 1 % adjustment
            if ~isempty(adjustmentTrials) % set trial type to 1 if these trials exist
                results = []; % create/ clear results matrix
                saveToFile = [savePath,[ptsTag{1},'_results_adjustment.mat']]; % string pointing to results file
                trials = adjustmentTrials; % fill trial matrix with correct trials
            else
                continue; % if no adjustment trials in the list, got to main trials
            end
        case 2 % main
            if ~isempty(mainTrials) % set trial type to 1 if these trials exist
                results = []; % create/ clear results matrix
                saveToFile = [savePath,[ptsTag{1},'_results_main.mat']]; % string pointing to results file
                trials = mainTrials; % fill trial matrix with correct trials
            else
                error('No trials in list.'); % if no trials at all: error
            end
    end
    
    % Prepare/clear cells for trajectories and stimCenter data .
    trajectories = cell(size(trials,1),1);
    stimCenters_mm = cell(size(trials,1),1);        
    
    % create results file (and save calibration data in it - these are needed
    % to analyze vzp-files later)
    save(saveToFile, 'results', 'lambdas_right', 'lambdas_left', 'markerIDs_right', ...
        'markerIDs_left', 'markerRows_right', 'markerRows_left', 'start_pos_mm', ...
        'resCols', 'array_pos_mm', 'stimdist_horz_mm', 'stimdist_vert_mm');
    
    
    
    %% trial starts here
    
    
    currentTrial = 1;
    
    while currentTrial <= size(trials,1);
        
        % Check whether pause key is pressed, if so, halt execution, show
        % messagebox; resume/reopen windows when user clicks ok
        if KbCheck
            [~,~,whichKey] = KbCheck;
            keyName = KbName(whichKey);
            if iscell(keyName)
                keyName = keyName{1};
            end
            if strcmp(keyName,pauseKey);
                sca
                uiwait(msgbox('Experiment paused. Press OK to resume.'))
                reopenPsychWindows;
            end
        end
        
        
        %% stimuli
        % (position on grid centered within screen, with center = 0,0)
        
        % construct stimulus array for a trial
        % The matrix that describes the stimulus array has one row per stimulus
        % while the columns refer to:
        % (1) horz position of midpoint in the grid, where 0 is center of array (negative = left)
        % (2) vert position of midpoint in the grid, where 0 is center of array (negative = down)
        % (3) horizontal displacement from standard grid point in pixels
        % (4) vertical displacement from standard grid point in pixels
        % (5) color (index referring to rows in stimColors)
        % (6) diameter
        
        % basic stimulus array
        stimuli = [   -6  0    (stimdist_horz/2)   0   1   stim_r ; ...
                      -5  0    (stimdist_horz/2)   0   1   stim_r ; ...
                      -4  0    (stimdist_horz/2)   0   1   stim_r ; ...
                      -3  0    (stimdist_horz/2)   0   1   stim_r ; ...
                      -2  0    (stimdist_horz/2)   0   1   stim_r ; ...     
                      -1  0    (stimdist_horz/2)   0   1   stim_r ; ...
                      
                       1  0   -(stimdist_horz/2)   0   1   stim_r ; ...
                       2  0   -(stimdist_horz/2)   0   1   stim_r ; ...
                       3  0   -(stimdist_horz/2)   0   1   stim_r ; ...
                       4  0   -(stimdist_horz/2)   0   1   stim_r ; ...   
                       5  0   -(stimdist_horz/2)   0   1   stim_r ; ...   
                       6  0   -(stimdist_horz/2)   0   1   stim_r ; ...                         
                      ];
        
        
        % adjust stimuli array for this trial depending on current trial specification
        
        stimuli(:,5) = trials(currentTrial,triallistCols.colorsStart:triallistCols.colorsEnd);                
        
        % NOTE: to change stimulus properties other than color (and the spatial phrase, see
        % below) from trial to trial, the trials matrix needs to be constructed
        % differently. The construciton is currently done elsewhere, and
        % the matrix then supplied to the current script. In addition, any changes
        % to this external matrix need to be realized in additional code in the
        % current script. Corresponding changes to the strings of the spatial phrase
        % may be required as well and can be done at the respective places below
        % and at the start of this file (settings).
        
        
        
        %% convert stimulus sizes/positions to pixel coordinates /mms and rgb values
        
        stimuli_px = [];
        stimuliCenters = [];
        stimuli_rgb = [];
        
        % insert dummy row at top of matrix 'stimuli' (FillOval apparently needs
        % at least two columns as input for rect and color, so the dummy is
        % required to allow for using only one visible stimulus)
        stimuli = [0 0 0 0 1 0; stimuli];
        
        % convert stimuli to absolute positions in pixels (using values in general
        % settings above) --> stimuli_px has two cols, (1) refers to absolute
        % horizontal position, (2) refers to absolute vertical position. rows refer
        % to stimuli. (all in reference to offwinStims, not screen itself)
        % horizontal positions, left border:
        stimuli_px(:,1) = center_offwinStims(1) + stimuli(:,1) * stimdist_horz + ...
            stimuli(:,3) - stimuli(:,6) + array_pos_fixed(1);
        % vertical positions, top border:
        stimuli_px(:,2) = center_offwinStims(2) + stimuli(:,2) * stimdist_vert + ...
            stimuli(:,4) + stimuli(:,6) - array_pos_fixed(2) + (winRect(4) - offwinStimsRect(4))/2;
        % horizontal positions, right border:
        stimuli_px(:,3) = center_offwinStims(1) + stimuli(:,1) * stimdist_horz + ...
            stimuli(:,3) + stimuli(:,6) + array_pos_fixed(1);
        % vertical positions, bottom border:
        stimuli_px(:,4) = center_offwinStims(2) + stimuli(:,2) * stimdist_vert + ...
            stimuli(:,4) - stimuli(:,6) - array_pos_fixed(2) + (winRect(4)-offwinStimsRect(4))/2;
        
        % compute stimulus centers in pixels (cols: x,y; rows: stimuli;
        % based on last block of computations)
        stimuliCenters_px  = [round((stimuli_px(:,1)+stimuli_px(:,3))/2),...
            round((stimuli_px(:,2)+stimuli_px(:,4))/2)];
        
        % calculate center coordinates of each stimulus in the onscreen (!) window
        stimuliCenters = [(stimuli_px(:,1)+(stimuli_px(:,3)-stimuli_px(:,1))/2) - (offwinStimsRect(3)-winRect(3))/2, ...
            stimuli_px(:,2)+(stimuli_px(:,4)-stimuli_px(:,2))/2 ];
        % remove first row (which is the dummy)
        stimuliCenters = stimuliCenters(2:end,:);
        % add radius for each stim as third column
        stimuliCenters(:,3) = (stimuli_px(2:end,3)-stimuli_px(2:end,1))/2;
        
        % convert stimcolors to rgb values
        stimuli_rgb = stimColors(stimuli(:,5),:);
        
        % for trials of type 3 (single item condition), switch color 
        % for all items but the target to background color, to make them invisible.
        if trials(currentTrial,triallistCols.type) == 3                    
            tgtColorTemp = stimuli_rgb(trials(currentTrial,triallistCols.tgt)+1,:);            
            stimuli_rgb = ones(size(stimuli_rgb,1),3) * bgColor;
            stimuli_rgb(trials(currentTrial,triallistCols.tgt)+1,:) = tgtColorTemp;                        
        end
                        
        % convert to millimeters (for use with tracker position)
        stimuliCenters_mm = [stimuliCenters(:,1)./pxPerMm(1), ...
            stimuliCenters(:,2)./pxPerMm(2), stimuliCenters(:,3)./mean(pxPerMm)];
        
        
        %% prepare variables that need to be reset each trial
        
        startMarkerOnset = [];
        tOnStart = [];
        deltatOnStart = 0;
        phraseVisible = 0;
        pointerOnStart = 0;
        abortTrial = 0;
        arrayOnset = 0;
        movementOnset_pc = [];
        movementOffset_pc = [];
        movementOnset_tr = [];
        movementOffset_tr = [];
        noResponse = 1;
        trajectory = zeros(500,5);
        loopsSinceOnset = 0;
        durPhrase = durPhraseBase + durPhraseRand * (rand-0.5);
        currentTgt = [];
        currentRef = [];
        currentSpt = [];
        tgtString = [];
        refString = [];
        sptString = [];
        chosenItem = [];
        switchedResponse = 0;
        tooSlow = 0;
        pointerWithinStim = zeros(size(stimuliCenters,1),1);
        u1 = [0 0 0];  % variables used for computing position of pointer tip
        u2 = [0 0 0];
        u3 = [0 0 0];
        p1 = [0 0 0];
        p2 = [0 0 0];
        p3 = [0 0 0];
        tipPos = [];
        trackerTime = [];
        pcTime = [];
        currentLambdas = [];
        currentMarkerRows = [];
        currentReferenceMarkerDistances = [];
        jumpCounter = 0;
        correctResponse = [];
        
        % Clear windows
        Screen('FillRect', offwinStims, bgColor);
        Screen('FillRect', offwinStart, bgColor);
        Screen('FillRect', offwinStart_on, bgColor);
        
        %% draw and present stimuli
        % (stimuli are first drawn to offscreen window)
        
        % Alternatively to the stimuli below (polygons), draw simple circles 
        % with this line of code (comment stuff below in that case). 
        % Screen('FillOval', offwinStims, stimuli_rgb', stimuli_px'); % use simple circles
                
        % generate and draw random irregular polygon stimuli        
        vertlist = zeros(polysVerts_num,2); 
        vertlist_cue = zeros(polysVerts_num,2);
        
        % cycle through stimuli
        for currentStim = 2:size(stimuliCenters_px,1) % start at 2 to omit dummy stim in stim matrices                    
            
            % randomg value for rotation around polygon center (will be
            % applied to all vertics of current stim)
            randRot = rand*2*pi;
                        
            % for each vertice of current stim generate random distance from 
            % center of stimulus (in pixels), then calculate position of
            % the vertice within the reference frame of offwinStims.
            for currentVert = 1:polysVerts_num
              
                % random distance to center
                currentRadius = polysMin_r + rand * (polysMax_r-polysMin_r);                
                
                % displacement of vertice relative to stimulus center (x,y,)
                dispFromCenter(1) = cos(((currentVert-1)*(2*pi)+randRot)/polysVerts_num)*currentRadius;
                dispFromCenter(2) = sin(((currentVert-1)*(2*pi)+randRot)/polysVerts_num)*currentRadius;                                
                
                % compute the vertice's position in offwinStims coordinates 
                vertlist(currentVert,1) = round(stimuliCenters_px(currentStim,1) + dispFromCenter(1));
                vertlist(currentVert,2) = round(stimuliCenters_px(currentStim,2) + dispFromCenter(2));
                
                % if spatial cue trial (type 4) and currentStim is the target,
                % additionally compute vertices somewhat outside of the actual stimulus.
                % These are used for an outline around the target, which
                % serves as spatial cue.                             
                if trials(currentTrial,triallistCols.type) == 4 && trials(currentTrial,triallistCols.tgt) == currentStim-1
                    dispFromCenter_cue(1) = cos(((currentVert-1)*(2*pi)+randRot)/polysVerts_num)*(currentRadius+(cueLineWidth));
                    dispFromCenter_cue(2) = sin(((currentVert-1)*(2*pi)+randRot)/polysVerts_num)*(currentRadius+(cueLineWidth));
                    vertlist_cue(currentVert,1) = round(stimuliCenters_px(currentStim,1) + dispFromCenter_cue(1));
                    vertlist_cue(currentVert,2) = round(stimuliCenters_px(currentStim,2) + dispFromCenter_cue(2));
                end
                
            end                                   
                      
        
            % if spatial cue trial and currenStim is target, add outline around target stimulus                       
            if trials(currentTrial,triallistCols.type) == 4 && trials(currentTrial,triallistCols.tgt) == currentStim-1
                %Screen('Framepoly',offwinStims,spatialCueColor,vertlist_cue,cueLineWidth);                
                Screen('Fillpoly',offwinStims,spatialCueColor,vertlist_cue);
            end
            
            
            % Draw current stimulus to offwinStims
            Screen('Fillpoly',offwinStims,stimuli_rgb(currentStim,:),vertlist);                        
            
            
        end                                                 

        
        % draw start marker to offscreen window
        start_y = start_pos(2)- offwinStimsRect(4);
        Screen('FillOval', offwinStart, startColor, CenterRectOnPoint([0 0 start_r*2 start_r*2],center_offwinStart(1),start_y));
        Screen('FrameOval', offwinStart_on, startColor, CenterRectOnPoint([0 0 start_r*4 start_r*4],center_offwinStart(1),start_y),start_r/10,start_r/10);
        Screen('FillOval', offwinStart_on, startColor, CenterRectOnPoint([0 0 start_r*2 start_r*2],center_offwinStart(1),start_y));
        
        % draw no-area to offscreen window
        Screen('FillRect', offwinStims, noColor, CenterRectOnPoint([0  0 expScreenSize(3) noArea_height],noArea_pos(1),noArea_pos(2)));
        
        
        % select strings for the spatial phrase according to matrix 'trials'
        currentTgt = trials(currentTrial,triallistCols.tgt); % tgt number
        currentRef = trials(currentTrial,triallistCols.ref); % ref number
        currentSpt = trials(currentTrial,triallistCols.spt); % spatial term
                            
        % check in triallist which strings to use and get these from cell
        tgtString = colStrings{trials(currentTrial,triallistCols.colorsStart-1+currentTgt),1};
        refString = colStrings{trials(currentTrial,triallistCols.colorsStart-1+currentRef),2};
        sptString = sptStrings{trials(currentTrial,triallistCols.spt)};
                      
        % prepare spatial phrase text (later drawn directly to onscreen window)
        
        % Determine word order (ref/tgt) and choose appropriate phrase
        if trials(currentTrial,triallistCols.wordOrder) == 1 % tgt, ref
            phraseString = ['Das ', tgtString, sptString, 'vom ', refString '.'];
        elseif trials(currentTrial,triallistCols.wordOrder) == 2 % ref, tgt
            phraseString = ['Vom ', refString, sptString, 'das ', tgtString '.'];
        end
                
        % set location of phrase: somewhat random around center of the stimulus array
        [phraseBounds, ~] = Screen('TextBounds', win, phraseString);
        phrasePos = [array_pos(1), array_pos(2)] + ...
            (rand(1,2)*2-1) .* stringOffset;
        phraseRect = CenterRectOnPoint(phraseBounds, phrasePos(1), phrasePos(2));        
        
        % set lambdas and markerRows to right or left, depending on which
        % hand is to be used in this trial according to triallist
        if trials(currentTrial,triallistCols.hand) == 1 % right hand
            currentLambdas = lambdas_right;
            currentMarkerRows = markerRows_right;
            currentReferenceMarkerDistances = markerDistances_right;
        elseif trials(currentTrial,triallistCols.hand) == 2 % left hand
            currentLambdas = lambdas_left;
            currentMarkerRows = markerRows_left;
            currentReferenceMarkerDistances = markerDistances_left;
        end
        
        
        % Copy start marker offscreen window to onscreen window
        Screen('CopyWindow', offwinStart, win, [], AlignRect(offwinStartRect,winRect,'center','bottom'));
        % Present start marker
        Screen('Flip', win, []); % flip from backbuffer to onscreen window (backbuffer is cleared)
        
        % prepare backbuffer of onscreen window with pointer-on-start mark
        Screen('CopyWindow', offwinStart_on, win, [], AlignRect(offwinStartRect,winRect,'center','bottom'));
        
        
        % Wait for pointer to be within the start marker (distance of tip from center
        % is checked; i.e., valid for a circular start marker)
        % Once on the marker, continually check that the pointer stays within
        % until the stimuli appear (if not, abort trial and start next one,
        % move aborted trial to end of matrix 'trials').
        % Also abort trial if max time for start marker phase is exceeded
        % (same consequence for trial order).
        startMarkerOnset = GetSecs;
        while deltatOnStart <= durOnStart + durPhrase
            
            % check for empty batteries on glove pointers. Criterion: At
            % least one marker returns zeros for at least 1 second.
            if batteryCheck(currentMarkerRows,0,2)  
                [~,whichMarkersEmpty] = batteryCheck(currentMarkerRows,1,0); %get IDs of empty markers 
                abortTrial = 6;
                break;
            end
                                    
            
            % get position of pointer tip (including checks for erroneous
            % marker data, but excluding check for large marker jumps!)
            %[tipPos, ~, ~] = tipPosition3d(currentMarkerRows,currentLambdas);
            
            
            
            % Get pointer position (includes checks for old buffer values,
            % zero data, and marker jumps; see function help for details; if
            % anything goes wrong, tipPos stays the same as last iteration)
            [tipPos, ~, goodData, bufferUpdated,~,noMarkerJump] = tipPosition3d(currentMarkerRows,currentLambdas, currentReferenceMarkerDistances,markerDistanceThreshold);                       
            
            % Count number of marker jumps (only count "actual" jumps
            % where buffer has been updated in same pass);
            % if criterion of jumpAbortCriterion jumps reached, abort trial.
            if ~noMarkerJump && bufferUpdated
                jumpCounter = jumpCounter + 1;
                if jumpCounter == jumpAbortCriterion;
                    abortTrial = 5;
                    break; % leave loop and abort trial
                end
            end
            
            
            
            
            % check whether pointer is within start marker
            if dist3d(tipPos,[start_pos_mm, 0],[0 0 1]) < start_r_mm
                pointerOnStart = 1;
            else
                pointerOnStart = 0;
            end
                        
            
            % if pointer is on startMarker, start/increase timer
            % if pointer leaves start marker within durOnStart, restart counter
            % if pointer leaves start marker within durPhrase (which follows durOnStart),
            % abort trial
            if pointerOnStart % when pointer is on start marker ...
                
                
                if deltatOnStart == 0 % ...for the first time (or after having left it) -> start timer
                    
                    tOnStart = GetSecs;
                    Screen('Flip', win, [], 2); % show pointer-on-start mark (don't clear backbuffer, normal start marker is moved there)
                    
                end
                
                deltatOnStart = GetSecs - tOnStart; % ...and has been -> increment timer
                
            elseif ~pointerOnStart % when pointer is not on start marker...                               
                                
                if  deltatOnStart ~= 0  &&  deltatOnStart < durOnStart % ... but has been and phrase is not yet visible
                    
                        deltatOnStart = 0; % reset counter to zero
                        Screen('Flip', win, [], 2); % show normal start marker again, i.e., remove pointer-on-start mark (but don't clear backbuffer!)
                                                           
                elseif deltatOnStart > durOnStart % ... but has been and phrase is already visible               

                        abortTrial = 1;
                        break; % leave loop and abort trial
                                                       
                elseif GetSecs - startMarkerOnset > durWaitForReaction % ... and has not been and max time is up.
                    
                    abortTrial = 2;
                    break; % leave loop and abort trial
                    
                end
                                                
            end
            
            % REFRESH DISPLAY & DRAW POINTER: THIS BLOCK IS ONLY NEEDED FOR DEBUGGING
            % Flip line in next block needs to be removed if this block is used)
%                         Screen('CopyWindow', offwinStart, win, [], AlignRect(offwinStartRect,winRect,'center','bottom'));
%                         Screen('DrawDots', win, tipPos(1:2).*pxPerMm, 10, white, [], 1);
%                         Screen('Flip',win,[]);
%             
            % after pointer has been on start marker for durOnStart, show
            % spatial Phrase; due to the while-loop stop condition, this will last
            % durPhrase seconds.
            if deltatOnStart > durOnStart && ~phraseVisible
                DrawFormattedText(win, phraseString, phraseRect(1), phraseRect(2), phraseColor);
                Screen('Flip',win,[]);
                phraseVisible = 1;
            end
            
            
        end
        
        % Show stimuli only if trial not aborted already
        if ~abortTrial
            
            %% Present stimulus array
            
            % Copy stim offscreen window to onscreen window
            Screen( 'CopyWindow', offwinStims, win, [], AlignRect(offwinStimsRect,winRect,'center','top'));
            % Copy start marker offscreen window to onscreen window
            Screen('CopyWindow', offwinStart, win, [], AlignRect(offwinStartRect,winRect,'center','bottom'));
            
            % ---------- time critical code starts here ----------
            
            % present
            [~,arrayOnset,~,~] = Screen('Flip', win, []);
            
            % reset marker jump counter
            jumpCounter = 0;
            
            
            %% movement phase
            
            while isempty(chosenItem)                      
                
                
                % check for empty batteries on glove pointers. Criterion: At
                % least one marker returns zeros for at least 1 second.
                if batteryCheck(currentMarkerRows,0,2)
                    [~,whichMarkersEmpty] = batteryCheck(currentMarkerRows,1,0);
                    abortTrial = 6;
                    break;
                end                                               
                
                
                % Get pointer position & timestamp (the latter is for the
                % marker in row max(currentMarkerRows))
                % (includes checks for old buffer values, zero data, and
                % marker jumps; see function help for details; if anything
                % goes wrong, tipPos stays the same as last iteration)
                [tipPos, trackerTime, goodData, bufferUpdated,~,noMarkerJump] = tipPosition3d(currentMarkerRows,currentLambdas, currentReferenceMarkerDistances,markerDistanceThreshold);
                pcTime = GetSecs;
                   
                
                % Count number of marker jumps (only count "actual" jumps
                % where buffer has been updated in same pass);
                % if criterion of jumpAbortCriterion jumps reached, abort trial.
                if ~noMarkerJump && bufferUpdated                                  
                    jumpCounter = jumpCounter + 1;                    
                    if jumpCounter == jumpAbortCriterion;                                               
                        abortTrial = 5;
                        break; % leave loop and abort trial                    
                    end                    
                end
                
                
                % do remaining steps only if a new, "good" tipPos could be
                % computed based on the VzGetDat data
                if goodData
                
                    
                    % check whether pointer distance to screen surface is higher than
                    % allowed (i.e. allowedPointerZ), if so, abort trial
                    if abs(tipPos(3)) > allowedPointerZ
                        abortTrial = 4;
                        break; % leave loop and abort trial
                    end
                    
                    
                    % when pointer leaves vicinity of start marker, get movement onset time
                    if isempty(movementOnset_pc) && dist3d(tipPos,[start_pos_mm,0],[0 0 1]) > movementOnsetDist_mm
                        movementOnset_pc = pcTime;
                        movementOnset_tr = trackerTime;
                    end
                    
                    
                    % record pointer position each iteration --> trajectory
                    if ~isempty(movementOnset_pc)
                        loopsSinceOnset = loopsSinceOnset + 1;
                        trajectory(loopsSinceOnset,:) = [tipPos, pcTime, trackerTime];
                    end
                    
                    
                    % get distance of pointer from each stimulus and check whether
                    % inside any stimulus borders
                    pointerWithinStim = dist3d(tipPos,[stimuliCenters_mm(:,1:2), ...
                        zeros(size(stimuliCenters_mm,1),1)],[0 0 1]) < stimuliCenters_mm(:,3);
                    
                    % also check whether pointer is inside the "no-area" and
                    % append result to that from the above check  (i.e., treat
                    % the area as an additional item)
                    pointerWithinStim(end+1) = dist3d(tipPos,[noArea_pos_mm 0],[1 0 1]) < noArea_height_mm/2;
                    
                    % check whether pointer is within any of the stimuli
                    if isempty(movementOffset_pc) && any(pointerWithinStim) % pointer is on an item (or no-area) and hasn't been on one before
                        
                        movementOffset_pc = pcTime; % record movement offset time
                        movementOffset_tr = trackerTime; % both as computer- and tracker-based time
                        
                    elseif ~isempty(movementOffset_pc) && ~any(pointerWithinStim) % not on stimulus (or no-area) but has been last iteration 
                        
                        movementOffset_pc = []; % reset movement offset time
                        movementOffset_tr = [];
                        switchedResponse = 1;
                        
                    elseif pcTime - arrayOnset > durWaitForReaction % ... max time is up.
                        
                        abortTrial = 3;
                        break; % leave loop and abort trial
                        
                    end
                    
                    
                    % when pointer has dwelled some time (durPointerDwell), store
                    % on which item (if this variable ~isempty, while-loop ends)
                    if ~isempty(movementOffset_pc) && pcTime-movementOffset_pc >= durPointerDwell
                        
                        chosenItem = find(pointerWithinStim); % store number of chosen item
                        
                        if chosenItem == numel(pointerWithinStim) % in case the no-area was chosen reset the switchedResponse flag
                            switchedResponse = 0;
                        end
                        
                    end
                    
                    
                    %                 % REFRESH DISPLAY & DRAW POINTER: THIS BLOCK IS ONLY NEEDED FOR DEBUGGING
                    %                 % Copy stim offscreen window to onscreen window
                    %                 Screen('CopyWindow', offwinStims, win, [], AlignRect(offwinStimsRect,winRect,'center','top'));
                    %                 % Copy start marker offscreen window to onscreen window
                    %                 Screen('CopyWindow', offwinStart, win, [], AlignRect(offwinStartRect,winRect,'center','bottom'));
                    %                 % draw mouse position
                    %                 Screen('DrawDots', win, tipPos(1:2).*pxPerMm, 10, white, [], 1);
                    %                 % present
                    %                 Screen('Flip',win,[]);                    
                    
                    
                end                
                
                
            end
            
            % ---------- time critical code ends here ----------
            
            
            % retest for trial abortion, since it may have happened during
            % stimulus display (through exceeding max display time)
            if ~abortTrial
                
                % Check whether final movementOffset_pc-arrayOnset (timespan from
                % array presentation to crossing border of actually chosen item)is
                % shorter than maxRT. (otherwise response is marked as too slow and
                % appropriate feedback is presented later)
                if movementOffset_pc - arrayOnset > maxRT
                    tooSlow = 1;
                end
                
                
                Screen('Flip', win, []); % flip from backbuffer to onscreen window (backbuffer is cleared)
                
                                
                %% Determine correctness of response
                
                if (~isempty(chosenItem) && chosenItem == trials(currentTrial,triallistCols.tgt) && any(trials(currentTrial,triallistCols.type) == [1 3 4])) || ... % trialtypes 1 (standard relational), 3 (single-item), 4 (spatial cue)
                   (~isempty(chosenItem) && chosenItem == numel(pointerWithinStim) && trials(currentTrial,triallistCols.type) == 2)                                 % trialtype 2 (spatial catch-trial, phrase and display incongruent)                                                                                 
                    
                    correctResponse = 1;
                    
                elseif ~isempty(chosenItem) % incorrect response
                    
                    correctResponse = 0;
                    
                end
                
                
                %% provide user feedback
                
                if tooSlow % maxRT exceeded (overrides other feedback)
                    
                    DrawFormattedText(win, 'Zu langsam!', 'center', feedb_pos(2), phraseColor);
                                                                                                                                                                        
                elseif correctResponse
                    
                    DrawFormattedText(win, 'Richtig! Sehr gut!', 'center', feedb_pos(2), phraseColor);
                    
                elseif ~correctResponse
                    
                    DrawFormattedText(win, 'Falsch!', 'center', feedb_pos(2), phraseColor);
                    
                end
                
                Screen('Flip', win, []); % flip from backbuffer to onscreen window (backbuffer is cleared)
                WaitSecs(durFeedback);
                
                
                %% store stuff in results matrix and file
                % (but not if trial was aborted silently, also do not adjust 
                % RT if trial was aborted silently)
                
              
                    
                    % store response and trial parameters
                    % (if anything is changed here, make sure that it still works
                    % scripts for analysis and with the triallists; should be no
                    % problem, as long as the structs holding the colum numbers
                    % are correct)
                    results(currentTrial,resCols.slow) = tooSlow; % 1 if response was "too slow"
                    results(currentTrial,resCols.chosen) = chosenItem; % item chosen by participant (meaning of this number depends on arrangement in stimuli matrix!)
                    results(currentTrial,resCols.type) = trials(currentTrial,triallistCols.type); % blockType (1 = spatial phrase, 1 correct item; 2 = color-only, two correct items)
                    results(currentTrial,resCols.stimOnset_pc) = arrayOnset; % onset of stimulus display, pc time (seconds since system startup)
                    results(currentTrial,resCols.moveOnset_pc) = movementOnset_pc; % start time of movement, pc time (seconds since system startup)
                    results(currentTrial,resCols.moveOffset_pc) = movementOffset_pc; % end time of movement, pc time (seconds since system startup)
                    results(currentTrial,resCols.moveOnset_tr) = movementOnset_tr; % start time of movement, tracker time
                    results(currentTrial,resCols.moveOffset_tr) = movementOffset_tr; % end time of movement, tracker time
                    results(currentTrial,resCols.passed) = switchedResponse; % if 1, pts. passed over a stimulus but did not stay on this item
                    results(currentTrial,resCols.maxRT) = maxRT; % maxRT in seconds for this trial (constant for main trials)
                    results(currentTrial,resCols.correct) = correctResponse; % if response correct 1, else 0
                    % also copy parameters of current trial to results matrix:
                    results(currentTrial,resCols.trialID)  = trials(currentTrial,triallistCols.trialID);
                    results(currentTrial,resCols.typeFromTriallist) = trials(currentTrial,triallistCols.type);
                    results(currentTrial,resCols.tgt) = trials(currentTrial,triallistCols.tgt);
                    results(currentTrial,resCols.ref) = trials(currentTrial,triallistCols.ref);
                    results(currentTrial,resCols.spt) = trials(currentTrial,triallistCols.spt);
                    results(currentTrial,resCols.hand) = trials(currentTrial,triallistCols.hand);
                    results(currentTrial,resCols.colorsStart:resCols.colorsEnd) = trials(currentTrial,triallistCols.colorsStart:triallistCols.colorsEnd);
                    
                    % store trajectory
                    
                    % trim rows in trajectory vector (remove zero rows)
                    trajectory = trajectory(trajectory(:,3) ~= 0,:);
                    % convert timestamps to deltat relative to movement onset
                    trajectory(:,3) = trajectory(:,3) - movementOnset_pc;
                    % store in cell
                    trajectories{currentTrial} = trajectory;
                    
                    % store stimulus positions in cell array
                    stimCenters_mm{currentTrial} = stimuliCenters_mm;
                    
                    % save everything to file (append)
                    save(saveToFile, 'results','trajectories','stimCenters_mm','-append');
                    
                    
                    %% adjust presentation time
                    
                    % each adjustmentEachNTrials trials (where color-only trials are not
                    % considered in the count), adjust display duration of array,
                    % if proportion of trials that has been responded to regularly
                    % is not as desired.
                    if adjustMaxRT && ... % adjust max RT at all?
                            blockType == 1 && ... % is adjustment trial?
                            any(trials(currentTrial,triallistCols.type) == [1 2]) && ... % is spatial trial?
                            mod(sum(trials(1:currentTrial,triallistCols.type) == 1),adjustmentEachNTrials) == 0 && ... % is step size reached?
                            sum(trials(1:currentTrial,triallistCols.type) == 1) > 0
                        
                        propFast = 1-(sum(results(currentTrial-adjustmentEachNTrials+1:currentTrial,1))/adjustmentEachNTrials);
                        maxRT = maxRT + ((adjustmentTarget-propFast)*adjustmentStep);
                        
                    end                      
                    
 
                
            end % belongs to second (inner) if, checking for trial abortion
            
        end % belongs to first (outer) if, checking for trial abortion
        
        
        % if the current trial was aborted, due to leaving start marker early
        % or not reacting during start marker Or stimulus phase Or marker jump
        % during phrase, show appropriate feedback and shift trial to the end to be redone
        if abortTrial
            
            if  abortTrial == 1 % left start marker early                
                abortString = earlyString;                
            elseif abortTrial == 2 % did not move pointer onto start marker                
                abortString = noResponseString;                
            elseif abortTrial == 3 % did not respond to stimuli                
                abortString = noResponseString;                
            elseif abortTrial == 4 % lifted pointer from screen during trial                
                abortString = liftedPointerString;                
            elseif abortTrial == 5 % marker jump detected
                abortString = markerJumpString; 
            elseif abortTrial == 6 % empty battery
                abortString = sprintf([batteryString '\n\n(IDs: ' num2str(whichMarkersEmpty(:,2)') ').']);                                                    
            end
            
            % show feedback
            Screen('Flip',win,[]);
            [abortString_x, abortString_y] = ...
                centerTextOnPoint(abortString, win, array_pos(1), array_pos(2));
            DrawFormattedText(win, abortString, 'center', abortString_y, textColor, [], [], [], 2);
            Screen('Flip',win,[]);
            
            % in case of battery empty...
            if abortTrial == 6                
                
                % wait till batteries replaced (only checks current hand)
                batteryFullStart = [];
                while isempty(batteryFullStart) || (GetSecs-batteryFullStart) < 0.25
                    
                    if ~batteryCheck(currentMarkerRows,0,0) 
                        
                        if isempty(batteryFullStart)
                        
                            batteryFullStart = GetSecs;
                        
                        end
                        
                    elseif ~isempty(batteryFullStart)
                        
                        batteryFullStart = []; % reset timer
                        
                    end
                    
                end
                
                KbWait;
                
                Screen('Flip',win,[]);
                tempString = 'Ok. Starte neuen Durchgang...';
                [tempString_x, tempString_y] = ...
                    centerTextOnPoint(tempString, win, array_pos(1), array_pos(2));
                DrawFormattedText(win, tempString, 'center', tempString_y, textColor, [], [], [], 2);
                Screen('Flip',win,[]);                
            end
            
            
            WaitSecs(2.5)
            
            
        end
        
        if abortTrial                                   
             
            % do shifting around of trials (see below) only if it's not the
            % last trial anyway 
            if currentTrial ~= size(trials,1)
                
                % Move aborted trial plus the following trial to the end of the
                % list, so they're done later.
                % In the case of an "overtly aborted trial" (communicated
                % to the participant) this is done instead of moving only
                % the single aborted trial, in order to ensure that trials
                % keep alternating between left and right hand. Before
                % moving the two trials, it is checked whether the
                % aborted trial uses the same hand as the last one in the list.
                % If so, the two rows are swapped before being moved. If not,
                % their order is retained.

                
                % if hands in current & very last trial are the same,
                % swap row of current trial with the next one.
                if trials(currentTrial,triallistCols.hand) == trials(end,triallistCols.hand)
                                        
                    trials(currentTrial:currentTrial+1,:) = flipud(trials(currentTrial:currentTrial+1,:));
                    
                end
                
                % Append current row and next one to end of matrix
                trials(end+1:end+2,:) = trials(currentTrial:currentTrial+1,:);
                % Delete the original rows.
                trials(currentTrial:currentTrial+1,:) = [];
                
            end
            
            % Set back currentTrial by 1 (so that the trial that is now in
            % the same row as the deleted one will be done next (since the
            % following line increments the counter as usual).
            currentTrial = currentTrial - 1;                        
            
        end
        
        % increment trial counter
        currentTrial = currentTrial + 1;
        
        
    end
    
    
end % end for blockType for-loop (before currentTrial for-loop)



Screen('closeall')
sca
ShowCursor




