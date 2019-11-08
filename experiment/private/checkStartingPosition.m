% Check whether participant is in starting position (tip position and
% pointer angle). The important variables used in the experimental script
% are tipAtStart and withinAngle.

% Check whether it is within starting region
if distFromStart < e.s.startRadius_mm
    tipAtStart = 1;
else
    tipAtStart = 0;
end

% Check whether pointer markers are within prescribed starting angle
% (for all lines from tip position to pointer markers, the angle with the 
% z-axis must be below e.s.pointerStartAngle)
M = filterTrackerData(vzData, e.s.markers.pointer_IDs, true); % pos
V = M - repmat(tipPos_pa, 3, 1);       % vectors from tip to markers
A = zAngle(V);                         % angles from z-axis
if ~any(A > e.s.pointerStartAngle)     % check deviation
    withinAngle = 1;
else
    withinAngle = 0;
end