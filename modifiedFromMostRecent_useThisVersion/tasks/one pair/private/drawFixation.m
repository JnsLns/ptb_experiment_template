% Draw fixation cross to offscreen window winsOff.fix.h

% convert radius and line width of fixation cross from degrees visual angle
% to pixels
fr_px = vaToPx(e.s.fixRadius_va, spatialConfig);
flw_px = vaToPx(e.s.fixLineWidth_va, spatialConfig);

% Draw cross
lineItem(win, [fr_px fr_px], [3 3], {[4 6],[2 8]}, flw_px, ...
         e.s.fixColor, [winsOff.fix.rect(3)/2, winsOff.fix.rect(4)/2])





