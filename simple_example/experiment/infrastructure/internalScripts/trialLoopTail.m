

% store contents of fields of 'out' in the correspondingly named variables
% of e.results.
storeResults;     

% if current trial was aborted (i.e., not completed due to some misbehavior
% of the participant), shuffle it into the remaining trial list to be
% redone later at a random time point.
insertAbortedTrial; 

if doSave    
    % Save temporary incomplete file that may be used to resume experiment
    % in case it is aborted or crashes (final file is saved only at the end)
    resumeAtTrialNumber = curTrialNumber + 1;  
    [p,f,ext] = fileparts(savePath);
    savePathIncomplete = fullfile(p,['INCOMPLETE_', f, ext]);        
    save(savePathIncomplete, 'e', 'resumeAtTrialNumber', 'triallist');
end

% go to next trial...
curTrialNumber = curTrialNumber + 1;

