%%%%%%% Prepare graphics that stay the same over the experiment %%%%%%%%%%%
%
% Draw graphics that are reused across trials, such as a fixation cross,
% to the prepared offscreen windows.
% Window pointers are stored in struct 'winsOff.myWindow.h'.
% The coordinate frame for drawing is the Psychtoolbox frame, units are
% pixels. Use methods of the CoordinateConverter object that is available
% here in the the variable 'convert' to convert between reference frames
% and units: For instance
%
%   convert.va2Px(x) % convert x from visual angle to pixels
%object
% to convert BETWEEN 

%from the presentation area frame to that frame and from visual angle to pixels.
%See folder 'helperFuntions/unitConversion' for these
% functions' documentations and other conversion functions you may use.
%
%
%      ___Useful variables that exist at the outset of this file___
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

% Convert start marker positions to Psychtoolbox 
xy_ptb = convert.paVa2ptbPx(e.s.startMarkerPos(1), e.s.startMarkerPos(2));

% Convert size to pixels (diameter)
d_px = convert.va2px(e.s.startMarkerRadius * 2);

% Finally, use Psychtoolbox function to plot the start marker:
Screen('DrawDots', ...
    winsOff.startMarker.h, ...
    xy_ptb, ...
    d_px, ...
    e.s.startMarkerColor, ...
    [], 3);


    


