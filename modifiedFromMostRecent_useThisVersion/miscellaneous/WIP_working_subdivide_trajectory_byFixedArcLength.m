
% get current trajectory data;
x = a.tr{1}(:,1);
y = a.tr{1}(:,2);
xy = [x,y];
n_points = size(xy,1);

step_size = 15;

hFig = figure;
hAx = axes;
plot(x,y,'bo-');
hold on;
length_to_shift = 0;


arcLens = sqrt(sum(diff(xy).^2,2));

crs = 0;
while crs < n_points-1 % current raw segment
            
    % find segment for next point based on cumulative arc length    
    crs_old = crs;
    crs = crs + find(cumsum(arcLens(crs+1:end)) > length_to_shift, 1);
    if isempty(crs)
        break;
    end    
    % Reduce length to shift by total length of skipped segments
    length_to_shift = length_to_shift - sum(arcLens(crs_old+1:crs-1));
    
    % points defining current segment
    p1 = xy(crs,:);
    p2 = xy(crs+1,:);
    
    hSeg = plot(hAx, [p1(1),p2(1)], [p1(2),p2(2)] ,'dr');
    
    % vector with same direction as current segment, unit length
    u = (p2-p1)/norm(p2-p1);
    
    hArr = quiver(p1(1), p1(2), u(1), u(2),'linewidth',3, 'maxheadsize', 1, 'color', 'g');
    
    base_point = p1;
    while 1 % this should switch to next raw segment when exceeding current segment's lenght (carry over remaining length of current seg!)
        
        % where to put first vertex of two-segment fragment
        base_point = base_point + u * length_to_shift;
        
        hBpTry = plot(base_point(1), base_point(2),'or', 'markersize', 10, 'color', [0 0 0 .5 ]);
        
        if norm(base_point-p1) < norm(p2-p1) % current segment length NOT exceeded
            
            hBp = plot(base_point(1), base_point(2),'or', 'markersize', 10, 'markerfaceColor', 'r');
            
            xy_temp = xy(crs:end, :);
            xy_temp(1,:) = base_point;
            
            last_used_base_point = base_point;
            length_to_shift = step_size;   
        else % segment length exceeded
            if length_to_shift == step_size
                length_to_shift = length_to_shift - norm(p2 - last_used_base_point);
            elseif length_to_shift < step_size
                length_to_shift = length_to_shift - norm(p2 - p1);
            end
            break;
        end
        
    end
    
end

