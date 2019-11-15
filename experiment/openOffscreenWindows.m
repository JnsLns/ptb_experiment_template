%%%% Open PTB offscreen windows 

% Add any offscreen windows you may need to this file.

% Use these to draw things like stimuli or fixation crosses to them before
% the actual presentation phase of a trial. During the trial these
% ready-made images then only need to be copied to the onscreen window
% shortly before presentation, saving some time and thus improving timing.

% There are two things you may use an offscreen window for:
% 
% (1) Drawing different stimuli to it each trial. Draw to such windows
%     in 'drawChangingGraphics.m' based on parameters from the trial list.
%     Set clearEachTrial to 'true' for such windows (see code below), to
%     have them cleared at the outset of each trial.
%
% (2) Drawing something to it once before any trials and then reusing it
%     each trial (by copying it to the onscreen window when needed). You
%     should probably make such an offscreen window for each image of this
%     type, for instance, one for a fixation cross, one for a start
%     position marker, and for other things of similar nature. Draw to
%     these windows in 'drawStaticGraphics.m' based on parameters from the
%     experiment settings ('e.s'). Set clearEachTrial to 'false' for these
%     windows to leave them unchanged over trials.
%
% Offscreen window handles are stored as winsOff.windowname.h, and window
% properties in other fields, such as winsOff.windowname.rect.
%
% Note that some functionality requires the window handles and properties
% to be stored the way it is done here (in a struct), such as closing and
% reopening all windows when the experiment is paused/resumed. You may
% define windows in other ways if you require the flexibility, but their
% properties must be stored in this manner.


% Define window properties (add another block for additional window or
% remove blocks as you see fit):

% offscreen window to draw stimuli to
winsOff.stims.bgColor = e.s.bgColor;  % background color (RGB vector 0-1)
winsOff.stims.screen = expScreen;     % screen number (usually expScreen)
winsOff.stims.rect = winOn.rect;      % position & size (left, top, right, bottom), ptb frame (px)
winsOff.stims.clearEachTrial = true;  % whether to reset entire window to
                                      % background color after each trial
% empty offscreen window
winsOff.empty.bgColor = e.s.bgColor;
winsOff.empty.screen = expScreen;
winsOff.empty.rect = winOn.rect;
winsOff.empty.clearEachTrial = false;

% offscreen window for start marker
winsOff.startMarker.bgColor = e.s.bgColor;
winsOff.startMarker.screen = expScreen;
winsOff.startMarker.rect = winOn.rect;
winsOff.startMarker.clearEachTrial = false;

% offscreen window for fixation cross
winsOff.fix.bgColor = e.s.bgColor;
winsOff.fix.screen = expScreen;
winsOff.fix.rect = winOn.rect;
winsOff.fix.clearEachTrial = false;

% offscreen window for target presence response
winsOff.targetResponse.bgColor = e.s.bgColor;
winsOff.targetResponse.screen = expScreen;
winsOff.targetResponse.rect = winOn.rect;
winsOff.targetResponse.clearEachTrial = false;


% Open the windows by iterating over struct 'winsOff' (leave this as is
% unless you want to define windows in a different manner)
for winName = fieldnames(winsOff)'
    winName = winName{1};
    [winsOff.(winName).center(1), winsOff.(winName).center(2)] = ...
        RectCenter(winsOff.(winName).rect);
    [winsOff.(winName).h, winsOff.(winName).rect] = ...
        Screen('OpenOffScreenWindow', winsOff.(winName).screen, ...
        winsOff.(winName).bgColor, winsOff.(winName).rect, ...
        [], [], e.s.multisampling);
end

