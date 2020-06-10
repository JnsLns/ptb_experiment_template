%%%%%%% Prepare graphics that stay the same over the experiment %%%%%%%%%%%
%
% Draw graphics that remain unchanged over trials to the prepared offscreen
% windows, such as a fixation cross. Use the window pointers stored in
% struct 'winsOff.myWindow.h'.
% The coordinate frame for drawing is the Psychtoolbox frame, units are
% pixels. Use functions 'vaToPx' and 'paVaToPtbPx' to convert from visual
% angle to that frame. See folder 'helperFuntions/unitConversion' for these
% functions' documentations and other conversion functions you may use.
%
%
%        ___Useful variables that exist at the outset of this file___
%
% e.s        struct. Experiment settings
% winsOff    struct. offscreen windows (pointers: 'winsOff.myWindow.h')
% winOn      struct. onscreen window (pointer: 'winOn.h')
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%% Draw start marker to offscreen window winsOff.startMarker.h

% To draw the start marker using a Psychtoolbox function, we need
% Psychtoolbox coordinates and pixel units. But we have defined the
% position in the presentation-area-frame and in degrees of visual angle
% during trial generation. So we first need to convert them:

% Convert positions
x = e.s.startMarkerPos(1);
y = e.s.startMarkerPos(2);
[x_ptb, y_ptb] = paVaToPtbPx(x, y, e.s.spatialConfig);

% Convert size
r = e.s.startMarkerRadius;
r_px = vaToPx(r, e.s.spatialConfig);

% Finally, use Psychtoolbox function to plot the start marker:

Screen('DrawDots', ...
    winsOff.startMarker.h, ...
    [x_ptb, y_ptb], ...
    r_px * 2, ...
    e.s.startMarkerColor, ...
    [], 1);


    


