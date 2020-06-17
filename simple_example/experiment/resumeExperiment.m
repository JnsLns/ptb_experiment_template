%%%%%%%%%%%%%%%%%%%%%%%%%%%% Resume experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         
% Run this file to complete an unfinished result file. 
%
% Do not modify this file.       
% 
% Details: This allows to finish incomplete files obtained in previous 
% sessions. Instead of asking for a trial file, you will be asked for an
% unfinished result file, i.e., one of those temporary files postfixed 
% ".incomplete" that the experiment script stores as long as not all trials
% are done. The file will be loaded and the experiment will be resumed 
% just as if it had never been interrupted. Note that settings defined in 
% 'basicSettings.m' and 'customSettings.m' will OVERRIDE values in the 
% loaded file (this is intended behavior, as it allows to finish incomplete
% files with different hardware settings if need be, but see below).
%
%
%                            !!! WARNING !!! 
%
% (The following does not apply if you only use resume mode to resume on the
% same hardware (e.g. screen size) and with the same spatial setup (i.e.,
% same viewing distance etc.). So don't worry. )
%
% When resuming an experiment with a different spatial setup (e.g., smaller
% viewing distance), the CoordinateConverter object stored in 'e.s.convert'
% in the output cannot be used later (during analysis) to reliably convert
% between units. This is because the conversion factors for the first and
% second batch of trials differ, and the old settings in the resumed file
% will be overwritten by the new ones, including the convert object. (To
% be precise the converter can be used on the second batch of trials, but
% not on the first one). 
% Assuming you recorded everything in visual angle, it *might* be sensible
% to use the new converter object for the older trials as well, under the
% assumption that any effects on responses live in that angular space while
% distance and similar aspects just scale them linearly, but that may not
% be true.
% Bottom line is, if you really need reliable conversion on all trials and 
% need to resume on different hardware often, you might need a workaround.
% One is to store the object 'convert' on each trial and use each trial's
% own convert object when converting later. The better one is probably to
% store all values (visual angle, millimeter, pixels) already during the
% experiment (that's actually recommended anyway).
%                                                                          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function resumeExperiment
    runExperiment(true);
end
