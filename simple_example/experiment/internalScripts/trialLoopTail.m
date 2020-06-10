

% store contents of fields of 'out' in the correspondingly named variables
% of e.results.
storeResults;     

% if current trial was aborted (i.e., not completed due to some misbehavior
% of the participant), shuffle it into the remaining trial list to be
% redone later at a random time point.
insertAbortedTrial; 

if doSave
    save(savePath, 'e');
end

% go to next trial...
curTrialNumber = curTrialNumber + 1;

