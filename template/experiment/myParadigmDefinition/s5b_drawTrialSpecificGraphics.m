%%%%%%%%%  Prepare graphics that change from trial to trial  %%%%%%%%%%%%%%
%
% Draw graphics that are trial-specific (i.e. stimuli) to the prepared
% offscreen windows. Use the window pointers stored in struct
% 'winsOff.myWindow.h'. Access the current trial's parameters like this:
%
% currentTrial.whatEverYouAreLookingFor
%
% The coordinate frame for drawing is the Psychtoolbox frame, units are
% pixels. Use the methods provided by the object in variable 'convert'
% to convert to that frame for drawing (e.g., 'convert.paVa2PtbPx'). Here's 
% a list of available conversion methods (see Readme.md for more help):
%
% px2mm, va2mm, mm2px, va2px, mm2va, px2va, paMm2ptbPx, paVa2ptbPx,
% ptbPx2paMm, ptbPx2paVa, scrMm2paMm, scrMm2ptbPx.
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
% convert          object of CoordinateConverter class. Use to convert
%                  between units and reference frames. (see Readme.md)   
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

% Convert item diameter from °v.a. to pixels (is the same for all items)
d_px = convert.va2px(e.s.stimRadius * 2);

% Draw the items via Psychtoolbox to stimulus offscreen window 
Screen('DrawDots', ...
    winsOff.stims.h, ...
    xy_ptb, ...
    d_px, ...
    colors, ...
    [], 3);










