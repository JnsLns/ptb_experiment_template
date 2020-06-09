function tblOut = forceAppendTable(targetTbl, appendTbl)
% function tblOut = forceAppendTable(targetTbl, appendTbl)
%
% Append table to another table (along the first dimension) even if the two
% tables do not share all or any variables. Any unshared variables will be
% padded with nans (if data in source table is numeric) or with empty cell
% arrays (if data in source table is non-numeric). Variable order in the
% output table is the same as in 'targetTbl' with any additional variables
% coming from 'appendTbl' added at the end, in the order they appear in 
% 'appendTbl'. Note that data in variables shared by the input tables must
% be eligible for table concatenation as usual. Tested only with numeric
% array and cell arrays.
%
%                           ___Inputs___
%
% targetTbl     Table to which the other table will be appended.
%
% appendTbl     Table that will be appended to the other table.
%
%
%                          ___Outputs___
%
% tblOut        Source tables merged into one.



% add unshared variable to each of the two tables
targetTbl_extended = addUnsharedTableVars(targetTbl, appendTbl);
appendTbl_extended = addUnsharedTableVars(appendTbl, targetTbl);

% sort to-be-appended table to have same variable order as targetTbl
sortOrder = targetTbl_extended.Properties.VariableNames;
appendTbl_extended = rearrangeTableVars(appendTbl_extended, sortOrder);

% existing logical arrays in unshared variables need to be converted to
% double arrays because addUnsharedTableVars uses NaN-filled (=double)
% arrays and concatenation requires same data type.
targetTbl.Properties.Variables
appendTbl.Properties.Variables

% append to target 
tblOut = [targetTbl_extended; appendTbl_extended];

