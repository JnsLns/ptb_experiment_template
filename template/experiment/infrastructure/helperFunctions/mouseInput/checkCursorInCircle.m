function [inCircle, which] = checkCursorInCircle(mouse_xy, centers_xy, radiuses)
% function [inCircle, which] = checkCursorInCircle(mouse_xy, centers_xy, radiuses)
%
% Check whether mouse cursor is within any of a number of circles with
% given mid points and radiuses. Note that all input arguments should be in
% the same units and coordinate frame. 
%
%                                   __Input__
%
% mouse_xy      Two-element row vector giving current cursor position.
%
% centers_xy    Two-element row vector, x,y coordinates for circle mid
%               point of circle. Can also be be an n-by-2 matrix, where n
%               is the number of circles for which you want to check
%               whether they contain the mouse cursor.
%
% radiuses      Integer or n-element column vector, where n is the number
%               of circles for which you want to check whether they contain
%               the mouse cursor. Radiuses of circles. If an integer is
%               passed, all circles are assumed to have the same radius.
%
%                                  __Output__
%
% inCircle      Boolean. True if cursor within circle, false otherwise.
%
% which       Row vector indicating the circles that contain the mouse
%               cursor. Holds indices of the rows of the respective circles
%               in 'centers_xy'.

centers_xy(:,end+1) = 0;
distFromCenter = dist3d([mouse_xy, 0], centers_xy, [0 0 1]);

if size(radiuses,2) > 1
    error('Argument radiuses must be a column vector.')
end

within = distFromCenter <= radiuses;
inCircle = any(within);
which = find(within);


