function rearrTbl = rearrangeTableVars(tbl, newOrder)
% function sortedTbl = rearrangeTableVars(tbl, newOrder)
%
% Rearrange order of variables in a table. Can be used for sorting
% variables alphabetically (default when not passing 'newOrder').
%
%                               ___Input___
%
% tbl        Table whose variables are to be rearranged
%
% newOrder   Optional. Default is alphabetic sorting. Cell array of strings
%            giving the desired variable order. Must contain all variable
%            names in tbl.
%
%                               ___Output___
%
% rearrTbl   Table with rearranged variable order.


% if no list of variable names supplied, sort alphabetically 
if nargin < 2 
    newOrder = sort(tbl.Properties.VariableNames);
% if newOrder cupplied, check whether all variable names are present
else
    if ~all(ismember(tbl.Properties.VariableNames, newOrder))
        error('''newOrder'' must contain all variable names of ''tbl''.')
    end
end

% rearrange
for curPos = 1:numel(newOrder)           
    tbl = movevars(tbl, newOrder(curPos), 'before', curPos);    
end

rearrTbl = tbl;