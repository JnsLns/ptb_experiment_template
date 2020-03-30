function runExperiment
% Run to execute the entire experiment

experimentSettings;

try                          
  
    % Things to prepare before trials    
    preparations;               
    openOnscreenWindow;         
    defineOffscreenWindows;
    openOffscreenWindows;       
    drawStaticGraphics;         
    presentInstructions;        

    % Iterate over trials
    while curTrial <= size(trials,1)  
        trialLoopHead;                          
        if doBlockBreak                  
            blockBreak;                
        end                                               
        drawChangingGraphics;      
        runTrial;                  
        storeCustomOutputData;     
        trialLoopTail;         
    end                        

    % Wrap up after all trials are done
    presentGoodbye;            
    cleanUp;                   

catch ME                   

    cleanUp;                   
    rethrow(ME)                

end                        