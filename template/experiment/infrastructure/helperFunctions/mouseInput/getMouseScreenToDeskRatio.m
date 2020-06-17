function screenToDesk = getMouseScreenToDeskRatio(screenSizeXY_mm, screenResXY_px, distWorld_mm)
% function screenToDesk = getMouseScreenToDeskRatio(screenSizeXY_mm, screenResXY_px, distWorld_mm)
%
% This function helps measuring the ratio of cursor movement distance on
% the screen and mouse movement distance on the desk (screen / desk). For
% this the function requests a straight, vertical mouse movement over a
% predefined length as a movement sample. The user is notified of the
% required steps via message boxes. 
%
% %%%%%%%%%%%%%%%%%%%%%%% IMPORTANT NOTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The ratio is highly dependent on the system setting of mouse speed,
% physical screen size, and screen resolution. Whenever any of these
% changes, the ratio has to be determined afresh! Mouse acceleration must
% be disabled both while running this function and during any experiments
% based on the obtained measurement.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The obtained ratio ('screenToDesk') can then be supplied to function
% getMouseRemapped, together with a *desired* ratio, in order to convert
% streaming mouse movements to the desired mapping.
% For instance, you may wish the cursor to move 20 millimeters
% across the screen for every 10 millimeters the mouse moves on the desk
% (2:1 mapping); for this, obtain the raw ratio using the current function
% and then, during the experiment use getMouseRemapped(screenToDesk, 2, ...)
% (or simply getMouseRM(), see Readme.md) and plot a mouse cursor at the
% position returned by that function
%
% Note that this function works properly only if the raw mouse-pointer
% mapping is the same in horizontal and vertical direction, which is
% however usually the case.
%
%                            ___Input___
%
% screenSizeXY_mm   2-element row vector giving the horizontal and vertical
%                   extent of the visible area of the screen. 
%
% screenResXY_px    (optional, default is resolution of screen 0):
%                   Resolution in pixels of the screen used. Can be either
%                   a 2-element row vector holding the horizontal and
%                   vertical number of pixels for the screen used, or the
%                   screen number of a connected screen from which these
%                   values should be acquired. 
%
% distWorld_mm      Optional, default 500 mm. Scalar giving the distance
%                   that the mouse will be moved across the desk as a
%                   sample movement, in millimeters. Larger distances will
%                   result in better estimates of the ratio.
%
% 
%                           ___Output___
%
% screenToDesk     Scalar, ratio of cursor movement distance on the screen
%                  and mouse movement distance on the desk (screen divided
%                  by desk).


% Default args

if nargin < 3
    distWorld_mm = 500;
end

whichScreen = [];
if nargin < 2
    whichScreen = 0;
elseif numel(screenResXY_px) == 1
    whichScreen = screenResXY_px;
end
if ~isempty(whichScreen)
    ss = get(whichScreen,'ScreenSize');
    screenResXY_px = ss(3:4);
else 
    ss = [1, 1, screenResXY_px];
end

% Compute ratio of pixels to physical size
pxPerMm = mean(screenResXY_px./screenSizeXY_mm);

% Preparation
pause(0.2);
waitfor(msgbox(['Reminder: Disable mouse acceleration before calibration ', ...
                'and during experiments that use the determined value. If ', ...
                'mouse speed is later changed in system/mouse driver ', ...
                'settings calibration has to be renewed.']));
pause(0.5);

% Instruction
msgbox(['When instructed to, move the mouse forward along a straight line ', ...
       'of ', num2str(distWorld_mm), ' millimeters. The straighter the line, ', ...
       'and the more precise the distance moved, the more accurate the ',...
       'computed ratio will be. Tip: Press the mouse against a fixed ruler along ',...
       'which you slide it (the direction of movement does not matter). ', ...
       'Place the mouse in the starting position now. Then press any KEYBOARD ', ...
       'KEY to close this message.']);
KbWait;
pause(0.5)

% Get the movement and measure distance
msgbox('Move the mouse now. Press any keyboard key when done moving.');
scrSz = ss-1;
start_x = ceil(scrSz(3)/2);
start_y = ceil(scrSz(4)/2);
robot = java.awt.Robot;
robot.mouseMove(start_x, start_y);
distScreen_px = 0;
while 1    
    x = java.awt.MouseInfo.getPointerInfo().getLocation().getX();
    y = java.awt.MouseInfo.getPointerInfo().getLocation().getY();                
    if KbCheck || any(x == [0,scrSz(3)])  || any(y == [0,scrSz(4)])        
        distScreen_px = distScreen_px + norm(([start_x, start_y] - [x,y]));                        
        robot.mouseMove(start_x, start_y);        
        if KbCheck
            break;
        end      
    end                                
end

% x,y distance travelled on screen
distScreen_mm = distScreen_px / pxPerMm;

% Compute ratio
screenToDesk = distScreen_mm / distWorld_mm;

msgbox(['Screen to world ratio is ' num2str(screenToDesk)]);

end