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
% - 'e.s.useTrialBlocks' is true (set as 't.s.useTrialBlocks' in trial
%   generation)
% - The block number of the current trial is different from that of the
%   previous trial (block number for each trial must be found in column
%   triallist.block; set in trial generation as 'triallist').
% - The current block number is specified in 'e.s.breakBeforeBlockNumbers'
%   (set in trial generation as 't.s.breakBeforeBlockNumbers').
%
% See Readme.md for further help.
%
%
%            ___Variables that exist at the outset of this file___
%
% Note that you probably won't need any of these in this script file.
% 
% currentTrial     table. Row of current trial from the trial list.
%                  Contains all properties of the current trial. Access
%                  trial info like this: 'currentTrial.someTrialProperty'.
% sequNum          double. total number of trials presented so far,
%                  including current trial.
% rerunTrialLater  Boolean. Automatically set to false before each trial.
%                  Sets whether current trial will be repeated. See below.     
% out              struct. Empty, re-initialized before each trial. Add
%                  fields to write to results matrix (see below).                 
% e.s              Experiment settings
% triallist        table. List of all trials (rows are trials).
% curTrialNumber   double. Row number of the current trial in 'triallist'.                 
% winsOff          struct. offscreen windows (pointers: 'winsOff.myWindow.h')
% winOn            struct. onscreen window (pointer: 'winOn.h')
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Show block break text and wait for button press
ShowTextAndWait(...
    'Block complete. Take a break. Press any key to continue.', ...
    [0 0 0], winOn.h, 0.5, true);

