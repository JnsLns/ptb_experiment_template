% Add code to be executed before each trial block, e.g. to implement breaks.
%
% Only comes to effect if e.s.useTrialBlocks and e.s.breakBetweenBlocks
% are both true (to achieve this set the corresponding values during trial
% generation; see documentation there). A new block is detected as a change
% of numbers in column 'triallistCols.block' of 'trials'.
%
%
% For instance, use the custom convenience function ShowTextAndWait
% (in private dir) to show centered text and wait for a button press.
%
% Or draw directly to the onscreen window. The window pointer for the
% onscreen window is 'winOn.h'. Draw directly to it and/or copy some
% offscreen window to it:
%
% Screen('CopyWindow', winsOff.someWindow.h, winOn.h);
%
% Present its contents using:
% Screen('Flip', winOn.h, []) 
%
%
% Code within this if-statement is executed before each block, except for
% the very first block:

if exist('doBlockBreak','var') && doBlockBreak  % ** DO NOT MODIFY LINE**
    
    % ADD YOUR CODE HERE

end                                             % ** DO NOT MODIFY LINE**