function main
%% Experiment template code
%  Jonas Lins, November 2019


% To adjust the existing code to implement your own experiment:
%
% Modify any code in this script file except for those parts that are
% labeled ** DO NOT MODIFY **. The contents of script files included here
% by calling their file name can also be modified, again except for those
% labeled ** DO NOT MODIFY **. All of these modifieable script files are
% located in the same folder as the current file (rather than in the
% private directory). The settings defined just below this text may of
% course be modified as well as specified there).
%
% See readme.md for further help.


%%%% General settings 
%
% Note: All properties of the paradigm itself should be defined in trial
% generation. Here only things that might have to be changed halfway
% through participants or to run an experiment on different systems should
% be listed here (such as the screen size). Usually only the values of the
% following settings need to be modified, not the code itself.

% save results to file?
doSave = true;

% For antialiasing: higher values = smoother graphics but worse
% performance. Reduce if bad performance or graphics memory problems.
e.s.multisampling = 3;

% actual screen size in mm (visible image) as accurately as possible.
%e.s.expScreenSize_mm = [474, 291]; % Miro
e.s.expScreenSize_mm = [531 299]; % Gecko

% Participant's distance from screen in millimeters
e.s.viewingDistance_mm = 500;

% name of key to press to pause experiment (to pause, the key needs to be
% depressed at the start of a trial)
pauseKey = 'Pause';


%%%% Settings specific to the implemented paradigm.

% Add any settings specific to your paradigm here (but only those that are
% not better defined and fixed already when trials are created). Any of
% these settings that you may need to reference later for data analysis
% should be put into a field of struct 'e.s', since the entire struct 'e'
% will be saved to the results file.

% Define column numbers for trajectory matrices
e.s.trajCols.x = 1; % pointer coordinates
e.s.trajCols.y = 2;
e.s.trajCols.t = 3; % pc time

% Note about trajectories: When storing trajectories in 'e.trajectories'
% only the first of any directly successive data points that have the
% same position data is kept.



%%%%%%%%%%%%%%%%%%%%%%%%%%%% END OF SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


try                 % ** DO NOT MODIFY **
preparations;       % ** DO NOT MODIFY **
openOnscreenWindow; % ** DO NOT MODIFY **


% Open Psychtoolbox offscreen windows.
% Things will be drawn to these windows before the actual presentation
% phase of a trial. During the trial, these ready-made images then only need
% to be copied to the onscreen window for presentation.
% Add any windows you may need in this file.
openOffscreenWindows;

% Draw graphics that do not change from trial to trial (e.g., a fixation
% cross) to the prepared offscreen windows.
% Modify this file as needed.
drawStaticGraphics;

% Things to be presented before the trials
presentInstructions;


% Iterate over trial list
while curTrial <= size(trials,1)    % ** DO NOT MODIFY **
    trialLoopHead;                  % ** DO NOT MODIFY **

    
    % Draw things that change from trial to trial (i.e., stimuli) to
    % offscreen windows, to use them in runTrial.m included below.
    drawChangingGraphics;

    % Define what happens in the trial. Only this file should assign
    % to struct 'out'.
    runTrial;

    % Store data from this trial that can't be stored in results matrix.
    storeCustomOutputData;

    
    trialLoopTail;  % ** DO NOT MODIFY **
end                 % ** DO NOT MODIFY **


% Things to be presented after the experiment
presentGoodbye;


cleanUp; % ** DO NOT MODIFY **    
catch    % ** DO NOT MODIFY **   
cleanUp; % ** DO NOT MODIFY **   
end      % ** DO NOT MODIFY **