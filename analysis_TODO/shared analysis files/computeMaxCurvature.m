disp('Computing max curvature (for a.rs(:,a.s.resCols.maxCurvature))...');

% --- compute max curvature
% compute curvature for each trajectory (method of osculating circle with
% preceeding interpolation of trajectory to uniform segment length)

% non-parallel version
% a.rs(:,a.s.resCols.maxCurvature) = cellfun(@(ct) max(curvatureOsc(ct(:,[a.s.trajCols.x,a.s.trajCols.y]),1,a.s.curvatureSegmentLength,a.s.symThreshForCurvature,a.s.symTimeThreshForCurvature,a.s.roundToDecForCurvature)) ,  a.tr);

% parallel version
trajs_xy_tmp = cellfun(@(trtmp) trtmp(:,[a.s.trajCols.x,a.s.trajCols.y]),a.tr,'uniformoutput',0);
curvatureSegmentLength_tmp = a.s.curvatureSegmentLength;
symThreshForCurvature_tmp = a.s.symThreshForCurvature;
symTimeThreshForCurvature_tmp = a.s.symTimeThreshForCurvature;
roundToDecForCurvature_tmp = a.s.roundToDecForCurvature;
maxCurvatures_tmp = cell(numel(trajs_xy_tmp),1);

parfor curTraj = 1:numel(trajs_xy_tmp)
    
    %maxCurvatures(curTraj,1) = max(curvatureOsc(trajs_xy_tmp{curTraj},1,curvatureSegmentLength_tmp,symThreshForCurvature_tmp,symTimeThreshForCurvature_tmp,roundToDecForCurvature_tmp));
    %
    % This line is the old and simple curvature computation (used in Lins &
    % Schöner 2017), which consists of interpolating each raw trajecotry
    % in a single pass to uniform segment lenght, and then asessing
    % three-point osuclating curvature for each vertex. It can simply be
    % uncommented and used instead of the next code block.
            
    % Multi-pass curvatur computation
    %
    % get current trajectory data;
    tr_x = trajs_xy_tmp{curTraj}(:,1);
    tr_y = trajs_xy_tmp{curTraj}(:,2);
    % Compute curvature using the trajectories first data point as starting
    % point (in contrast to below, where the starting point is shifted along
    % the arc length of trajectory); also get arc spanned by each segment of
    % the space-interpolated curve on the basis of which curvature is computed.
    [obtainedCs,~,arcSpanned] = curvatureOsc([tr_x,tr_y],1,curvatureSegmentLength_tmp,symThreshForCurvature_tmp,symTimeThreshForCurvature_tmp,roundToDecForCurvature_tmp);
    % the arc length spanned by the first segment of length a.s.curvatureSegmentLength
    % is the length over which starting points for curvature computation will
    % be distributed.
    startRangeArcLen = arcSpanned(1);
    % based on this arc length, compute steps of arc length (measured from
    % trajs first data point) for basing curvature computation on. This way,
    % coverage (sampling density) will be equal independent of total length of
    % trajectory.
    startLengths = linspace(0,startRangeArcLen,ceil(startRangeArcLen/a.s.curveComputationStartPointsSeparation));
    startLengths = startLengths(2:end);
    for curStartLen = startLengths
        % compute cumulative arc length of trajectory at each vertex
        tr_segLens = sqrt(diff(tr_x).^2 + diff(tr_y).^2) ;
        tr_arcLength = [0;cumsum(tr_segLens)];
        % find number of vertex that is at end of segment within which desired arc length lies
        vtx = sum((tr_arcLength - curStartLen)<=0)+1;
        % excess arc length of current start length beyond total arc length up to
        % vertex preceding vtx (i.e., length that we need to move along trajectory
        % segment just below vtx to find our starting point)
        excessLen = curStartLen-tr_arcLength(vtx-1);
        % make unit vector parallel to segment from vertex vtx-1 to vtx
        p1x = tr_x(vtx-1); p1y = tr_y(vtx-1); % first point (also position vector)
        p2x = tr_x(vtx); p2y = tr_y(vtx); % second point
        v_seg = ([p2x,p2y]-[p1x,p1y])/norm([p2x,p2y]-[p1x,p1y]); % unit vector parallel to segment
        % from these, compute starting point for this iteration
        curStartingPoint = [p1x,p1y] + v_seg*excessLen;
        % remove vertices before the desired arc length
        tr_x_tmp = tr_x; tr_y_tmp = tr_y;
        tr_x_tmp(1:vtx-1) = []; tr_y_tmp(1:vtx-1) = [];
        % replace now-first vertex with desired starting point
        tr_x_tmp(1) = curStartingPoint(1);
        tr_y_tmp(1) = curStartingPoint(2);
        % Compute max curvature with this starting points
        obtainedCs(end+1) = max(curvatureOsc([tr_x_tmp,tr_y_tmp],1,curvatureSegmentLength_tmp,symThreshForCurvature_tmp,symTimeThreshForCurvature_tmp,roundToDecForCurvature_tmp));
    end
    maxCurvatures(curTraj,1) = max(obtainedCs);
    % End of multipass curvature computation -------------
    
end

a.rs(:,a.s.resCols.maxCurvature) = maxCurvatures;