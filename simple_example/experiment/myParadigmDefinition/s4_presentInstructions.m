%%%%%%%%%%%%%%%%%%  Present anything before the trials  %%%%%%%%%%%%%%%%%%%
%
% This is the place to show stuff to participants before the experiment
% starts, such as instructional text.
%
% The window pointer for the onscreen window is 'winOn.h'. You can draw
% directly to it and/or copy some offscreen window to it, like this:
%
% Screen('CopyWindow', winsOff.someWindow.h, winOn.h);
% Screen('Flip', winOn.h); % present what was drawn
%
% Note: You can also use the custom convenience function ShowTextAndWait
% (in folder 'helperFunctions/miscellaneous') to show centered text and
% wait for a button press before proceeding.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Show welcome text and wait for button press.
ShowTextAndWait(...
    'Bereit. Zum Starten des Experiments beliebige Taste drücken!', ...
    [0 0 0], winOn.h, 0.5, true);

% Show welcome text and wait for button press.
ShowTextAndWait(...
    ['—Instructions—', newline newline ...
    newline newline newline, 'bliblablu blabla.', ...    
    newline newline newline newline, 'Taste drücken zum Starten.'], ...
    [0 0 0], winOn.h, 0.5, true);