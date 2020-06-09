% Present anything before the trials, such as instructions.
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
% (in private dir) to show centered text and wait for a button press.

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