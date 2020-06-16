%%%%%%%%%  Prepare graphics that change from trial to trial  %%%%%%%%%%%%%%
%
% Draw graphics that are trial-specific (i.e. stimuli) to the prepared
% offscreen windows. Use the window pointers stored in struct
% 'winsOff.myWindow.h'.
% The coordinate frame for drawing is the Psychtoolbox frame, units are
% pixels. Use functions 'vaToPx' and 'paVaToPtbPx' to convert from visual
% angle to that frame. See folder 'helperFuntions/unitConversion' for these
% functions' documentations and other conversion functions you may use.
%
% Access the current trial's parameters like this:
%
%                   currentTrial.whatEverYouAreLookingFor
%
% 
%            ___Variables that exist at the outset of this file___
%
% ... and which you'll likely need in this script file:
% 
% winsOff          struct. offscreen windows (pointers: 'winsOff.myWindow.h')
% currentTrial     table. Row of current trial from the trial list.
%                  Contains all properties of the current trial. Access
%                  trial info like this: 'currentTrial.someTrialProperty'.
% e.s              Experiment settings
%
% ... and which you probably won't need in this script file:
%
% sequNum          double. total number of trials presented so far,
%                  including current trial.
% rerunTrialLater  Boolean. Automatically set to false before each trial.
%                  Sets whether current trial will be repeated. See below.     
% out              struct. Empty, re-initialized before each trial. Add
%                  fields to write to results matrix (see below).                 
% triallist        table. List of all trials (rows are trials).
% curTrialNumber   double. Row number of the current trial in 'triallist'.                 
% winOn            struct. onscreen window (pointer: 'winOn.h')
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% First get stimulus info from the trial list for the current trial:
colors = currentTrial.colors;
horzPos = currentTrial.horzPos;

% Convert the coded colors from the trial list into RGB colors based on how
% we defined the colors during trial generation and put into a vector to
% pass to Psychtoolbox function later.
colors = cell2mat(e.s.stimColors(colors)')';

% We didn't specify vertical positions because these will always be zero
% in out example
vertPos = zeros(1, numel(horzPos));

% Convert item positions to Psychtoolbox frame and pixels
xy_ptb = convert.paVa2ptbPx(horzPos, vertPos);

% Convert item radius from °v.a. to pixels (is the same for all items)
r_px = convert.va2px(e.s.stimRadius);

% Draw the items via Psychtoolbox to stimulus offscreen window 
Screen('DrawDots', ...
    winsOff.stims.h, ...
    xy_ptb, ...
    r_px * 2, ...
    colors, ...
    [], 1);










