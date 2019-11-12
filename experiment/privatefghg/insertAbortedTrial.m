%%%% Shuffle aborted trial into remaining triallist

if out.abortCode
    
    if curTrial ~= size(trials,1)
        
        % Do reordering on vector of row indices
        rowInds = 1:size(trials,1);
        newPos = randi([curTrial, numel(rowInds)]);
        abortedRow = rowInds(curTrial);
        rowInds(curTrial) = [];
        upper = rowInds(1:newPos-1);
        lower = rowInds(newPos:end);
        rowInds = [upper, abortedRow, lower];
        
        % Apply to trials
        trials = trials(rowInds, :);
        
    end
    
    curTrial = curTrial - 1; % will be incremented again at trial outset.
    
end