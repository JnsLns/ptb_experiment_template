%%%% Store trajectory 

% note that for aborted trials, this will results in an empty matrix

% remove unfilled rows
trajectory(all(isnan(trajectory)'), :) = [];

% of any directly successive rows in trajectory that have identical
% position data, remove all but the first ones (if desired).
if e.s.dontRecordConstantTrajData    
    rem = trajectory(:, [e.s.trajCols.x, e.s.trajCols.y, e.s.trajCols.z]);
    rem = [ones(1, size(rem,2)); diff(rem,1,1)];
    rem = all(rem' == 0);
    trajectory(rem, :) = [];       
end

% store in trajectory array
e.trajectories{end+1} = trajectory;