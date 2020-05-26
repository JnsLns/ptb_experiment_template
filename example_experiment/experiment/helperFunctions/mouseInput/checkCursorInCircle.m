function inCircle = checkCursorInCircle(mouse_xy, center_xy, radius)
% function inCircle = checkCursorInCircle(mouse_xy, center_xy, radius)
%
% Check whether mouse cursor is within a circle with given mid point and
% radius. Note that all input arguments should be in the same units and
% coordinate frame (usually degrees visual angle, presentation area frame).
%
%
% __Input__
%
% mouse_xy      Two-element row vector giving current cursor position.
%
% center_xy     Mid point of circle. 
%
% radius        Radius of circle
%
% __Output__
%
% inCircle      Boolean. True if cursor within circle, false otherwise.

distFromCenter = dist3d([mouse_xy, 0], [center_xy, 0], [0 0 1]);

if distFromCenter <= radius
    inCircle = 1;
else
    inCircle = 0;
end

