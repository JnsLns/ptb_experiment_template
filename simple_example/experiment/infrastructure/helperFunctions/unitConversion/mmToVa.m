function [va] = mmToVa(mm, spatialConfig)
% function [va] = mmToVa(mm, spatialConfig)
%
% Convert millimeters to degrees visual angle. mm can be a vector.
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

vd_mm = spatialConfig.viewingDistance_mm;

va = mm * 180 / (pi * vd_mm);

end