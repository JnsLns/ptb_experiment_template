% Used to go to prompt on error (in catch block of runExperiment) instead
% of terminating experiment execution right away. Only fires if
% 'debugOnError' exists and is true. Also doesn't fire if error was
% produced deliberately to abort experiment in pauseAndResume.

if ~exist('doNotDebugOnError','var') || ~doNotDebugOnError
    
    if exist('debugOnError', 'var') && debugOnError
        
        disp( getReport( ME, 'extended', 'hyperlinks', 'on' ) );
        disp([char(10), ...
            'An error occurred (see above). Went to the prompt because ', ...
            char(10), ...
            '''debugOnError'' is true. Resuming execution will terminate', ...
            char(10), ...
            'experiment and rethrow error.', char(10)]);
        
        breakToDebug;
        
    end
    
end