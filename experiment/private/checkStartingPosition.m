% Check whether participant is in starting position (tip position and
% pointer angle). The important variables used in the experimental script
% are tipAtStart and withinAngle.

% determine distance to starting position
distFromStart_va = dist3d([mouse_xy_pa_va, 0], [e.s.startPos_va, 0], [0 0 1]);

% Check whether it is within starting region
if distFromStart_va < e.s.startRadius_va
    tipAtStart = 1;
else
    tipAtStart = 0;
end