%%%%%%%%%%%%%%%%%%%%%%%%% Open PTB offscreen windows %%%%%%%%%%%%%%%%%%%%%%
%
% Specify any off-screen windows that you will need. In short:
%
% winsOff.myWindow = [];    % this defines a window
% winsOff.myWindow.h        % this is the window pointer available in other
%                           % script files
%
%
%                __What offscreen windows are needed for__
%
% There are two ways offscreen windows are used:
% 
% (1) Drawing new stimuli to it *each trial*. Draw to such windows
%     in 'drawChangingGraphics.m', which is executed once at the outset of
%     every trial. Set 'clearEachTrial' to 'true' for these windows (see
%     below).
%
% (2) Drawing something to it only once at the outset of the experiment, in 
%     'drawStaticGraphics.m' and reuse the same image multiple times. Good
%     for things that do not need to change over trials, such as a fixation
%     cross. Define one offscreen window for each image needed in the
%     course of the experiment. Set 'clearEachTrial' to 'false' (see below).
%
%
%                 __How to specify offscreen windows__
%
% Create a struct 'winsOff' and add one field for each offscreen window you
% would like opened. The fields should be empty. For instance:
%
% winsOff.myFirstWindow = [];
% winsOff.mySecondWindow = [];
%
% That's it. The above will open two offscreen windows with default settings.
% To change the default settings, add any of the following sub-fields to
% the respective window's field, like this:
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
%       __How to access the offscreen windows in other scripts__
%
% The struct 'winsOff' will persist and be accessible in the other
% script files. Pass the offscreen windows to Psychtoolbox functions
% using the window pointer 'winsOff.myFirstWindow.h' (the field 'h' will be
% automatically generated).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

winsOff.stims.clearEachTrial = true; % to draw stimuli to                                     
winsOff.empty = [];                  % empty screen
winsOff.startMarker = [];            % for mouse cursor start marker



