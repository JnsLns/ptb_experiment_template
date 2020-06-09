% Open offscreen windows specified in openOffscreenWindows.m

% The loop goes through the struct 'winsOff', opens windows and creates
% subfield 'h' automatically, based on the struct's fields. 

% Default values to be used if the respective fields were not defined in
% defineOffscreenWindows.m:
winsOffDefaultValues = ...
{...
'screen', useScreenNumber; ...
'bgColor', e.s.bgColor; ...
'rect', winOn.rect; ...
'clearEachTrial', false
};

% Open wins
for winName = fieldnames(winsOff)'

    winName = winName{1};

    % Add default fields / values
    for row = 1:size(winsOffDefaultValues,1)                            
        fieldName = winsOffDefaultValues{row,1};
        fieldValue = winsOffDefaultValues{row,2};
        if ~isfield(winsOff.(winName), fieldName)
            winsOff.(winName).(fieldName) = fieldValue;    
        end    
    end        
    
    % Get window center
    [winsOff.(winName).center(1), winsOff.(winName).center(2)] = ...
        RectCenter(winsOff.(winName).rect);
    % Open window and store pointer in field 'h'
    [winsOff.(winName).h, winsOff.(winName).rect] = ...
        Screen('OpenOffScreenWindow', winsOff.(winName).screen, ...
        winsOff.(winName).bgColor, winsOff.(winName).rect, ...
        [], [], e.s.multisampling);
    
end