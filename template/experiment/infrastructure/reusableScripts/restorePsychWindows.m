% Restore all Psychtoolbox windows (onscreen and offscreen) after they have
% been closed through 'sca' or 'Screen('CloseAll')'. This includes opening
% the windows as well as executing 'drawStaticGraphics' to also restore the
% graphics in the offscreen windows.

% Reopen onscreen window
if exist('winOn','var')
    [winOn.h, winOn.rect] = ...
        PsychImaging('openWindow', winOn.screen, winOn.bgColor, ...
        winOn.rect, [], [], [], e.s.multisampling);
    Screen('TextFont', winOn.h, winOn.font);
    Screen('TextSize', winOn.h, winOn.fontSize);
HideCursor;
end

% Reopen offscreen windows
if exist('winsOff','var')
    for osw = fieldnames(winsOff)'
        osw = osw{1};
        [winsOff.(osw).h, winsOff.(osw).rect] = ...
            Screen('OpenOffScreenWindow', winsOff.(osw).screen, ...
            winsOff.(osw).bgColor, winsOff.(osw).rect, ...
            [], [], e.s.multisampling);
    end
s3_drawStaticGraphics;
end


