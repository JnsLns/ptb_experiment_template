function [inRect, which] = checkCursorInRect(mouse_xy, centers_xy, sides_xy)
% function [inRect, which] = checkCursorInRect(mouse_xy, centers_xy, sides_xy)
%
% Check whether mouse cursor is within any of a number of rectangles with
% given mid points and side lengths.
%
%                           __Input__
%
% mouse_xy      Two-element row vector giving current cursor position.
%
% centers_xy    n-by-2 matrix, where n is the number of rectangles for
%               which you want to check whether they contain the mouse
%               cursor. Each row holds the x,y coordinates of a rectangle
%               mid point.
%
% sides_xy      n-by-2 matrix, where n is the number of rectangles for
%               which you want to check whether they contain the mouse
%               cursor. Each row holds the x,y side lenght a rectangle. Can
%               also have only one row; if so and centers_xy has more than
%               one row, the same side lengths are used for all rectangles.
%
%                           __Output__
%
% inRect        Boolean. True if cursor within any rectangle, false otherwise.
%
% which         Row vector indicating the rectangles that contain the mouse
%               cursor. Holds indices of the rows of the respective
%               rectangles in 'centers_xy'.
 
within = all(abs(mouse_xy - centers_xy) <= sides_xy/2, 2);
inRect = any(within);
which = find(within);

