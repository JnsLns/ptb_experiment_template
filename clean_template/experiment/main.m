function main
%% Experiment template code
%  Jonas Lins, November 2019
%
%
% To adjust the existing code to implement your own experiment:
%
% Do not modify code in this file that is labeled ** DO NOT MODIFY **. 
% Modify only contents of the script files included here that are not
% labeled ** DO NOT MODIFY **. All of these modifieable script files are
% located in the same folder as the current file (rather than in the
% private directory, which normally does not need to be changed). The
% settings defined just below this text may be modified as well, as
% specified there.
%
% See readme.md for further help.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% General settings 

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
e.s.expScreenSize_mm = [531 299]; 

% participant's distance from screen in millimeters
e.s.viewingDistance_mm = 500;

% name of key to press to pause experiment (to pause, the key needs to be
% depressed at the start of a trial)
pauseKey = 'Pause';


%%%% Settings specific to your paradigm.

% Add any settings specific to your paradigm here (but only those that are
% not better defined and fixed already when trials are created). Any of
% these settings that you may need to reference later for data analysis
% should be put into a field of struct 'e.s', since the entire struct 'e'
% will be saved to the results file.

%%%%%%%%%%%%%%%%%%%%%%%%%%%% END OF SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try                         % ** DO NOT MODIFY **
preparations;               % ** DO NOT MODIFY **
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
        
    drawChangingGraphics;  % Draw things that change from trial to trial
                           % (i.e., stimuli) to offscreen windows, to use
                           % them in runTrial.m (see below).   
    
    runTrial;              % Define what happens in the trial.
    
    storeCustomOutputData; % Store data from this trial that can't be
                           % stored in results matrix.
    
    trialLoopTail;         % ** DO NOT MODIFY **
end                        % ** DO NOT MODIFY **

presentGoodbye;            % Things to be presented after the experiment

cleanUp;                   % ** DO NOT MODIFY **    
catch                      % ** DO NOT MODIFY **   
cleanUp;                   % ** DO NOT MODIFY **   
end                        % ** DO NOT MODIFY **