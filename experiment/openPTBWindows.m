%%%% Open PTB windows 

% note: if certain images (e.g. fixation) are repeatedly used in your
% experiment, make a separate offscreen window for each of them. This way
% you need to draw that image once and afterwards only need to copy the
% offscreen window to the onscreen window when the image is needed.
%
% The onscreen window handle is stored in struct winOn.h, as well as the
% window's other properties, e.g., winOn.rect. Offscreen window handles are
% stored as winsOff.windowname.h, and window properties in other fields,
% such as winsOff.windowname.rect. Additional offscreen windows should be
% stored accordingly, e.g., winsOff.windowname2.h (etc.).
%
% Note that some functionality requires the window handles to be stored the
% way it is done here (in a struct), such as closing and reopening all
% windows when the experiment is paused/resumed.

% onscreen window for actual display
winOn.bgColor = e.s.bgColor;
winOn.screen = expScreen;
winOn.rect = [0 0 e.s.expScreenSize_px];
[winOn.center(1), winOn.center(2)] = RectCenter(winOn.rect);
winOn.font = e.s.instructionTextFont;
winOn.fontSize = round(vaToPx(e.s.instructionTextHeight_va, e.s.spatialConfig));
[winOn.h, winOn.rect] = ...
    PsychImaging('openWindow', winOn.screen, winOn.bgColor, winOn.rect);
Screen('TextFont', winOn.h, winOn.font);
Screen('TextSize', winOn.h, winOn.fontSize); 

% offscreen window to draw stimuli to
winsOff.stims.bgColor = e.s.bgColor;
winsOff.stims.screen = expScreen;
winsOff.stims.rect = winOn.rect;
[winsOff.stims.center(1), winsOff.stims.center(2)] = ...
    RectCenter(winsOff.stims.rect);
[winsOff.stims.h, winsOff.stims.rect] = ...
    Screen('OpenOffScreenWindow', winsOff.stims.screen, ...
    winsOff.stims.bgColor, winsOff.stims.rect);

% empty offscreen window
winsOff.empty.bgColor = e.s.bgColor;
winsOff.empty.screen = expScreen;
winsOff.empty.rect = winOn.rect;
[winsOff.empty.center(1), winsOff.empty.center(2)] = ...
    RectCenter(winsOff.empty.rect);
[winsOff.empty.h, winsOff.empty.rect] = ...
    Screen('OpenOffScreenWindow', winsOff.empty.screen, ...
    winsOff.empty.bgColor, winsOff.empty.rect);

% offscreen window for fixation cross
winsOff.fix.bgColor = e.s.bgColor;
winsOff.fix.screen = expScreen;
winsOff.fix.rect = winOn.rect;
[winsOff.fix.center(1), winsOff.fix.center(2)] = ...
    RectCenter(winsOff.fix.rect);
[winsOff.fix.h, winsOff.fix.rect] = ...
    Screen('OpenOffScreenWindow', winsOff.fix.screen, ...
    winsOff.fix.bgColor, winsOff.fix.rect);

% offscreen window for target presence response
winsOff.targetResponse.bgColor = e.s.bgColor;
winsOff.targetResponse.screen = expScreen;
winsOff.targetResponse.rect = winOn.rect;
[winsOff.targetResponse.center(1), winsOff.targetResponse.center(2)] = ...
    RectCenter(winsOff.targetResponse.rect);
[winsOff.targetResponse.h, winsOff.targetResponse.rect] = ...
    Screen('OpenOffScreenWindow', winsOff.targetResponse.screen, ...
    winsOff.targetResponse.bgColor, winsOff.targetResponse.rect);