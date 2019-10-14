
function [grid] = lineItem(win, size_xy, nGrid_xy, line_spec, lineWidth, color, center_xy)
% function lineItem(win, size_xy, nGrid_xy, line_spec, lineWidth, color, center_xy)
%
% Draw lines specified as connected grid points to a Psychtoolbox window.
%
% Output 'grid' is just for convenience and shows the grid point indices to
% use when composing line_spec. This exists just to ease shape
% specification for the user. Call lineItem with only one argument
% identical to the 'nGrid_xy' that will later be used, in order to obtain
% 'grid' without drawing anything.
%
% win               PTB window to draw to
% size_xy           [width, height] in pixels
% nGrid_xy          two element vector, number of grid steps horz/vert
% line_spec         cell array of point index vectors. Grid points
%                   specified by consecutive values in the same vector
%                   will be connected by a line. A vector may contain
%                   more than two points, resulting in  a chain of lines.
%                   Points are addressed as in MATLAB linear indexing
%                   (i.e., moving from top to bottom, column by column);
%                   Look at output 'grid' for aid.
% lineWidth         in pixels
% color             rgb vector
% center_xy         position of grid center in PTB window coords, pixels.
%
% __Example__
%
% For the call    lineItem(win, [100, 200], [3 4], {[1 9],[3 6 5]}, ...)
% the grid looks as follows and lines will be drawn from gridpoint 1 to 9
% and from 3 to 6 to 5:   
%                                 1 5 9  |
%                                 2 6 10 | 200 px
%                                 3 7 11 |
%                                 4 8 12 |
%                                 ------
%                                 100 px    



% Just for help in specifying shapes...
if nargin == 1
    nGrid_xy = win; 
    grid = zeros(nGrid_xy)';
    grid(:) = 1:numel(grid);
end

% Actual functionality...
if nargin > 1
    
    % Make lookup grid of point coordinates
    p_x = linspace(-size_xy(1)/2, size_xy(1)/2, nGrid_xy(1));
    p_y = linspace(size_xy(2)/2, -size_xy(2)/2, nGrid_xy(2));
    [grid_x, grid_y] = meshgrid(p_x, p_y);
    
    % Duplicate points to specify start/end points for multi-segment lines
    for el = 1:numel(line_spec)
        tmp = [];
        for pos = 1:numel(line_spec{el})-1
            tmp(end+1:end+2) = line_spec{el}(pos:pos+1);
        end
        line_spec{el} = tmp;
    end
        
    % Draw
    for idx = 1:numel(line_spec)
        coords = [grid_x(line_spec{idx}) + center_xy(1); ...
            -grid_y(line_spec{idx}) + center_xy(2)];
        Screen('DrawLines', win, coords, lineWidth, color);
    end
    
end


