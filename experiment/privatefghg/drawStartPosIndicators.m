% Draw indicator to show in which direction the pointer has to be moved to
% arrive at the starting position (circle for distance)


% Draw circle around cursor, radius depending on distance from start,
% color changing when at starting position;
if tipAtStart
    circleColor = e.s.circleOkColor;
else
    circleColor = e.s.circleNotOkColor;
end
distFromStart_px = vaToPx(distFromStart_va, e.s.spatialConfig);
circleRect = rectFromPosSize([mouse_xy_ptb_px, distFromStart_px([1 1])*2]);
clw_px = vaToPx(e.s.circleLineWidth_va, e.s.spatialConfig);
Screen('FrameOval', winOn.h, circleColor, ...
    circleRect, clw_px, clw_px);


