
segLen = 15;           % length of segments of fitted fragment
stepSize = 1;      % step size, i.e. trajectory arc length by which fragment's first vertex is moved each step
symThresh = 0.05;   % used in call of interpToUniformSegments_fixedn
symTime = 1;        % used in call of interpToUniformSegments_fixedn
decRound = 2;       % used in call of interpToUniformSegments_fixedn


function [maxAngle, localAngles] = localAngle(x, y, segLen, stepSize, symThresh, symTime, decRound)



xy = [x,y];
localAngles = [];
trSegLens = sqrt(sum(diff(xy).^2,2)); % lengths of individual segments of input trajectory

length_to_shift = 0;    % distance by which the next point needs to be moved along trajectory in order
% to be stepSize arc length from the last points, starting
% from first point of segment that the next point will lie in.

% Function to compute angle in radians between vectors u and v
vAng =  @(u,v) acos(dot(u,v) /( norm(u)*norm(v)));

crs = 0; % current segment of trajectory, iterate over these
while crs < size(xy,1)-1
    
    % find segment of raw data in which the next point will lie,
    % based on cumulative arc length
    crs_old = crs;
    crs = crs + find(cumsum(trSegLens(crs+1:end)) > length_to_shift, 1);
    if isempty(crs)
        break;
    end
    
    % Reduce length_to_shift by total length of skipped segments
    length_to_shift = length_to_shift - sum(trSegLens(crs_old+1:crs-1));
    
    % points defining current segment
    p1 = xy(crs,:);
    p2 = xy(crs+1,:);
    
    % vector with same direction as current segment, unit length
    u = (p2-p1)/norm(p2-p1);
    
    base_point = p1;
    while 1 % switches to next raw segment when exceeding current segment's length (but remaining length of current seg is carried over)
        
        % where to put first vertex of two-segment fragment
        base_point = base_point + u * length_to_shift;
        
        % current segment length NOT exceeded
        if norm(base_point-p1) < norm(p2-p1)
            
            xy_temp = xy(crs:end, :);
            xy_temp(1,:) = base_point;
            % Fit two-segment fragment to trajctory
            % (i.e., interpolate two segments with chosen segment length)
            [interpCurve,~] = interpToUniformSegments_fixedn(xy_temp(:,1), xy_temp(:,2), segLen, 0 , symThresh, symTime, decRound, 3);
            % Compute angle between these segments
            if size(interpCurve,1) == 3
                localAngles(end+1) = vAng(interpCurve(2,:)-interpCurve(1,:), interpCurve(3,:)-interpCurve(2,:));
            end
            last_used_base_point = base_point;
            length_to_shift = stepSize;
            
            % current segment exceeded
        else
            
            if length_to_shift == stepSize
                length_to_shift = length_to_shift - norm(p2 - last_used_base_point);
            elseif length_to_shift < stepSize
                length_to_shift = length_to_shift - norm(p2 - p1);
            end
            break;
            
        end
        
    end
    
end

maxAngle = max(localAngles);



end