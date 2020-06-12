function [x_pa_mm, y_pa_mm] = scrMmToPaMm(x_scr_mm, y_scr_mm, spatialConfig)
% function [x_pa_mm, y_pa_mm] = scrMmToPaMm(x_scr_mm, y_scr_mm, spatialConfig)
%
% Convert from screen coordinates in millimeters (origin bottom
% left of screen, x-axis increasing to the right, y-axis increasing
% upward) to presentation area coordinates in millimeters (origin bottom
% left of pres. area, x-axis increasing to the right, y-axis increasing
% upward).
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
%                       found in t.presArea_va).

ess_mm = spatialConfig.expScreenSize_mm;
pa_va = spatialConfig.presArea_va;

% Compute margins around presentation area in mm
pa_mm = vaToMm(pa_va, spatialConfig);
presMargins_mm = (ess_mm - pa_mm)./2;

% Subtract margins
x_pa_mm = x_scr_mm - presMargins_mm(1);
y_pa_mm = y_scr_mm - presMargins_mm(2);

end