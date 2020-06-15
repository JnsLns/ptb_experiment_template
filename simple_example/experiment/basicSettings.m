
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             Built-in settings                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% These are general settings needed for all experiments. In other words:
% adjust their values, but don't remove variables.

% Save results to file? If enabled, will ask for a participant code and
% save path at the outset of the experiment. 
doSave = true;

% TODOTODO
% Optional, leave empty '' or comment out if unneeded, in which case a save
% dialog will ask to select a save folder upon experiment start. If instead
% a path is given here, the results file will be stored there without asking. 
%savePath = 'd:\repos\git\ptb_experiment_template\simple_example\experiment\myTrialFiles\exampleTrials';

% Optional, leave empty '' or comment out if unneeded, in which case a load
% dialog will ask to select a trial file upon experiment start. If instead
% a path and name of a mat-file is given here, this file is loaded as trial
% file without asking. 
trialFilePath = 'd:\repos\git\ptb_experiment_template\simple_example\experiment\myTrialFiles\exampleTrials';

% Number of screen to use as experimental screen. If this variable is not 
% defined or emtpy [], the last number yielded by Screen('Screens') is used
% by default. 
useScreenNumber = [];

% Actual screen size in millimeters (extent of visible image). Measure this
% as accurately as possible, as it determines how accurately the requested
% stimulus sizes and positions will be realized.
e.s.expScreenSize_mm = [797 333]; 

% Participant's viewing distance from the screen in millimeters
e.s.viewingDistance_mm = 600;

% Degree of antialiasing. Higher values = smoother graphics but worse
% performance. Reduce if bad performance or graphics memory problems occur.
e.s.multisampling = 5;

% Name of the key to press to pause the experiment (to pause, the key
% needs to be depressed at the start of a trial)
pauseKey = 'Pause';

% Ratio of mouse cursor movement distance on the screen and mouse movement
% on the desk, as arising from mouse system settings. Required for using
% getMouseRM to stream/remap mouse movement (see Readme.md). No effect
% otherwise. To determine this value for the current hardware, run
% getMouseScreenToDesk(), located in /experiment/helperFunctions/mouseInput/.
e.s.rawMouseScreenToDeskRatio = 48.3;



 
