function [px] = vaToPx(va, spatialConfig)
% function [px] = vaToPx(va, spatialConfig)
%
% Convert degrees of visual angle to pixels. va can be a vector.
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

mm = vaToMm(va, spatialConfig);
px = mmToPx(mm, spatialConfig);

end