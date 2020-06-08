% 
%  % USE THIS: 
% 
% newRow = struct2table(out, 'AsArray', true);
% 
% 
% % Find variables that are in new row but not in results yet
% newRowVars = newRow.Properties.VariableNames;
% resultVars = results.Properties.VariableNames;
% varsMissingInResults = ...
%     newRow.Properties.VariableNames(~ismember(newRowVars, resultVars));
% varsMissingInNewRow = ...
%     results.Properties.VariableNames(~ismember(resultVars, newRowVars));
% 
% % add new vars to result table, filling previous rows
% 
% % Three cases:
% % single number -> column will be column vector
% % row vector    -> table variable will contain a matrix
% % matrix        -> table column will be a cell array
% % anything else -> table column will be a cell array
% 
% % add new variable to existing results table. If object in new row is
% % numeric, the previous table rows will contain arrays of the same size
% % filled with nans; if it is non-numeric, previous rows will contain an
% % empty cell array.
% nResRows = size(results,1);
% for newVar = varsMissingInResults    
%     newVarName = newVar{1};
%     content = newRow.(newVarName);    
%     if isnumeric(content)
%         results.(newVarName) = nan(nResRows, size(content,2));
%     else
%         results.(newVarName) = cell(nResRows,0);
%     end    
% end
% 
% % add variables to new results row that are present in the results table
% % but not in the new row (i.e., output variables that have been used in
% % previous trials but not in the current one)
% for newVar = varsMissingInNewRow
%     newVarName = newVar{1};
%     content = results.(newVarName){end}
%     if isnumeric(content)
%         results.(newVarName) = nan(nResRows, size(content,2));
%     else
%         results.(newVarName) = cell(nResRows,0);
%     end        
% end
% % append row from this trial
% results(end+1,:) = newRow;


% What if out misses a previously existing field?
% What if out has a field that did not exist before?
% 	- Especially concerning table varibales that contain vectors or
% 	arrays...
% Does the order of variables in the inserted row matter (i.e., what
% happens when fields are added to out in different order in different
% trials)

%   first 




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% I AM HERE... THE ABOVE MUST BE CLEANED !!!! 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


 
%%%% Store results in e.results

% Find max col number in e.s.resCols and initialize new results row to 
% nan vector of that length.
usedColNums = [];
for fname = fieldnames(e.s.resCols)'
    usedColNums = [usedColNums, e.s.resCols.(fname{1})];
end
maxCol = max(usedColNums);
newResRow = nan(1,maxCol);

% in case there are new results columns since the last time, i.e., a new
% field was added to struct 'out', pad the preexisting results matrix
% with nans for these new columns (all rows).
colsNewRow  = size(newResRow,2); 
colsResults = size(e.results,2); 
if colsNewRow > colsResults
    e.results = [e.results, nan(size(e.results,1), colsNewRow-colsResults)];
end

% write from fields of struct 'out' to new results row
for fName = fieldnames(out)'
    f = fName{1};               
    newResRow(e.s.resCols.(f)) = out.(f);    
end

% write from current trial row to new results row
for fName = fieldnames(triallistCols)'
    f = fName{1};
    newResRow(e.s.resCols.(f)) = trials(curTrial, triallistCols.(f));   
end

% append row to results matrix
e.results(end+1, :) = newResRow;
