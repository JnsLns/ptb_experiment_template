% Open offscreen windows specified in openOffscreenWindows.m

% The loop goes through the struct 'winsOff', opens windows and creates
% subfield 'h' automatically, based on the struct's fields. 

for winName = fieldnames(winsOff)'

    winName = winName{1};

    % Screen to open window on 
    winsOff.(winName).screen = expScreen;
    % Get window center
    [winsOff.(winName).center(1), winsOff.(winName).center(2)] = ...
        RectCenter(winsOff.(winName).rect);
    % Open window and store pointer in field 'h'
    [winsOff.(winName).h, winsOff.(winName).rect] = ...
        Screen('OpenOffScreenWindow', winsOff.(winName).screen, ...
        winsOff.(winName).bgColor, winsOff.(winName).rect, ...
        [], [], e.s.multisampling);
    
end