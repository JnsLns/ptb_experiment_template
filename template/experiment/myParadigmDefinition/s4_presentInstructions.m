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
    ['Welcome! This is a simple example experiment.', char(10) char(10), ...
    'Press any key to show instructions.'], ...
    [0 0 0], winOn.h, 0.5, true);

% Show welcome text and wait for button press.
ShowTextAndWait(...
    ['—Instructions—', ...
    char(10) char(10) char(10), ...
    '(1) Move cursor onto start marker and wait for stimuli.', ...    
    char(10), char(10), ...
    '(2) Click one of the dors. Red is the target. ', ...    
    char(10), char(10), ...
    'If you click elsewhere, the trial will be repeated at a later point.', ...
    char(10) char(10), ...
    'There are two blocks with three trials each (plus repetitions).', ...    
    char(10) char(10) char(10), 'Press any key to start.'], ...
    [0 0 0], winOn.h, 0.5, true);