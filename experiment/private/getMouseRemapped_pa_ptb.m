function [mouse_xy_pa_va, mouse_xy_ptb_px] = getMouseRemapped_pa_ptb(multiplierXY, spatialConfig)
% function [mouse_xy_pa_va, mouse_xy_ptb_px] = getMouseRemapped_pa_ptb(multiplierXY, spatialConfig)
%
% Wraps getMouseRemapped (which gets mouse position remapped based on a
% multiplier to actual mouse movement), returning mouse
% position in the presentation-area-based frame (in visual angle) in addition
% to mouse position in the Psychtoolbox frame (in pixels).
%
% spatialConfig is a stuct that holds information about the spatial setup
% of the experiment, with fields:
%
% viewingDistance_mm 	Distance of participant from screen in mm
% expScreenSize_mm      Screen [width, height] in mm (visible image)
% expScreenSize_px      Screen [horz, vert] resolution in pixels
% presArea_va           Presentation area [width, height] in visual angle
%                       (usually defined during trial generation and
%                       found in tg.presArea_va).
%
% See also GETMOUSEREMAPPED.

% get position of mouse pointer (in ptb frame, pixels)
[mouse_xy_ptb_px(1), mouse_xy_ptb_px(2)] = getMouseRemapped(multiplierXY);
        
% Convert to presentation area frame in visual angle
[mouse_xy_pa_va(1), mouse_xy_pa_va(2)] = ...
    ptbPxToPaVa(mouse_xy_ptb_px(1), mouse_xy_ptb_px(2), spatialConfig);   

end