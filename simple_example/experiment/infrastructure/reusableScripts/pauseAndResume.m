% Check whether pause key is being pressed, if so, halt experiment
% execution and show a dialog box. If user chooses to resume, reopen
% psychtoolbox windows whose properties are found in structs winOn and
% winsOff and re-draw static graphics.

pauseKeyCheck;

if pauseKeyDepressed
    
    % Close all PTB windows
    Screen('CloseAll')
         
    % Show dialogbox, wait for selection
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
    
    restorePsychWindows;
    
end

