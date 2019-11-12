function [rect] = rectFromPosSize(xywh)
% function [rect] = rectFromPosSize(xywh)
%
% Get a Psychtoolbox rect from an object's center position's x/y
% coordinates and the object's width/height. xywh is a vector holding these
% values (Psychtoolbox frame, in pixels).
%
% For using the returned rect to draw something, the input should already
% be in the psychtoolbox coordinate frame (and in pixels), or the output
% must be be converted to it.

x = xywh(1); % pos x
y = xywh(2); % pos y
w = xywh(3); % width
h = xywh(4); % height

left = x - w/2;
top = y - h/2;
right = x + w/2;
bottom = y + h/2;

rect=[left,top,right,bottom];

end



