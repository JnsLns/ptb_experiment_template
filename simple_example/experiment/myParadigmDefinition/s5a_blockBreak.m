%%%%%%%%%%%%%%%%  Code executed before each trial block  %%%%%%%%%%%%%%%%%%
%
% The code in this file will be executed before each trial block, (except
% the first one by default. Can be used, for instance, to implement breaks.
%
%
% For instance, use the custom convenience function ShowTextAndWait
% (in private dir) to show centered text and wait for a button press.
% Or draw directly to the onscreen window. The window pointer for the
% onscreen window is 'winOn.h'. Draw directly to it and/or copy some
% offscreen window to it:
%
% Screen('CopyWindow', winsOff.someWindow.h, winOn.h);
% Screen('Flip', winOn.h); % present what was drawn
%
%
% The code in this file is executed if the following conditions are met:
%
% - 'e.s.useTrialBlocks' is true (set as 'tg.s.useTrialBlocks' in trial
%   generation)
% - The block number of the current trial is different from that of the
%   previous trial (block number for each trial must be found in column
%   triallist.block; set in trial generation as 'triallist').
% - The current block number is specified in 'e.s.breakBeforeBlockNumbers'
%   (set in trial generation as 'tg.s.breakBeforeBlockNumbers').
%
% See Readme.md for further help.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Show block break text and wait for button press
ShowTextAndWait(...
    'Block complete. Take a break. Press any key to continue.', ...
    [0 0 0], winOn.h, 0.5, true);

