
% extend e.s.resCols with column numbers for fields in struct 'out' (which
% stores things from the trial that will go into 'e.results')
updateResCols;    

% store contents of fields of 'out' in the correspondingly named columns
% of e.results.
storeResults;     

% if current trial was aborted (i.e., not completed due to some misbehavior
% of the participant), shuffle it into the remaining trial list to be
% redone later at a random time point.
insertAbortedTrial; 

if doSave
    save(savePath, 'e');
end

% set break code to be run before next trial if next trial is in new block.
doBlockBreak = false;
if e.s.useTrialBlocks && ...
   e.s.breakBetweenBlocks && ...
   curTrial ~= size(trials,1) && ...
   rerunTrialLater ~= 1 && ...
   trials(curTrial, triallistCols.block) ~= trials(curTrial+1, triallistCols.block)                        
    blockNums = trials(:, triallistCols.block);    
    doBlockBreak = true; 
end   

% go to next trial...
curTrial = curTrial + 1;

