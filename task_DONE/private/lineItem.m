
function [grid] = lineItem(win, size_xy, nGrid_xy, line_spec, lineWidth, color, center_xy, compensateLineWidth, boxLineWidth, boxColor)
% function [grid] = lineItem(win, size_xy, nGrid_xy, line_spec, lineWidth, color, center_xy, compensateLineWidth)
%
% Draw lines, specified as connected grid points, to a Psychtoolbox window.
%
% Output 'grid' is just for convenience and shows the grid point indices to
% use when composing line_spec. This exists just to ease shape
% specification for the user. Call lineItem with only one argument
% identical to the 'nGrid_xy' that will later be used, in order to obtain
% 'grid' without drawing anything.
%
% win               PTB window to draw to
% size_xy           [width, height] of the drawn item in pixels
% nGrid_xy          two element vector, number of grid steps horz/vert
% line_spec         cell array of point index vectors. Grid points
%                   specified by consecutive values in the same vector
%                   will be connected by a line. A vector may contain
%                   more than two points, resulting in  a chain of lines.
%                   Points are addressed as in MATLAB linear indexing
%                   (i.e., moving from top to bottom, column by column);
%                   Look at output 'grid' for aid and see example below.
% lineWidth         scalar, in pixels
% color             line color, RGB vector.
% center_xy         position of grid center in PTB window coords (pixels).
% compensateLineWidth  Optional, default true. Adjusts grid extent
%                      depending on requested line width so that the final
%                      shape's extent is exactly the requested size. If
%                      false and there are lines at the border of the
%                      grid specified, each border line will exceed the
%                      requested size by 1/2 line width, since the lines are
%                      centered on the grid edges. If true, horizontal/
%                      vertical grid size is reduced by 1/2 line width for
%                      each vertical/horizontal border line present
%                      (respectively) and item position is adjusted so that
%                      the item is still centered on the desired position.
%                      Note that this does not remedy diagonal line corners
%                      overlapping the requested size area. Use bounding box
%                      for that (see below).
% boxLineWidth      Optional, no bounding box is drawn by default.
%                   Otherwise, this should be a scalar specifying the line
%                   width of a bounding box that will be drawn around and
%                   on top of the drawn item. The bounding box will be
%                   drawn just outside the area defined by size_xy and
%                   never overlap it. If boxLineWidth is defined, then
%                   boxColor as well needs to be supplied.
% boxColor          Color of the bounding box, RGB vector. Setting this to
%                   the window's background color enables hiding corners of
%                   diagonal lines that reach beyond the rectangular area
%                   defined by size_xy.
%
%
% __Example__
%
% For the call
%
% >> lineItem(win, [100, 200], [3 4], {[1 9],[3 6 5]}, ...)
%
% the point grid looks as follows and lines will be drawn from gridpoint
% 1 to 9 and from 3 to 6 to 5:   
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

% for standard functionality
else
    grid = zeros(nGrid_xy)';
    grid(:) = 1:numel(grid);        
end

% Rest of standard functionality...
if nargin > 1

    % Make sure line_spec is a row array
    if size(line_spec,1) > 1
        line_spec = line_spec';
    end
    
    if nargin < 8
        compensateLineWidth = true;        
    end
    
    % store originally requested size for drawing bounding box later
    reqSize_xy = size_xy;
    reqCenter_xy = center_xy;
    
    % reduce size to account for linewidth: deduct 1/2 line width from
    % horz/vert size for each side where a line is specified at the outer
    % border
    borderLines = [0 0 0 0];
    if compensateLineWidth
        % Check which sides are occupied by border lines:
        % top, bottom, left, right border
        borders = {grid(1,:),grid(end,:),grid(:,1),grid(:,end)};        
        for bNum = 1:numel(borders)            
            b = borders{bNum};         
            for line = line_spec
                % border points in current line
                bps = arrayfun(@(x) any(x==b), line{1});
                % any of those directly successive (= border line)?
                if any( diff([0, bps],2) == -1 )                    
                    borderLines(bNum) = 1;
                    break;                    
                end                                
            end
        end
    end      
    % Adjust item size and position accordingly:
    if borderLines(1) && borderLines(2) % top & bottom                                    
        size_xy = size_xy - [0 lineWidth];        
    elseif borderLines(1) % only top    
        size_xy = size_xy - [0 lineWidth/2];
        center_xy = center_xy + [0 lineWidth/4];            
    elseif borderLines(2) % only bottom
        size_xy = size_xy - [0 lineWidth/2];
        center_xy = center_xy - [0 lineWidth/4];        
    end        
    if borderLines(3) && borderLines(4) % left & right        
        size_xy = size_xy - [lineWidth 0];        
    elseif borderLines(3) % only left        
        size_xy = size_xy - [lineWidth/2 0];
        center_xy = center_xy + [lineWidth/4 0];        
    elseif borderLines(4) % only right        
        size_xy = size_xy - [lineWidth/2 0];
        center_xy = center_xy - [lineWidth/4 0];        
    end
        
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
        
    % Draw item
    for idx = 1:numel(line_spec)
        coords = [grid_x(line_spec{idx}) + center_xy(1); ...
                 -grid_y(line_spec{idx}) + center_xy(2)];
        Screen('DrawLines', win, coords, lineWidth, color);
    end
    
    % Draw bounding box on top
    if nargin > 8         
        if nargin < 10
            error('No color specified for line item bounding box.')
        end        
        lineItem(win, reqSize_xy + boxLineWidth, nGrid_xy, ...
            {[grid(1), grid(end,1), grid(end), grid(1,end), grid(1)]}, ...
            boxLineWidth, boxColor, reqCenter_xy, false);                                
    end
        
end


