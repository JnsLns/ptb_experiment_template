function inRect = checkCursorInRect(mouse_xy, center_xy, sides_xy)
% function inRect = checkCursorInRect(mouse_xy, center_xy, sides_xy)
%
% Check whether mouse cursor is within a rectangle with given mid point and
% side lengths. Note that all input arguments should be in the same units
% and coordinate frame (usually degrees visual angle, presentation area frame).
%
%
%                               __Input__
%
% mouse_xy      Two-element row vector giving current cursor position.
%
% center_xy     Mid point of rectangle. 
%
% sides_xy      Side lengths of rectangle.
%
%                              __Output__
%
% inRect        Boolean. True if cursor within rectangle, false otherwise.

inRect = all(abs(mouse_xy - center_xy) <= sides_xy/2);


