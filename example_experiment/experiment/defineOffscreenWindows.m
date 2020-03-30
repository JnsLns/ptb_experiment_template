%%%% Open PTB offscreen windows 
%
% Specify off-screen windows to be opened.
%
%
%                __What offscreen windows are needed for__
%
% There are two ways an offscreen window can be used:
% 
% (1) Drawing different stimuli to it *each* trial. Draw to such windows
%     in 'drawChangingGraphics.m', possibly according to trial-specific 
%     parameters from the trial list ('trials'). Set 'clearEachTrial' to
%     'true' for those windows (see below), so that remaining images are
%     deleted from them after each trial.
%
% (2) Drawing something to it *once* at the outset of the experiment (in 
%     (drawStaticGraphics.m). The image can then be reused any time by
%     copying the respective offscreen window to the onscreen window. Good
%     for things that do not need to change over trials, such as a
%     fixation cross.
%     For this use case, define one offscreen window for each static image 
%     needed in the course of the experiment. Set 'clearEachTrial' to
%     'false' (see below) for these windows, to prevent the image from
%     being deleted between trials.
%
%
%                 __How to specify offscreen windows__
%
% Create a struct 'winsOff' and add one field for each offscreen window you
% would like opened; the fields should be empty. For instance:
%
% winsOff.myFirstWindow = [];
% winsOff.mySecondWindow = [];
%
% This will open two offscreen windows with default settings. To change the
% default settings, add any of the following sub-fields to the respective
% window's field (e.g., winsOff.myFirstWindow.bgColor = [0 0 0]):
%
% Sub-field name              Type/effect                       Default 
% --------------  ---------------------------------------  ----------------
%
% clearEachTrial  boolean. if 'true', window contents are  false
%                 reset to the value stored in bgColor
%                 after each trial.
%
% rect            4-element row vector, specifying window  winOn.rect
%                 position and size (left, top, right,     (same as on-
%                 bottom) in PTB coordinate frame [px].    screen window)
%
% bgColor         3-element row vector holding RGB-values  e.s.bgColor
%                 between 0 and 1. Window background       (same as on-
%                 color, RGB-vector (0-1).                 screen window)
%
%
%       __How to access the offscreen windows in other files__
%
% The struct 'winsOff' will persist and be accessible in the other
% modifieable experiment script files. A field 'h' will be added auto-
% matically. This field will hold the window pointer returned by
% the Psychtoolbox command Screen('OpenOffScreenWindow',...). Use this
% pointer when when drawing to or copying the respective window later.
              

winsOff.stims.clearEachTrial = true; % to draw stimuli to                                     
winsOff.empty = [];                  % empty screen
winsOff.startMarker = [];            % for start marker
winsOff.fix = [];                    % for fixation cross
winsOff.targetResponse = [];         % for target presence response
winsOff.postStimMask = [];           % for post stimulus mask




