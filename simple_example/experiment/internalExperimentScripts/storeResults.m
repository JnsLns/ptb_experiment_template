
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
