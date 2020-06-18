function [mouse_xy_pa_va, mouse_xy_ptb_px] = getMouseRemapped(rawRatio, desiredRatioXY, converterObj)
% function [mouse_xy_pa_va, mouse_xy_ptb_px] = getMouseRemapped(rawRatio, desiredRatioXY, converterObj)
%
% Wraps GetMouse() from Psychtoolbox to obtain mouse position, but in
% in addition changes mouse "speed", i.e, how mouse movement on the desk
% maps to cursor movement on the screen. The mapping is changed such that
% it satisfies 'desiredRatioXY' (cursor-to-desk distance ratio). 
% Call this function in a loop where you plot a mouse cursor just as you
% would GetMouse().
% The result is returned in degrees visual angle / presentation area frame
% (first output) as well as in pixels / Psychtoolbox frame (second output).
% Note that outputs are row vectors (x,y) and not scalars as in GetMouse().
%
% Disable mouse acceleration and rerun getMouseScreenToDeskRatio
% whenever changing screen size, resolution, or mouse speed (see
% documentation of getMouseScreenToDeskRatio for details).
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NOTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A convenient way to call this function is built into the experimental
% template: It can be invoked without arguments via the anonymous function
% getMouseRM(), returning the output arguments described here. This works
% within the m-files located in the folder 'paradigmDefinition' and
% requires 't.s.desiredMouseScreenToDeskRatio' to be defined in trial
% generation and 'e.s.rawMouseScreenToDeskRatio' in generalSettings.m.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Note on how this function works: In short, it integrates true mouse
% movement across calls and uses a scaled version to steer a fake cursor.
% Each time it is called, the function resets the true cursor to the screen
% center. Before that, it assesses the vector between current position of
% the true mouse cursor and the screen center (that is the distance moved
% since last call). This vector is scaled by a multiplier determined from
% the ratios, and added to the position of the fake cursor, whose position
% is retained across function calls. Resetting the true cursor to the
% screen center prevents it from reaching the screen border, which would
% jeopardize assessing the moved distance. 
%
%                               ___Input___
%
% rawRatio          Scalar. Ratio of cursor movement distance on the screen
%                   to mouse movement distance on the desk based on system
%                   settings (i.e., before adjustment). Needs to be obtained
%                   in advance via function getMouseScreenToDeskRatio.
%
% desiredRatioXY    Two-element row vector [x,y]. Desired ratio of cursor
%                   movement on the screen to mouse movement on the desk
%                   in horizontal and vertical direction. E.g., if you wish
%                   the cursor to move 50 millimeters across the screen
%                   when the mouse is moved 25 millimeters across the desk,
%                   set this argument to [2,2]. Using [1,1] results in an
%                   unmodified mapping, values below zero to the cursor
%                   moving slower than the mouse.
%
% converterObj      Object of type CoordinateConverter with properties
%                   set according to the spatial configuration of the
%                   experiment (see that class' documentation and/or
%                   Readme.md). That object is usually available through
%                   the variable 'convert' in the experimental code. 
%
%
%                             ___Output___
%
% mouse_xy_pa_va    Two-element row vector, holding x,y mouse position 
%                   after adjustment; in degrees visual angle and in the
%                   presentation-area-based frame.
%
% mouse_xy_ptb_px   Two-element row vector, holding x,y mouse position 
%                   after adjustment; in pixels and in the Psychtoolbox
%                   coordinate frame.


% First get position of mouse pointer in ptb frame, pixels

% Position of visible mouse pointer
persistent fakeCursorPos;

if ~all(size(desiredRatioXY) == [1,2])
    error('Desired ratio must be a two-element row vector.'  )
end

% Compute required multiplier 
multiplier = (1/rawRatio) * desiredRatioXY;

% Get position of screen center (use last screen)
screenCenter = get(max(Screen('Screens')), 'ScreenSize');
screenCenter = round(screenCenter(3:4)/2);

% initialize persisten var on first call
if isempty(fakeCursorPos)
    fakeCursorPos = screenCenter;
end

% Get current position of true cursor
[newTruePos(1),newTruePos(2)] = GetMouse();

% Get movement vector since last call and update cursor pos accordingly
movVec = newTruePos - screenCenter;       
fakeCursorPos = fakeCursorPos + movVec .* multiplier;                                        

mouse_xy_ptb_px(1) = fakeCursorPos(1);
mouse_xy_ptb_px(2) = fakeCursorPos(2);

% Finally, convert to presentation area frame in visual angle
mouse_xy_pa_va = converterObj.ptbPx2paVa(fakeCursorPos(1),fakeCursorPos(2))';

% Move true mouse pointer to middle of screen
SetMouse(screenCenter(1), screenCenter(2));

end