function [extendedTbl, addedVars] = addUnsharedTableVars(extendTbl, sourceTbl)
% function [extendedTbl, addedVars] = addUnsharedTableVars(extendTbl, sourceTbl)
%
% Add variables to 'extendTbl' such that it shares all variables of
% 'sourceTbl'. What is used to fill the new rows depends on what the last
% row of the respective variable in 'sourceTbl' contains: If numeric or
% logical, arrays of the same size (possibly [1 1]) are used that are
% filled with NaN (this means that logical arrays are replaced by double
% arrays, to allow using NaN!); in the case of other data types, empty cell
% arrays are used (same number of columns as in 'sourceTbl'). 
%
%
%                           ___Inputs___
%
% extendTbl    Table to add variables to.
%
% sourceTbl    Table to provide the full set of desired variables.
%
%
%                          ___Outputs___
%
% extendedTbl  Table extended with new variables.
%
% addedVars    Cell array of the variables names that have been added
%              (i.e., variables that are in 'sourceTbl' but not in
%              'extendTbl')

% Find variables that are in sourceTbl but not in extendTbl
sourceTblVars = sourceTbl.Properties.VariableNames;
extendTblVars = extendTbl.Properties.VariableNames;
addedVars = ...
    sourceTbl.Properties.VariableNames(~ismember(sourceTblVars, extendTblVars));

% add new variable to extenTbl and fill existing rows.
nExtRows = size(extendTbl,1);
for newVar = addedVars
    newVarName = newVar{1};
    content = sourceTbl.(newVarName)(end,:);    
    if islogical(content) || isnumeric(content)
        extendTbl.(newVarName) = nan(nExtRows, size(content,2));    
    else        
        extendTbl.(newVarName) = cell(nExtRows, size(content,2));
    end    
end

extendedTbl = extendTbl;


