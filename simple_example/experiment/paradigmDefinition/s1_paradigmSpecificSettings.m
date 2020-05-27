%%% Settings specific to the implemented paradigm.

% Add any settings specific to your paradigm here (but only those that are
% not better defined and fixed already when trials are created). Any 
% settings that you may need later for data analysis should be put into
% a field of struct 'e.s', as the entire struct 'e' will be saved to the
% results file.

% Column numbers for trajectory matrices.
%
% Note: In the case of multiple successive data points with identical
% positions, only the first one is recorded.
e.s.trajCols.x = 1; % pointer coordinates
e.s.trajCols.y = 2;
e.s.trajCols.t = 3; % pc time