% Check whether pause key is being pressed, if so, halt experiment execution
% If user chooses to resume, reopen psychtoolbox windows whose properties
% are found in structs winOn and winsOff.

if KbCheck
    
    [~,~,whichKey] = KbCheck;
    keyName = KbName(whichKey);
    if iscell(keyName)
        keyName = keyName{1};
    end
    
    if strcmp(keyName,pauseKey)
        
        % Close all PTB windows, show dialogbox, wait for button press
        sca
        qdlg = 'No, go back!';
        while strcmp(qdlg,'No, go back!')
            qdlg = questdlg('Experiment paused.','Pause', ...
                'ABORT experiment','Resume experiment','Resume experiment');
            if strcmp(qdlg,'ABORT experiment')
                qdlg = questdlg('Are you sure you want to ABORT the experiment?','Sure?', ...
                    'No, go back!','Yes, ABORT the experiment.', 'No, go back!');
                if strcmp(qdlg,'Yes, ABORT the experiment.')
                    return;
                end
            end
        end                        
                                
        % Reopen onscreen window
        [winOn.h, winOn.rect] = ...
            PsychImaging('openWindow', winOn.screen, winOn.bgColor, winOn.rect);                 
        Screen('TextFont', win, winOn.font); 
        Screen('TextSize', win, winOn.fontSize);
        
        % Reopen offscreen windows
        for osw = fieldnames(winsOff)'
            [winsOff.(osw).h, winsOff.(osw).rect] = ...
                Screen('OpenOffScreenWindow', winsOff.(osw).screen, ...
                winsOff.(osw).bgColor, winsOff.(osw).rect);
        end                        
        
        HideCursor;
        
    end
end