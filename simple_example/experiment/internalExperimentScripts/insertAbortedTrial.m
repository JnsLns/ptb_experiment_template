%%%% Shuffle aborted trial into remaining triallist (within current block)

if rerunTrialLater         
    
    % make sure trial is placed only within current block (if blocks used).
    if e.s.useTrialBlocks
        % find last row in trial list that belongs to current block                
        currentBlock = trials.block(curTrial);        
        lastBlockRow = find(trials.block == currentBlock, 1, 'last');                        
    else
        lastBlockRow = size(trials,1);
    end
  
    if curTrial ~= size(trials,1)
                
        % Do reordering on vector of row indices
        rowInds = 1:size(trials,1);                        
        newPos = randi([curTrial, lastBlockRow]);
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