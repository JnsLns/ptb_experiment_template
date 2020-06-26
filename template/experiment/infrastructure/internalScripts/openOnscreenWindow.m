% Open onscreen PTB window.

% Everything ever presented is either copied to this window from offscreen
% windows (such as stimuli) or directly drawn to this window (little things
% that must be frequently updated in loops, such as mouse pointer position).

% The onscreen window handle is stored in struct 'winOn.h'. The other
% window properties are stored in the other field of 'winOn', e.g.,
% 'winOn.rect'.

% Create fields in 'e.s' holding onscreen window properties in case they
% weren't defined in trials file; use default values.
if ~isfield(e.s, 'onscreenWindowTextFont')
    e.s.onscreenWindowTextFont = 'Arial'; 
end
if ~isfield(e.s, 'onscreenWindowTextHeight_va')
    e.s.onscreenWindowTextHeight_va = 0.75;
end
                                                                                   
% open onscreen window 
winOn.bgColor = e.s.bgColor;
winOn.screen = useScreenNumber;
winOn.rect = [0 0 e.s.expScreenSize_px];
[winOn.center(1), winOn.center(2)] = RectCenter(winOn.rect);
winOn.font = e.s.onscreenWindowTextFont;
winOn.fontSize = convert.va2px(e.s.onscreenWindowTextHeight_va);
[winOn.h, winOn.rect] = ...
    PsychImaging('openWindow', winOn.screen, winOn.bgColor, winOn.rect, ...
    [], [], [], e.s.multisampling);
Screen('TextFont', winOn.h, winOn.font);
Screen('TextSize', winOn.h, winOn.fontSize); 

%%% Hide mouse cursor
HideCursor;