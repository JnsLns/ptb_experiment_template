%%%% Open PTB offscreen windows 

% Add any offscreen windows you may need to this file.

% Use these to draw things like stimuli or fixation crosses to them before
% the actual presentation phase of a trial. During the trial these
% ready-made images then only need to be copied to the onscreen window
% shortly before presentation, saving some time and thus improving timing.
%
% There are two things you may use an offscreen window for:
% 
% (1) Drawing something to it once before any trials and then reusing it
%     each trial (by copying it to the onscreen window when needed). Define
%     such an offscreen window for each static image, e.g., one for the
%     fixation cross, one for a response prompt etc.. Draw to these windows
%     in 'drawStaticGraphics.m' based on parameters from the experiment
%     settings ('e.s'; e.g., size of fixation cross). Set clearEachTrial to
%     'false' for these windows (see below).
%
% (2) Drawing different stimuli to it each trial. Draw to such windows
%     in 'drawChangingGraphics.m' based on parameters from the trial list
%     ('trials'). Set clearEachTrial to 'true' for such windows (see
%     below).
%
% All offscreen windows must be stored in a struct 'winsOff', which has one
% field for each offscreen window, e.g., 'winsOff.window1name'. The field
% for each window must in turn have the following sub-fields:
%
% rect           position, size (left, top, right, bottom), PTB-frame (px)
% screen         screen where this window is created, usually expScreen
% bgColor        window background color, RGB-vector (0-1).
% clearEachTrial boolean. if 'true', window contents are reset to bgColor
%                after each trial (use this for windows to which you will
%                draw trial-specific graphics).
% h              window pointer returned by Screen('OpenOffScreenWindow',...)
%                
% Note that the loop at the bottom of this file will go through struct
% 'winsOff' and open windows and create field 'h' automatically, based on
% the struct's fields. If you use this code you can define windows by
% simply adding a new field to 'winsOff' for each of them and define their
% properties by by creating the first four sub-fields from the above list.


% offscreen window to draw stimuli to
winsOff.stims.bgColor = e.s.bgColor;  
winsOff.stims.screen = expScreen;     
winsOff.stims.rect = winOn.rect;      
winsOff.stims.clearEachTrial = true;  
                                      
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

% offscreen window for post stimulus mask
winsOff.postStimMask.bgColor = e.s.bgColor;
winsOff.postStimMask.screen = expScreen;
winsOff.postStimMask.rect = winOn.rect;
winsOff.postStimMask.clearEachTrial = false;

% Open the windows by iterating over struct 'winsOff' (leave this as is
% unless you want to open windows in a different manner)
for winName = fieldnames(winsOff)'
    winName = winName{1};
    [winsOff.(winName).center(1), winsOff.(winName).center(2)] = ...
        RectCenter(winsOff.(winName).rect);
    [winsOff.(winName).h, winsOff.(winName).rect] = ...
        Screen('OpenOffScreenWindow', winsOff.(winName).screen, ...
        winsOff.(winName).bgColor, winsOff.(winName).rect, ...
        [], [], e.s.multisampling);
end

