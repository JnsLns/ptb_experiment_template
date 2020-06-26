%%%%%%% Prepare graphics that stay the same over the experiment %%%%%%%%%%%
%
% Draw graphics that are reused across trials (such as a fixation cross)
% to the prepared offscreen windows.
%
% Window pointers are stored in struct 'winsOff.myWindow.h'.
%
% Psychtoolbox drawing functions expect the Psychtoolbox coordinate frame
% and pixels as units. Use methods of the CoordinateConverter object that
% is accessible as the variable 'convert' here to convert between reference
% frames and units. Examples:
%
% x = convert.va2Px(x)             % convert x from visual angle to pixels
% xy = convert.vaPa2PtbPx(x,y)     % convert x and y from presentation area
%                                  % frame and degrees of visual angle to 
%                                  % Psychtoolbox frame and pixels.
%
%
%      ___Useful variables that exist at the outset of this file___
%
% convert    object of CoordinateConverter class. Use to convert between 
%            units and reference frames. (see Readme.md)   
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


    


