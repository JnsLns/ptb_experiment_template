function screenToDesk = getMouseScreenToDeskRatio(distWorld_mm, screenSizeXY_mm, screenResXY_px)
% function screenToDesk = getMouseScreenToDeskRatio(distWorld_mm, screenSizeXY_mm, screenResXY_px)
%
% This function helps measuring the ratio of cursor movement distance on
% the screen and mouse movement distance on the desk (screen / desk). For
% this the function requests a straight, vertical mouse movement over a
% predefined length as a movement sample. The user is notified of the
% required steps via message boxes. Results will be most accurate when
% mouse speed is set as low as possible in the system settings.
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
% and plot a mouse cursor at the position returned by that function
%
% Note that this function works properly only if the raw mouse-pointer
% mapping is the same in horizontal and vertical direction, which is
% usually the case.
%
%                            ___Input___
%
% distWorld_mm      Scalar giving the distance that the mouse will be moved
%                   across the desk as a sample movement, in millimeters.
%                   Larger distances will result in better estimates of the
%                   ratio. However, setting the value too high may result
%                   in reaching the screen borders during calibration,
%                   which results in invalid output (a warning will be
%                   issued in this case).
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
% 
%                           ___Output___
%
% screenToDesk     Scalar, ratio of cursor movement distance on the screen
%                  and mouse movement distance on the desk (screen divided
%                  by desk).


% third arg not defined --> use res of first screen
% third arg is scalar --> use the screen denoted by that scalar
% this arg is vector --> retain that vector and use as res
whichScreen = [];
if nargin < 3
    whichScreen = 0;
elseif numel(screenResXY_px) == 1
    whichScreen = screenResXY_px;
end
if ~isempty(whichScreen)
    ss = get(whichScreen,'ScreenSize');
    screenResXY_px = ss(3:4);
end

% Ratio of pixels to physical size
pxPerMm = screenResXY_px./screenSizeXY_mm;

% Get initial position
pause(0.2);
waitfor(msgbox('Reminder: Disable mouse acceleration before calibration and during experiments that use the determined value. If mouse speed is later changed in system/mouse driver settings calibration has to be renewed.'));
msgbox('Place the mouse in the starting position. Do not move it until instructed to. Press any keyboard key when ready.');
KbWait;
pause(0.5);

% Move mouse and get final position
SetMouse(ceil(screenResXY_px(1)/2),screenResXY_px(2)-ceil(screenResXY_px(2)/10));
msgbox(['Press any keyboard key to close this message. When instructed to, move the mouse forward along a straight line of ' num2str(distWorld_mm) ' millimeters.']);
KbWait;
pause(0.5)
msgbox('Move the mouse now. Press any keyboard key when done moving.');
[mx1,my1] = GetMouse();
while 1 % during movement check that screenborder isn't reached
    [mx,my] = GetMouse();
    if any([mx,my]==screenResXY_px-1) || any([mx,my]==[0 0])
        waitfor(errordlg('Cursor reached screen border. Returned value will not be valid. Try again with a smaller value for distWorld_mm and/or decrease mouse speed in system settings.'));
        break;
    end
    if KbCheck
        break;
    end
end
[mx2,my2] = GetMouse();

% x,y distance travelled on screen
distScreenXY_px = abs([mx2,my2]-[mx1,my1]);
distScreenXY_mm = distScreenXY_px ./ pxPerMm;

% Compute ratio
distScreen_mm = sqrt(sum(distScreenXY_mm.^2));
screenToDesk = distScreen_mm / distWorld_mm;

msgbox(['Screen to world ratio is ' num2str(screenToDesk)]);

end