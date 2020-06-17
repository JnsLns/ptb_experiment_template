% Use for debugging. Essentially sets a break point at the position where 
% the script is included but additionally closes any PTB windows and shows
% the call stack. Resume code execution as usual when done debugging. All
% PTB windows will be restored (and static graphics re-drawn), and the
% experiment will resume.

Screen('CloseAll');
dbstack;
keyboard;
restorePsychWindows;