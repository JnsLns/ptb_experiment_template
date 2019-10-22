function [xyz_pa_mm] = scrMmToPaMm_xyz(xyz_scr_mm, spatialConfig)
% function [xyz_pa_mm] = scrMmToPaMm_xyz(xyz_scr_mm, spatialConfig)
%
% Same as scrMmToPaMm, but takes three-element (x,y,z) position vector as
% input and returns the transformed vector. Z-value will be unmodified.
%
% Converts from screen coordinates in millimeters (origin bottom
% left of screen, x-axis increasing to the right, y-axis increasing
% upward) to presentation area coordinates in millimeters (origin bottom
% left of pres. area, x-axis increasing to the right, y-axis increasing
% upward). 
%
% The first argument is a vector of x,y,z values that are to be
% transformed. spatialConfig is a stuct that holds information about
% the spatial setup of the experiment, with fields:
%
% viewingDistance_mm 	Distance of participant from screen in mm
% expScreenSize_mm      Screen [width, height] in mm (visible image)
% expScreenSize_px      Screen [horz, vert] resolution in pixels
% presArea_va           Presentation area [width, height] in visual angle
%                       (usually defined during trial generation and
%                       found in tg.presArea_va).

ess_mm = spatialConfig.expScreenSize_mm;
pa_va = spatialConfig.presArea_va;

% Compute margins around presentation area in mm
pa_mm = vaToMm(pa_va, spatialConfig);
presMargins_mm = (ess_mm - pa_mm)./2;

% Subtract margins
xyz_pa_mm(1) = xyz_scr_mm(1) - presMargins_mm(1);
xyz_pa_mm(2) = xyz_scr_mm(2) - presMargins_mm(2);
xyz_pa_mm(3) = xyz_scr_mm(3);

end