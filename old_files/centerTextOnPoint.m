function [textRect_x, textRect_y] = centerTextOnPoint(string, window, x, y);

% [textRect_x, textRect_y] = centerTextOnPoint(string, window, x, y)
%
% Takes as input a string, a Psychtoolbox window to which it will be
% drawn, and the x and y coordinates (in pixels) of where the center of the
% rect enclosing the text should be. Returns x and y coordinates to be used 
% when actually drawing the text.

[textBounds, ~] = Screen('TextBounds', window, string);
textRect = CenterRectOnPoint(textBounds, x, y);
textRect_x = textRect(1);
textRect_y = textRect(2);

end
