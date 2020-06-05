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

% set blockBreak.m to be run before the current trial if block breaks are
% enabled and next trial is in new block. Note: rerunTrialLater==1 means
% that the last trial was set to be repeated so that there is at least one
% trial left in current block.
doBlockBreak = false;
if (~exist('rerunTrialLater', 'var') || ~rerunTrialLater) && ...
    e.s.useTrialBlocks    
    % in case it's not trial 1, check whether block number just changed
    if curTrial ~= 1
        blockNumChanged = trials.block(curTrial) ~= trials.block(curTrial-1);                    
    else
        blockNumChanged = 1;
    end
    % in case block number changed, check whether break desired for this block
    if blockNumChanged && ...
            any(trials.block(curTrial) == e.s.breakBeforeBlockNumbers)                               
        doBlockBreak = true;
    end
end

% By default, set trial to not be repeated
rerunTrialLater = false;