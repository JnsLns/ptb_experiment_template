% Check whether pause key is being pressed, if so, halt experiment
% execution and show a dialog box. If user chooses to resume, reopen
% psychtoolbox windows whose properties are found in structs winOn and
% winsOff and re-draw static graphics.

pauseKeyCheck;

if pauseKeyDepressed        
    
    strDebug = 'Debug (break & go to prompt)';
    strNo = 'No, go back!';
    strAbort = 'ABORT experiment';
    strConfirmAbort = 'Yes, ABORT the experiment.'; 
    
    % Close all PTB windows
    Screen('CloseAll')
         
    % Show dialogbox, wait for selection
    qdlg = strNo;
    while strcmp(qdlg, strNo)
        
        qdlg = questdlg('Experiment paused.','Pause', ...
            strAbort, strDebug, 'Resume experiment','Resume experiment');
                        
        if strcmp(qdlg, strAbort)
            
            qdlg = questdlg('Are you sure you want to ABORT the experiment?','Sure?', ...
                strNo, strConfirmAbort, 'No, go back!');
            
            if strcmp(qdlg, strConfirmAbort)   
                doNotDebugOnError = true;
                error('Aborted execution as requested.')            
            end
        
        elseif strcmp(qdlg, strDebug)
                
            breakToDebug;            
            break; 
            
        end
        
    end
        
    if ~strcmp(qdlg, strDebug) % debug script already restores windows.
        restorePsychWindows;
    end
    
end

