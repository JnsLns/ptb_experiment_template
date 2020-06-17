%%%% Shuffle aborted trial into remaining triallist (within current block)

if rerunTrialLater         
    
    % make sure trial is placed only within current block (if blocks used).
    if e.s.useTrialBlocks
        % find last row in trial list that belongs to current block                
        lastBlockRow = find(triallist.block == currentTrial.block, 1, 'last');                        
    else
        lastBlockRow = size(triallist,1);
    end
  
    if curTrialNumber ~= size(triallist,1)
                
        % Do reordering on vector of row indices
        rowInds = 1:size(triallist,1);                        
        newPos = randi([curTrialNumber, lastBlockRow]);
        abortedRow = rowInds(curTrialNumber);
        rowInds(curTrialNumber) = [];
        upper = rowInds(1:newPos-1);
        lower = rowInds(newPos:end);
        rowInds = [upper, abortedRow, lower];
        
        % Apply to triallist
        triallist = triallist(rowInds, :);
        
    end        
    
    curTrialNumber = curTrialNumber - 1; % will be incremented again before next trial
    
end