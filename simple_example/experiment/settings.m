

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             Built-in settings                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% These are general settings needed for all experiments. In other words:
% adjust their values, but don't remove variables.

% Save results to file? If enabled, will ask for a participant code and
% save path at the outset of the experiment. 
doSave = true;

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




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             Custom settings                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add any settings here that are specific to your paradigm and that might
% need to be changed in between participants without re-running trial
% generation. This might occur, for instance, for settings that depend on
% properties of some piece of hardware that might be different when the
% experiment is run on a different machine.
%
% Note however that it is usually a better idea to define as many settings
% as possible during trial generation, so that their values are fixed in
% the trial file, as this ensures that they can't be changed accidentally
% once trials have been generated (yes, it does happen :).
% As always, any settings defined here that you might want to look up later
% should be stored in struct 'e.s', to save in the results file.

%%%%%%%%%%%%%%%%%%%%%%% Usage for testing / debugging %%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% It is also possible to override settings that already exist in the trial%
% file (i.e., in struct 'tg.s'), by re-setting them here. This would      %
% normally throw an error, which can however be disabled by setting:      %
%                                                                         %
% e.s.expScriptSettingsOverrideTrialGenSettings = true;                   %
%                                                                         %
% Setting this means that when a field with the same name exists in 'e.s' %
% and in 'tg.s', the value from 'e.s' will take precedence. Instead       %
% of throwing an error, which is the default behavior, a message box will %
% warn the user when the experiment is started, but it will then run      % 
% normally. This should be used only for debugging.                       %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


 
