function [mm] = pxToMm(px, spatialConfig)
% function [mm] = pxToMm(px, spatialConfig)
%
% Convert pixels to millimeters. px can be a vector.
% 
% Conversion is dependent on the spatial configuration of the experiment,
% which must be supplied in spatialConfig. SpatialConfig is a struct with
% fields:
%
% viewingDistance_mm 	Distance of participant from screen in mm
% expScreenSize_mm      Screen [width, height] in mm (visible image)
% expScreenSize_px      Screen [horz, vert] resolution in pixels
% presArea_va           Presentation area [width, height] in visual angle
%                       (usually defined during trial generation and
%                       found in t.presArea_va).

ess_mm = spatialConfig.expScreenSize_mm;
ess_px = spatialConfig.expScreenSize_px;

mm = px / mean(ess_px./ess_mm);

end