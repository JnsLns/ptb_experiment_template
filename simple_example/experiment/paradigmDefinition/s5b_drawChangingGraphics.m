% Draw graphics that are trial-specific to offscreen windows.
% Use the window pointers stored in struct 'winsOff.myWindow.h'.
% The coordinate frame for drawing is of course the Psychtoolbox frame,
% units are pixels. Use functions 'vaToPx' and 'paVaToPtbPx' to convert
% from visual angle to that frame. See folder 'common_functions' for these
% functions documentations and other conversion functions you may use.
%
% Whatever you draw here will probably based on what is defined in the
% trial list for the current trial. Access the current trial's parameters
% from the trial list like this:
%
%      trials(curTrial, triallistCols.whateverYouAreLookingFor)


% First get stimulus info from the trial list for the current trial:
colors = trials(curTrial, triallistCols.color);
horzPos = trials(curTrial, triallistCols.horzPos);

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
    e.s.startMarkerColor, ...
    [], 1);










