% Open onscreen PTB window.

% Everything ever presented is either copied to this window from offscreen
% windows (such as stimuli) or directly drawn to this window (little things
% that must be frequently updated in loops, such as mouse pointer position).

% The onscreen window handle is stored in struct 'winOn.h'. The other
% window properties are stored in the other field of 'winOn', e.g.,
% 'winOn.rect'.

% onscreen window for actual display
winOn.bgColor = e.s.bgColor;
winOn.screen = expScreen;
winOn.rect = [0 0 e.s.expScreenSize_px];
[winOn.center(1), winOn.center(2)] = RectCenter(winOn.rect);
winOn.font = e.s.instructionTextFont;
winOn.fontSize = round(vaToPx(e.s.instructionTextHeight_va, e.s.spatialConfig));
[winOn.h, winOn.rect] = ...
    PsychImaging('openWindow', winOn.screen, winOn.bgColor, winOn.rect, ...
    [], [], [], e.s.multisampling);
Screen('TextFont', winOn.h, winOn.font);
Screen('TextSize', winOn.h, winOn.fontSize); 