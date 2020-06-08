function tblOut = forceAppendTable(targetTbl, appendTbl)

% TODO
%
% Variables that exist in both input tables must have the same data type.

% add unshared variable to each of the two tables
targetTbl_extended = addUnsharedTableVars(targetTbl, appendTbl);
appendTbl_extended = addUnsharedTableVars(appendTbl, targetTbl);

% sort to-be-appended table to have same variable order as targetTbl
sortOrder = targetTbl_extended.Properties.VariableNames;
appendTbl_extended = rearrangeTableVars(appendTbl_extended, sortOrder);

% append to target 
tblOut = [targetTbl_extended; appendTbl_extended];

