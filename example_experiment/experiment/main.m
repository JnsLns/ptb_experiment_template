function main
%% Experiment template code -- Example
%  Jonas Lins, November 2019
%
% This is an example experiment implementation based on the template code,
% essentially a simplified version of the experiment described by
% Hazeltine et al. (1997) in "If it's not there, where is it? Locating
% illusory conjunctions", Journal of Experimental Psychology, 23(1), 263-277.
%
% Procedure:
% 
% (1) Move mouse onto start marker.
% (2) Fixate fixation cross.
% (3) Wait until letters have been briefly presented.
% (4) Click on the location where the letter 'O' was presented.
% (5) Indicate whether a 'green O' was present. X = Yes, Y = No.


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
%e.s.expScreenSize_mm = [531 299]; % Gecko  
e.s.expScreenSize_mm = [800 339]; % Ultra-wide screen

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

try                         % ** DO NOT MODIFY **
preparations;               %  ** DO NOT MODIFY **
openOnscreenWindow;         % ** DO NOT MODIFY **

openOffscreenWindows;       % Open any Psychtoolbox offscreen windows you
                            % you may need. These are for drawing images to
                            % them in drawStaticGraphics and
                            % drawChangingGraphics (see below). The pre-
                            % pared images can then be used during a trial
                            % (i.e., in runTrial) by just copying the res-
                            % pective offscreen window to the pre-existing
                            % onscreen window.

drawStaticGraphics;         % Draw graphics that do not change from trial
                            % to trial (e.g., a fixation cross) to the
                            % prepared offscreen windows. 

presentInstructions;        % Things to be presented before the trials

% Iterate over trials
while curTrial <= size(trials,1)  % ** DO NOT MODIFY **
    trialLoopHead;                % ** DO NOT MODIFY **
        
    blockBreak;            % Code executed before each trial block, allowing
                           % for instance breaks before blocks. Only comes
                           % to effect if e.s.useTrialBlocks and
                           % e.s.breakBetweenBlocks are both true.
    
    drawChangingGraphics;  % Draw things that change from trial to trial
                           % (i.e., stimuli) to offscreen windows, to use
                           % them in runTrial.m (see below).   
    
    runTrial;              % Define what happens in the trial. Only this
                           % file should assign to struct 'out'.
    
    storeCustomOutputData; % Store data from this trial that can't be
                           % stored in results matrix.
    
    trialLoopTail;         % ** DO NOT MODIFY **
end                        % ** DO NOT MODIFY **

presentGoodbye;            % Things to be presented after the experiment

cleanUp;                   % ** DO NOT MODIFY **    
catch ME                   % ** DO NOT MODIFY **    
cleanUp;                   % ** DO NOT MODIFY **
rethrow(ME)                % ** DO NOT MODIFY **
end                        % ** DO NOT MODIFY **