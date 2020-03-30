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
%               __How to specify offscreen windows__
%
% Create a struct 'winsOff' with one field for each offscreen window, e.g.,
% 'winsOff.myFirstWindow'. In turn, add the following sub-fields to the
% field for each window (such as 'winsOff.myFirstWindow.rect'):
%
% rect           position, size (left, top, right, bottom), PTB-frame (px)
% bgColor        window background color, RGB-vector (0-1).
% clearEachTrial boolean. if 'true', window contents are reset to the value
%                stored in bgColor after each trial (use this for windows
%                to which you will draw trial-specific graphics; set to 
%                'false' for windows to which you draw only once).
%
%       __How to access the offscreen windows in other files__
%
% The struct 'winsOff' will persist and be accessible in the other
% modifieable experiment script files. A field 'h' will be added auto-
% matically. This field will hold the window pointer returned by
% the Psychtoolbox command Screen('OpenOffScreenWindow',...). Use this
% pointer when when drawing to or copying the respective window later.
              

% offscreen window to draw stimuli to
winsOff.stims.bgColor = e.s.bgColor;    
winsOff.stims.rect = winOn.rect;      
winsOff.stims.clearEachTrial = true;  
                                      
% empty offscreen window
winsOff.empty.bgColor = e.s.bgColor;
winsOff.empty.rect = winOn.rect;
winsOff.empty.clearEachTrial = false;

% offscreen window for start marker
winsOff.startMarker.bgColor = e.s.bgColor;
winsOff.startMarker.rect = winOn.rect;
winsOff.startMarker.clearEachTrial = false;

% offscreen window for fixation cross
winsOff.fix.bgColor = e.s.bgColor;
winsOff.fix.rect = winOn.rect;
winsOff.fix.clearEachTrial = false;

% offscreen window for target presence response
winsOff.targetResponse.bgColor = e.s.bgColor;
winsOff.targetResponse.rect = winOn.rect;
winsOff.targetResponse.clearEachTrial = false;

% offscreen window for post stimulus mask
winsOff.postStimMask.bgColor = e.s.bgColor;
winsOff.postStimMask.rect = winOn.rect;
winsOff.postStimMask.clearEachTrial = false;




