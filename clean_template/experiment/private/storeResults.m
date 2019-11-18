
%%%% Store results in e.results

% Initialize the new results row to nans
maxCol = max(structfun(@(x) x, e.s.resCols)); % max col in e.s.resCols
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
    if numel(out.(f)) > 1
        newResRow(e.s.resCols.([f, 'Start']):e.s.resCols.([f, 'End'])) = ...
            out.(f);
    else
        newResRow(e.s.resCols.(f)) = out.(f);
    end

end

% write from current trial row to new results row
for fName = fieldnames(triallistCols)'

    f = fName{1};
    if endsWith(f,'End')
        continue;
    elseif endsWith(f,'Start')
        f = f(1:end-5);
        newResRow(e.s.resCols.([f, 'Start']):e.s.resCols.([f, 'End'])) = ...
            trials(curTrial, triallistCols.([f, 'Start']):triallistCols.([f, 'End']));
    else
        newResRow(e.s.resCols.(f)) = trials(curTrial, triallistCols.(f));
    end

end

% append row to results matrix
e.results(end+1, :) = newResRow;
