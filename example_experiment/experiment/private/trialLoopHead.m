% Clear offscreen windows where desired
for osw = fieldnames(winsOff)'
    osw = osw{1};
    if winsOff.(osw).clearEachTrial
        Screen('FillRect', winsOff.(osw).h, winsOff.(osw).bgColor);
    end
end

% Empty the struct that will record results data
out = struct();

% Set trial to not be repeated by default.
rerunTrialLater = false;

% increment sequential number for results row (ordinal positition within
% list of presented trials)
sequNum = sequNum + 1;

% Check whether pause key is being pressed, if so, halt execution and
% close PTB windows. Reopen if resumed.
pauseAndResume;