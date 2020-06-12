function [x_ptb_px, y_ptb_px] = paVaToPtbPx(x_pa_va, y_pa_va, spatialConfig)
% function [x_ptb_px, y_ptb_px] = paVaToPtbPx(x_pa_va, y_pa_va, spatialConfig)
%
% Convert from presentation area coordinates in visual angle (origin bottom
% left of pres. area, x-axis increasing to the right, y-axis increasing
% upward) to Psychtoolbox coordinates in pixels (origin top left screen
% corner, x-axis increasing to the right, y-axis increasing downward). 
%
% The first two arguments are x,y values that are to be transformed
% (vectors possible). spatialConfig is a struct that holds information about
% the spatial setup of the experiment, with fields:
%
% viewingDistance_mm 	Distance of participant from screen in mm
% expScreenSize_mm      Screen [width, height] in mm (visible image)
% expScreenSize_px      Screen [horz, vert] resolution in pixels
% presArea_va           Presentation area [width, height] in visual angle
%                       (usually defined during trial generation and
%                       found in t.presArea_va).

% Convert input from visual angle to mm
x_pa_mm = vaToMm(x_pa_va, spatialConfig);
y_pa_mm = vaToMm(y_pa_va, spatialConfig);

% Transform to PTB CRF in pixels
[x_ptb_px, y_ptb_px] = paMmToPtbPx(x_pa_mm, y_pa_mm, spatialConfig);

end