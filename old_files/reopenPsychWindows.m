% (Re-) open all windows used in the experiment after it is resumed
% following a pause.

[win, winRect] = PsychImaging('openWindow', expScreen, bgColor);
Screen('TextFont', win, 'Arial');
Screen('TextSize', win, 25);
[offwinStart, offwinStartRect]  = Screen('OpenOffScreenWindow', expScreen, ...
    bgColor, [0 0 offwinStartWidth offwinStartHeight]);
[offwinStart_on]  = Screen('OpenOffScreenWindow', expScreen, ...
    bgColor, [0 0 offwinStartWidth offwinStartHeight]);
[offwinStims, offwinStimsRect]  = Screen('OpenOffScreenWindow', expScreen, ...
    bgColor, [0 0 offwinStimsWidth offwinStimsHeight]);

HideCursor;