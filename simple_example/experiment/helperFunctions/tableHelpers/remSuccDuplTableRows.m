function tblOut = remSuccDuplTableRows(tbl, varNames)
% function tblOut = remSuccDuplTableRows(tbl, varNames)
%
% Remove rows from table that are directly successive and identical with
% respect to a given set of table variables. Only the first of these rows
% is retained. Variable types 
%
%                               ___Input___
%
% tbl           The table.
%
% varNames      Optional, default is to use all variables. Cell array of
%               variable name strings of those variables to consider when
%               comparing rows.
%
%
%                              ___Output___
%
% tblOut        Table with duplicate rows removed.

% Consider all variables by default.
if nargin < 2
    varNames = tbl.Properties.VariableNames;
end

% Remove rows
if size(tbl,1) > 0
    rem = tbl{:, varNames};            
    rem = [ones(1, size(rem,2)); diff(rem,1,1)];
    rem = all(rem' == 0);
    tbl(rem, :) = [];
end

tblOut = tbl;

