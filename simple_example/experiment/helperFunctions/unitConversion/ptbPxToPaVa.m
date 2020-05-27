function [x_pa_va, y_pa_va] = ptbPxToPaVa(x_ptb_px, y_ptb_px, spatialConfig)
% function [x_pa_va, y_pa_va] = ptbPxToPaVa(x_ptb_px, y_ptb_px, spatialConfig)
%
% Convert from Psychtoolbox coordinates in pixels (origin top left screen
% corner, x-axis increasing to the right, y-axis increasing downward) to
% presentation area coordinates in visual angle (origin bottom left of pres.
% area, x-axis increasing to the right, y-axis increasing upward).
%
% The first two arguments are x,y values that are to be transformed
% (vectors possible). spatialConfig is a stuct that holds information about
% the spatial setup of the experiment, with fields:
%
% viewingDistance_mm 	Distance of participant from screen in mm
% expScreenSize_mm      Screen [width, height] in mm (visible image)
% expScreenSize_px      Screen [horz, vert] resolution in pixels
% presArea_va           Presentation area [width, height] in visual angle
%                       (usually defined during trial generation and
%                       found in tg.presArea_va).

% Transform ptb frame in pixels to presentation area frame in mm
[x_pa_mm, y_pa_mm] = ptbPxToPaMm(x_ptb_px, y_ptb_px, spatialConfig);

% Convert from millimeters to visual angle
x_pa_va = mmToVa(x_pa_mm, spatialConfig);
y_pa_va = mmToVa(y_pa_mm, spatialConfig);

end