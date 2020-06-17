% Used to go to prompt on error (in catch block of runExperiment) instead
% of terminating experiment execution right away. Only fires if
% 'debugOnError' exists and is true. Also doesn't fire if error was
% produced deliberately to abort experiment in pauseAndResume.

if ~exist('doNotDebugOnError','var') || ~doNotDebugOnError
    
    if exist('debugOnError', 'var') && debugOnError
        
        disp( getReport( ME, 'extended', 'hyperlinks', 'on' ) );
        disp([newline, ...
            'An error occurred (see above). Went to the prompt because ', ...
            newline, ...
            '''debugOnError'' is true. Resuming execution will terminate', ...
            newline, ...
            'experiment and rethrow error.', newline]);
        
        breakToDebug;
        
    end
    
end