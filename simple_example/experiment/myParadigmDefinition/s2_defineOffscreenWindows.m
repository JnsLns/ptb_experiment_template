%%%% Open PTB offscreen windows 
%
% Specify off-screen windows to be opened.
%
%
%                __What offscreen windows are needed for__
%
% There are two ways an offscreen windows can be used:
% 
% (1) Drawing different stimuli to it *each trial*. Draw to such windows
%     in 'drawChangingGraphics.m', which is executed once at the outset of
%     every trial. You probably want to draw things depending on some
%     trial-specific parameters stored in the trial list ('trials').
%     Set 'clearEachTrial' to 'true' for these windows (see below), so that
%     remaining images are deleted from them after each trial.
%
% (2) Drawing something to it *once* at the outset of the experiment (in 
%     drawStaticGraphics.m). The image can then be reused any time, by
%     copying the respective offscreen window to the onscreen window. Good
%     for things that do not need to change over trials, such as a
%     fixation cross.
%     For this use case, define one offscreen window for each static image 
%     needed in the course of the experiment. Set 'clearEachTrial' to
%     'false' for these windows (see below), to prevent the image from
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
% That's it. The above will open two offscreen windows with default settings.
% To change the default settings, add any of the following sub-fields to
% the respective window's field. For instance:
%
% winsOff.myFirstWindow.bgColor = [0 0 0];
%
% This will change the background color of myFirstWindow. The other possible
% field names / properties are:
%
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
% matically to each sub-field of winsOff. It will hold the window pointer
% to the window, which can be passed to Psychtoolbox functions that need a
% window pointer as input. For instance, use this pointer when when drawing
% to a window later or when copying it to the onscreen window for display.
              

winsOff.stims.clearEachTrial = true; % to draw stimuli to                                     
winsOff.empty = [];                  % empty screen
winsOff.startMarker = [];            % for mouse cursor start marker



