
% Store custom data that can't be stored in results matrix ('e.results'),
% that is, anything that is not a scalar or a vector with a fixed number of
% elements.
%
% The first step should be to record the desired data in one or more
% arbitrary variables during the trial (i.e., within runTrial.m).
%
% Here a field in struct 'e' should be added for each of these variables 
% (on the first trial only, of course). Each of these fields should
% initially hold an empty one-dimensional array (typically a cell array).
% For instance:
%
% if ~isfield(e,'desiredFieldName')
%    e.desiredFieldName = cell(0);  
% end
%
% The array should be extended by one element each trial and the data 
% stored in that element. For instance:
%
% e.desiredFieldName{end+1} = myArbitraryDataVariable;
%
% The goal is for the order of the array's elements to correspond to the
% order of rows in 'e.results', so that you later know which element
% belongs to which results row. This is automatically the case if one
% element is added to the array in each trial - even if the respective data
% was not recorded during the trial for some reason; so simply make sure
% your variable is initialized to, say, nan or [] at the start of
% 'runTrial.m'.
%
% I further suggest to define an index-struct (in the vein of e.s.resCols)
% for each type of custom data. Do this in the experiment settings at the
% outset of 'main.m' and add it as a field of 'e.s'. It will enable indexing
% columns and/or rows of the custom data arrays by name during analysis.


%%%% Store trajectory 

% On the first run, initialize field 'trajectories' in 'e' to empty cell.
if ~isfield(e,'trajectories')
    e.trajectories = cell(0);
end

% some postprocessing: of any directly successive rows in trajectory that
% have identical position data, remove all but the first row. 
if size(trajectory,1) > 0
    rem = trajectory(:, [e.s.trajCols.x, e.s.trajCols.y]);
    rem = [ones(1, size(rem,2)); diff(rem,1,1)];
    rem = all(rem' == 0);
    trajectory(rem, :) = [];
end

% store in trajectory array
e.trajectories{end+1} = trajectory;
