%%%%%  Present anything after the trials, such as a goodbye message.  %%%%%
%
% The window pointer for the onscreen window is 'winOn.h'.
%
% Draw directly to it and/or copy some offscreen window to it:
% Screen('CopyWindow', winsOff.someWindow.h, winOn.h);
%
% Present its contents using:
% Screen('Flip', winOn.h, []) 
%
% Note: You can also use the custom convenience function ShowTextAndWait
% (in 'helperFuns/miscellaneous') to show centered text and wait for a
% button press.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Show goodbye message and wait for button press
ShowTextAndWait(...
    'Experiment complete. Thank you for your participation!', ...
    [0 0 0], winOn.h, 0.5, true);