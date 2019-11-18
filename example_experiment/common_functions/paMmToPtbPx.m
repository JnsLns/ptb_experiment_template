function [x_ptb_px, y_ptb_px] = paMmToPtbPx(x_pa_mm, y_pa_mm, spatialConfig)
% function [x_ptb_px, y_ptb_px] = paMmToPtbPx(x_pa_mm, y_pa_mm, spatialConfig)
%
% Convert from presentation area coordinates in millimeters (origin bottom
% left of pres. area, x-axis increasing to the right, y-axis increasing
% upward) to Psychtoolbox coordinates in pixels (origin top left screen
% corner, x-axis increasing to the right, y-axis increasing downward). 
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

ess_mm = spatialConfig.expScreenSize_mm;
pa_va = spatialConfig.presArea_va;

% Compute margins around presentation area in mm
pa_mm = vaToMm(pa_va, spatialConfig);
presMargins_mm = (ess_mm - pa_mm)./2;

% Transform CRF
x_ptb_mm = x_pa_mm + presMargins_mm(1);
y_ptb_mm = -y_pa_mm - presMargins_mm(2) + ess_mm(2);

% Convert to pixels
x_ptb_px = mmToPx(x_ptb_mm, spatialConfig);
y_ptb_px = mmToPx(y_ptb_mm, spatialConfig);

end