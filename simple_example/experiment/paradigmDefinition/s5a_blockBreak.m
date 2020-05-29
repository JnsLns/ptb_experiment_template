% Code to be executed before each trial block, e.g. to implement breaks.
%
% For instance, use the custom convenience function ShowTextAndWait
% (in private dir) to show centered text and wait for a button press.
% Or draw directly to the onscreen window. The window pointer for the
% onscreen window is 'winOn.h'. Draw directly to it and/or copy some
% offscreen window to it:
%
% Screen('CopyWindow', winsOff.someWindow.h, winOn.h);
%
% Present its contents using:
% Screen('Flip', winOn.h, []) 
%
% Note that the code in this file is executed only if the following
% conditions are met:
%
% -- 'e.s.useTrialBlocks' is true (set as 'tg.s.useTrialBlocks' in trial
%    generation)
% -- The block number of the current trial is different from that of the
%    previous trial (block number for each trial must be found in 
%    column 'triallistCols.block' of 'trials'; set in trial generation as
%    'tg.s.triallistCols.block' and 'triallist').
% -- The current block number is specified in 'e.s.breakBeforeBlockNumbers'
%    (set in trial generation as 'tg.s.breakBeforeBlockNumbers').

          

