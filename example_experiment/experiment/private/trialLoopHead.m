% Clear offscreen windows where desired
for osw = fieldnames(winsOff)'
    osw = osw{1};
    if winsOff.(osw).clearEachTrial
        Screen('FillRect', winsOff.(osw).h, winsOff.(osw).bgColor);
    end
end

% Empty the struct that will record results data
out = struct();

% increment sequential number for results row (ordinal positition within
% list of presented trials)
sequNum = sequNum + 1;

% Check whether pause key is being pressed, if so, halt execution and
% close PTB windows. Reopen if resumed.
pauseAndResume;

% initialize rerunTrialLater
if ~exist('rerunTrialLater', 'var')
    rerunTrialLater = false;
end

% ensure that blockBreak.m will be run before next trial if breaks enabled
% and next trial is in new block.
doBlockBreak = false;
% note that the value of rerunTrialLater is still that set during the last
% trial, so if true it means that a trial from the last block is repeated
% so that there is at least one trial left in current block.
if ~rerunTrialLater && e.s.useTrialBlocks    
    % in case it's not trial 1, check whether block just changed
    if curTrial ~= 1
        blockNumChanged = ...
            trials(curTrial, triallistCols.block) ~= ...
            trials(curTrial-1, triallistCols.block);
    else
        blockNumChanged = 1;
    end
    % in case block number changed, check whether break desired for this block
    if blockNumChanged && ...
            any(trials(curTrial, triallistCols.block) == e.s.breakBeforeBlocks)
        doBlockBreak = true;
    end
end

% Set trial to not be repeated by default.
rerunTrialLater = false;