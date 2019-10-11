
% NOTE: This pretty much seems to work! Needs only a little more testing (compare
% results to old code) and then this can replace the older code in analysis
% scripts!


% This computes trajectory curvature in the exact manner described in the
% paper... that is, by fitting a two-segment trajectory fragment to the
% trajectories and computing the curvature at each point (and then
% outputting the highest value found for each trajectory).


csl = 15;           % length of segments of fitted fragment
step_size = 1;      % step size, i.e. trajectory arc length by which fragment's first vertex is moved each step
symThresh = 0.05;   % used in call of interpToUniformSegments_fixedn
symTime = 1;        % used in call of interpToUniformSegments_fixedn
decRound = 2;       % used in call of interpToUniformSegments_fixedn

% source data TODO: Adjust when integrating this into analysis script
trs = a.tr; %(logical(a.rs(:,a.s.resCols.exceedsCurveThresh)));

% FOR DEBUG PLOTTING
doPlot = 0;
if doPlot
    hTrFig = figure;
end

maxCurvatures_newMethod = [];
maxAngles_newMethod = [];
parfor i = 1:numel(trs)
    
    disp(i);
    
    % get current trajectory data;
    x = trs{i}(:,1);
    y = trs{i}(:,2);
    
    xy = [x,y];
    n_points = size(xy,1);
    % distance by which two-segment thing is shifted each step
        
    obtainedCurvatures = [];
    obtainedAngles = [];            
    
    length_to_shift = 0;   % arc length that next point needs to be moved along trajectory in order
                           % to be step_size arc length from the last points, starting 
                           % from first point of segment that the next point will lie in.
    arcLens = sqrt(sum(diff(xy).^2,2)); % arc lengths for each trajectory segment in raw data
    
    crs = 0;
    while crs < n_points-1 % current raw segment
    
        % find segment of raw data in which the next point will lie, 
        % based on cumulative arc length
        crs_old = crs;
        crs = crs + find(cumsum(arcLens(crs+1:end)) > length_to_shift, 1);
        if isempty(crs)
            break;
        end
        % Reduce length_to_shift by total length of skipped segments
        length_to_shift = length_to_shift - sum(arcLens(crs_old+1:crs-1));
    
        % points defining current segment
        p1 = xy(crs,:);
        p2 = xy(crs+1,:);
        % vector with same direction as current segment, unit length
        u = (p2-p1)/norm(p2-p1);
        
        base_point = p1;                
        while 1 % this should switch to next raw segment when exceeding current segment's lenght (carry over remaining length of current seg!)
            
            % where to put first vertex of two-segment fragment            
            base_point = base_point + u * length_to_shift;                         
                     
            if norm(base_point-p1) < norm(p2-p1) % current segment length NOT exceeded                                
                xy_temp = xy(crs:end, :);
                xy_temp(1,:) = base_point;
                % Interpolate based on segment length, but only 2 segments!
                [interpCurve,~] = interpToUniformSegments_fixedn(xy_temp(:,1), xy_temp(:,2), csl, 0 , symThresh, symTime, decRound, 3);
                % Compute curvature for these segments                 
                if size(interpCurve,1) == 3
                    lastInterpCurve = interpCurve; % for debug plotting
                    k = curvatureOsc(interpCurve,0);
                    obtainedCurvatures(end+1) = k(2);
                    obtainedAngles(end+1) = vecAngle(interpCurve(2,:)-interpCurve(1,:), interpCurve(3,:)-interpCurve(2,:));
                end
                    
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
                
    % debug plotting (plots the trajectory and curvature values for each
    % placement of the fitted fragement's first vertex along the trajectory;
    % arc lengths are mapped back to y-values for this here)
    if doPlot
        hTrFig;
        ax1 = subplot(1,2,1);
        trPlot = plot(xy(:,1),xy(:,2));
        ax1.NextPlot = 'add';
        grid on;
        icPlot = plot(lastInterpCurve(:,1),lastInterpCurve(:,2),'or-');
        ax1.NextPlot = 'replace';
        ax1.YLim = [min(xy(:,2));max(xy(:,2))];
        axis equal;
        ax2 = subplot(1,2,2);
        
        % total trajectory arc length up to each vertex of the raw trajectory
        trArcLen = [0; cumsum([sqrt(sum(diff(xy).^2,2))])];
        % highest arc length for which angle should be available
        nAngles = numel(obtainedAngles);
        angleMaxArcLen = nAngles*step_size;
        % arc length for each angle in obtainedAngles
        angleArcLengths = linspace(0, angleMaxArcLen, nAngles);
        % get y value for each angle (first point of fragment)
        rawYVals = xy(:,2);
        angles_y = interp1(trArcLen, rawYVals, angleArcLengths);
        
        angPlot = plot(obtainedAngles, angles_y);
        grid on;
        ax2.YLim = ax1.YLim;
        ax2.XLim = [0,3];
        line(ax2,[0.933,0.933], ax2.YLim,'color','r');
        line(ax1, ax1.XLim, angles_y([end end]));
        line(ax2, ax2.XLim, angles_y([end end]));
        drawnow;
    end
        
maxCurvatures_newMethod(i,1) = max(obtainedCurvatures);
maxAngles_newMethod(i,1) = max(obtainedAngles);
    
end

