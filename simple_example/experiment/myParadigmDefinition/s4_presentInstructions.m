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
%
%        ___Useful variables that exist at the outset of this file___
%
% e.s        struct. experiment settings
% winsOff    struct. offscreen windows (pointers: 'winsOff.myWindow.h')
% winOn      struct. onscreen window (pointer: 'winOn.h')
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Show welcome text and wait for button press.
ShowTextAndWait(...
    ['Welcome! This is a simple example experiment.', newline newline, ...
    'Press any key to show instructions.'], ...
    [0 0 0], winOn.h, 0.5, true);

% Show welcome text and wait for button press.
ShowTextAndWait(...
    ['—Instructions—', ...
    newline newline newline, ...
    '(1) Move cursor onto start marker and wait for stimuli.', ...    
    newline, newline, ...
    '(2) Click one of the dors. Red is the target. ', ...    
    newline, newline, ...
    'If you click elsewhere, the trial will be repeated at a later point.', ...
    newline newline, ...
    'There are two blocks with three trials each (plus repetitions).', ...    
    newline newline newline, 'Press any key to start.'], ...
    [0 0 0], winOn.h, 0.5, true);