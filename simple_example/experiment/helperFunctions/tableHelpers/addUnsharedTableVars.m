function extendTblOut = addUnsharedTableVars(extendTbl, compareTbl)
% function tblOut = addUnsharedTableVars(extendTbl, compareTbl)
%
% Compare variable set of two tables. Add variables that exist in
% 'comapreTbl' but not in 'extendTbl' to 'extendTbl' and fill the rows of
% these new variables with objects. What is used for filling depends on
% what the last row of the respective variable in 'compareTbl' contains:
% If numeric, arrays of the same size (possibly [1 1]) are used that are
% filled with nans; if it is non-numeric, empty cell arrays are used.

% Find variables that are in compareTbl but not in extendTbl
compareTblVars = compareTbl.Properties.VariableNames;
extendTblVars = extendTbl.Properties.VariableNames;
varsMissingInExtendTbl = ...
    compareTbl.Properties.VariableNames(~ismember(compareTblVars, extendTblVars));

% add new variable to extenTbl and fill existing rows.
nExtRows = size(extendTbl,1);
for newVar = varsMissingInExtendTbl
    newVarName = newVar{1};
    content = compareTbl.(newVarName)(end,:);    
    if isnumeric(content)
        extendTbl.(newVarName) = nan(nExtRows, size(content,2));
    else        
        extendTbl.(newVarName) = cell(nExtRows, size(content,2));
    end    
end

extendTblOut = extendTbl;


