function tblOut = forceAppendTable(targetTbl, sourceTbl)
% function tblOut = forceAppendTable(targetTbl, sourceTbl)
%
% Append table to another table (along the first dimension) even if the two
% tables do not share all or any variables. Any unshared variables will be
% padded with nans (if data in source table is numeric or logical) or with
% empty cell arrays (for other data types). Note that logical arrays in
% initially unshared variables are converted to double arrays, to allow the
% use of nan. 
% Variable order in the output table is the same as in 'targetTbl' with any
% additional variables coming from 'sourceTbl' added at the end, in the
% order they appear in 'sourceTbl'. Note that data in variables shared by
% the input tables must be eligible for table concatenation as usual.
% Tested only with numeric arrays, logical arrays, and cell arrays as table
% content.
%
%                           ___Inputs___
%
% targetTbl     Table to which the other table will be appended.
%
% sourceTbl     Table that will be appended to the other table.
%
%
%                          ___Outputs___
%
% tblOut        Resulting table



% add unshared variable to each of the two tables
[targetTbl_extended, addedToTarget] = addUnsharedTableVars(targetTbl, sourceTbl);
[sourceTbl_extended, addedToSource] = addUnsharedTableVars(sourceTbl, targetTbl);

% sort to-be-appended table to have same variable order as targetTbl
sortOrder = targetTbl_extended.Properties.VariableNames;
sourceTbl_extended = rearrangeTableVars(sourceTbl_extended, sortOrder);

% existing logical arrays in unshared variables need to be converted to
% double arrays because addUnsharedTableVars uses NaN-filled (=double)
% arrays and concatenation requires same data type.
for v = addedToTarget
    if islogical(sourceTbl.(v{1}))
        sourceTbl.(v{1}) = double(sourceTbl.(v{1}));
    end
end
for v = addedToSource
    if islogical(targetTbl.(v{1}))
        targetTbl.(v{1}) = double(targetTbl.(v{1}));
    end
end

% append source to target 
tblOut = [targetTbl_extended; sourceTbl_extended];

