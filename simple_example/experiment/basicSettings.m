
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             Built-in settings                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% These are general settings needed for all experiments. In other words:
% adjust their values, but don't remove variables.

% Save results to file? If enabled, will ask for a participant code and
% save path at the outset of the experiment. 
doSave = true;

% If a path name is given here, the result file will be saved there (the 
% file name will be a combination of the participant code and the experiment
% name defined during trial generation), without asking. Can be left empty
% '' or commented out, in which case a folder select dialog will ask to
% select a directory each time the experiment is started. Note: The variable
% 'expRootDir' contains the path of the experiment root directory.
savePath = fullfile(expRootDir,'/../results');

% If a path and name of a mat-file is given here, this file is loaded 
% automatically as trial file. Can be left empty '' or commented out, in
% which case a load dialog will ask to select a trial file each time the
% experiment is started.
trialFilePath = '';

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



 
