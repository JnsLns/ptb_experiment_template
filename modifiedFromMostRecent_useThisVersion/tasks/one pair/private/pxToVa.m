function [va] = pxToVa(px, spatialConfig)
% function [va] = pxToVa(px, spatialConfig)
%
% Convert pixels to degrees visual angle. px can be a vector.
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
%                       found in tg.presArea_va).

mm = pxToMm(px, spatialConfig);
va = mmToVa(mm, spatialConfig);

end