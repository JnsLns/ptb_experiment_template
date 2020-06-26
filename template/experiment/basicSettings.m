
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             Built-in settings                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% These are general settings needed for all experiments. In other words:
% adjust their values, but don't remove variables (unless otherwise noted).

% Save results to file? 
doSave = true;

% If a folder path is given here, the result file will be saved there
% without asking. Can be left empty '' or commented out, in which case a
% folder select dialog will ask to select a directory upon experiment start.
% Note: variable 'expRootDir' contains the path of the experiment root
% folder; use it to define a results folder through a relative path.
savePath = fullfile(expRootDir,'/../results');

% If a path and name of a mat-file is given here, this file is loaded 
% automatically as trial file. If the file is located in the 'myTrialFiles'
% folder, the file name suffices. Can be left empty '' or commented out, in
% which case a load dialog will ask to select a trial file.
trialFilePath = 'exampleTrials.mat';

% Number of screen to use as experimental screen. If this variable is not 
% defined or emtpy [], the last number yielded by Screen('Screens') is used
% by default (use default if only one screen is connected). 
useScreenNumber = [];

% Actual screen size in millimeters (extent of visible image). Measure this
% as accurately as possible, as it determines how accurately stimulus sizes
% and positions will be realized, and how precise e.g. recordings of mouse
% positions are.
e.s.expScreenSize_mm = [797 333]; 

% Participant's (approximate) viewing distance from screen in millimeters.
e.s.viewingDistance_mm = 600;

% Degree of antialiasing. Higher values = smoother graphics but worse
% performance. Reduce if bad performance or graphics memory problems occur.
e.s.multisampling = 3;

% Name of the key to press to pause the experiment (to pause, the key
% needs to be depressed at the start of a trial)
pauseKey = 'Pause';

% Ratio of mouse cursor movement distance on the screen and mouse movement
% on the desk, as arising from mouse system settings. Required for using
% getMouseRM to stream/remap mouse movement (see Readme.md). No effect
% otherwise. To determine this value for the current hardware, run
% getMouseScreenToDeskRatio(), located in /experiment/infrastructure/
% helperFunctions/mouseInput/. It is absolutely vital for mouse tracking
% precision that this value is correct!!! 
e.s.rawMouseScreenToDeskRatio = 48.3;

% The default behavior if an error occurs in the experimental function is 
% to terminate it and remove temporary directories from the the MATLAB path.
% If 'debugOnError' exists and is 'true', the program will instead just
% close all Psychtoolbox windows and go to MATLAB prompt without
% terminating the function, thus allowing to examine its workspace. 
debugOnError = false;





 
