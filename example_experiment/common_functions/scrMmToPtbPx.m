function [x_ptb_px, y_ptb_px] = scrMmToPtbPx(x_scr_mm, y_scr_mm, spatialConfig)
% function [x_ptb_px, y_ptb_px] = scrMmToPtbPx(x_scr_mm, y_scr_mm, spatialConfig)
%
% Convert from screen coordinates in millimeters (origin bottom
% left of screen, x-axis increasing to the right, y-axis increasing
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

% Transform CRF
y_ptb_mm = ess_mm(2) - y_scr_mm;

% Convert to pixels
x_ptb_px = mmToPx(x_scr_mm, spatialConfig);
y_ptb_px = mmToPx(y_ptb_mm, spatialConfig);

end