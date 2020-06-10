function [mouse_xy_pa_va, mouse_xy_ptb_px] = getMouseRemapped(rawRatio, desiredRatioXY, spatialConfig)
% function [mouse_xy_pa_va, mouse_xy_ptb_px] = getMouseRemapped(rawRatio, desiredRatioXY, spatialConfig)
%
% Wraps GetMouse() from Psychtoolbox to obtain mouse position while changing 
% the mapping from mouse movement on the desk to cursor movement on the
% screen, in order to instead satisfy the mapping specified by 'desiredRatioXY'.
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
% requires 'tg.s.desiredMouseScreenToDeskRatio' to be defined in trial
% generation and 'e.s.rawMouseScreenToDeskRatio' in generalSettings.m.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                               ___Input___
%
% rawRatio          Scalar. Ratio of cursor movement distance on the screen
%                   to mouse movement distance on the desk based on system
%                   settings (i.e., before adjustment). Needs to be obtained
%                   in advance via getMouseScreenToDeskRatio.
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
% spatialConfig     Struct holding information about the spatial setup
%                   of the experiment. If using the experimental template
%                   it will be in the workspace by default as 
%                   'e.s.spatialConfig'. It must have the following fields:
%
%                   viewingDistance_mm 	Distance of participant from screen in mm
%                   expScreenSize_mm    Screen [width, height] in mm (visible image)
%                   expScreenSize_px    Screen [horz, vert] resolution in pixels
%                   presArea_va         Presentation area [width, height] in visual angle
%                                       (usually defined during trial generation and
%                                       found in tg.presArea_va).
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

% Store reference mouse position across calls of this funciton
persistent oldPos;

if ~all(size(desiredRatioXY) == [1,2])
    error('Desired ratio must be a two-element row vector.'  )
end

% Compute required multiplier 
multiplier = (1/rawRatio) * desiredRatioXY;

[newPos(1),newPos(2)] = GetMouse();

if ~isempty(oldPos) && ~all(oldPos==newPos)    
    mov = newPos - oldPos;   
    newPos = oldPos + mov .* multiplier;                    
    SetMouse(ceil(newPos(1)),ceil(newPos(2)));
end

oldPos = newPos;
mouse_xy_ptb_px(1) = newPos(1);
mouse_xy_ptb_px(2) = newPos(2);


% Finally, convert to presentation area frame in visual angle

[mouse_xy_pa_va(1), mouse_xy_pa_va(2)] = ...
    ptbPxToPaVa(mouse_xy_ptb_px(1), mouse_xy_ptb_px(2), spatialConfig);   


end