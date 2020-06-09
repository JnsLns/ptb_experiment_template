%%%%%%%%%%%%%%%%%%%%%%%%%% Trial generation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Define a triallist and paradigm settings here. See Readme.md for help.  % 
% Remember, you minimally must define 'tg.triallist' and 'tg.s'           %
%                                                                         % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%                               EXAMPLE CODE

% All code below is example code. It creates a list of three trials and
% some settings, and saves it to '../experiment/trialFiles/exampleTrials.m'.
% It can be loaded and presented by the example experiment code. 
% To implement your own, delete all code below first.



%%%%%%%%%%%%%%%%%%%%% Define some paradigm-level settings %%%%%%%%%%%%%%%%%

tg.s.experimentName = 'example'; % reserved field name, affects result file
                                 % name (see Readme.md)

tg.s.bgColor = 'white';          % reserved field name, sets background
                                 % color (see Readme.md)

tg.s.shuffleTrialOrder = true;   % reserved field name, makes sure trial 
                                 % order is randomized

tg.s.useTrialBlocks = true;      % TODO
                                 
tg.s.stimColors = {[1 0 0], [0 1 0]};  % red and green

tg.s.stimRadius = 0.2;           % radius of dot stimuli (°visual angle)

tg.s.mouseCursorColor = [0 0 0]; % color of mouse cursor

tg.s.mouseCursorRadius = 0.2;    % size of mouse cursor

tg.s.startMarkerPos = [0, -10];  % this is the position of the start marker
                                 % where participants will have to move the
                                 % mouse to start a trial.                                 

tg.s.startMarkerRadius = 0.5;    % ...and its radius
tg.s.startMarkerColor = [0 0 0]; % ...and its color

tg.s.durOnStart = 1;             % Consecutive seconds mouse cursor needs
                                 % to be on start marker for stimuli
                                 % to be shown.

tg.s.desiredMouseScreenToDeskRatioXY = [1,1]; % TODO



%%%%%%%%%%%%%%%%%%%%%%%%%%%% Define some trials %%%%%%%%%%%%%%%%%%%%%%%%%%%

tg.triallist = table();
row = 0;

row = row+1;
tg.triallist.trialID(row,:) = 1;            % just to identify trials
tg.triallist.colors(row,:) = [1, 2, 1];     % use color 1, 2, and 1 (target has color 2)
tg.triallist.horzPos(row,:) = [-2, 0, 1];   % horizontal positions
tg.triallist.target(row,:) = 2;             % dot 2 is the target
tg.triallist.block(row,:) = 1;              % Label this trial as belonging
                                            % belonging to block 1

row = row+1;
tg.triallist.trialID(row,:) = 2;
tg.triallist.colors(row,:) = [1, 1, 2];
tg.triallist.horzPos(row,:) = [-5, 0, 5];
tg.triallist.target(row,:) = 3;
tg.triallist.block(row,:) = 1;              

row = row+1;
tg.triallist.trialID(row,:) = 3;
tg.triallist.colors(row,:) = [2, 1, 1];
tg.triallist.horzPos(row,:) = [-5, 0, 10];
tg.triallist.target(row,:) = 1;
tg.triallist.block(row,:) = 1;              

% Copy trials from above to form an additional block of trials.
trialsSecondBlock = tg.triallist;
trialsSecondBlock.block(:) = 2;
tg.triallist = [tg.triallist; trialsSecondBlock];
                                 


%%%%%%%%%%%%%%%%%% Save (to folder ../experiment/trialFiles') %%%%%%%%%%%%%

fileName = 'exampleTrials.mat';
% Save to folder 'trialFiles' in experiment directory, using relative path
savePath = fullfile(fileparts(mfilename('fullpath')), '..', ...
    'experiment', 'trialFiles', fileName);
save(savePath, 'tg');





                                                                    






