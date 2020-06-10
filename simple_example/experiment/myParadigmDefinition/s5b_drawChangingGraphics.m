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
vertPos = zeros(1, numel(horzPos));

% Convert item positions to Psychtoolbox frame and pixels (can be done for
% all items at once)
[x_ptb, y_ptb] = paVaToPtbPx(horzPos, vertPos, e.s.spatialConfig);

% Convert item radius from °v.a. to pixels (is the same for all items)
r_px = vaToPx(e.s.stimRadius, e.s.spatialConfig);

% Draw the items via Psychtoolbox to stimulus offscreen window 
Screen('DrawDots', ...
    winsOff.stims.h, ...
    [x_ptb; y_ptb], ...
    r_px * 2, ...
    colors, ...
    [], 1);










