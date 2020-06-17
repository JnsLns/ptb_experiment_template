 % function multiplier = mouseRemapCalib(distWorld_mm, desiredRatioScreenToWorld, screenSizeXY_mm, screenResXY_px)
%
% This function computes the ratio of actual mouse movement distance (on the
% desk) to mouse pointer movement distance (on the screen). Using the returned
% value as a multiplier for the moved screen distance that results from a given
% mouse movement, one can achieve arbitrary mappings between mouse movement
% and distance travelled on the screen. Use getMouseRemapped  to realize
% this.
% To be able to compute the ratio, a sample of actual mouse movement across
% a defined distance is needed. This sample is acquired by requesting a
% straight, vertical mouse movement once the function is called.
% Note that the returned multiplier is specific to the system (its settings),
% the mouse used, and the screen hardware. Changing any of these components
% may require re-calibration.
% Note that this function works properly only if the initial mouse-pointer
% mapping is constant for horizontal and vertical movement (which is
% normally the case).
%
% IMPORTANT: Disable mouse acceleration before calibration and during any
% experiments run using the returned multiplier.  
% 
% distWorld_mm: Scalar giving the distance that the mouse will be moved
% across the desk as a sample movement, in millimeters. Larger distances
% will result in better estimates of the multiplier. However, setting the
% value too high may result in reaching the screen borders during
% calibration, which results in invalid output (a warning will be issued
% in this case).
%
% desiredRatioScreenToWorld: Scalar giving the ratio of screen to desk
% movement distance that the multiplier should produce (1 means the pointer
% moves the same number of mm as the mouse was moved; higher values are
% equivalent to pointer moving farther than mouse).
%
% screenSizeXY_mm: 2-element row vector giving the horizontal and vertical
% extent of the visible area of the screen. 
%
% screenResXY_px (optional, default screen 0): Resolution in pixels of the 
% screen used. Can be either a 2-element row vector holding the horizontal
% and vertical number of pixels for the screen used, or the screen number of
% a connected screen from which these values should be acquired. 

function multiplier = mouseRemapCalib(distWorld_mm, desiredRatioScreenToWorld, screenSizeXY_mm, screenResXY_px)

% third arg not defined --> use res of first screen
% third arg is scalar --> use the screen denoted by that scalar
% this arg is vector --> retain that vector and use as res
whichScreen = [];
if nargin < 4
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
waitfor(msgbox('Reminder: Disable mouse acceleration before calibration and during experiments that use the determined multiplier. If mouse speed is later changed in system/mouse driver settings calibration has to be renewed.'));
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
        waitfor(errordlg('Reached screen border. Returned value will not be valid. Try again with a smaller value for distWorld_mm and/or decrease mouse speed in system settings.'));
        break;
    end
    if KbCheck
        break;
    end
end
[mx2,my2] = GetMouse();

% distance travelled on screen
distScreen_px = abs([mx2,my2]-[mx1,my1]);
distScreen_mm = distScreen_px ./ pxPerMm;

% Compute overall multiplier
multiplier = 1/  (sqrt(sum(distScreen_mm.^2)) ./ distWorld_mm .* (1/desiredRatioScreenToWorld));

msgbox(['Multiplier is ' num2str(multiplier)]);

end