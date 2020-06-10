%%%%%%%%%%%%%%%%%%%%%%%%%% Trial generation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         
% Define a triallist and paradigm settings here. See Readme.md for help.   
% Or take a look at the example below. You minimally must define a struct 
% 'tg' with fields 'triallist' and 's' (settings).                        
%                                                                          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%            EXAMPLE             %%%%%%%%%%%%%%%%%%%%%

% All code in this file is example code. Delete it before implementing your
% custom trial generation.
%
% The example code generates a list of six trials in two blocks and defines
% some overarching settings. The file is saved to
% '../experiment/trialFiles/exampleTrials.m' and can be loaded and
% presented by the example experiment code. 


%%%%%%%%%%%%%%%%%%%%% Define some paradigm-level settings %%%%%%%%%%%%%%%%%


% Using some "reserved" field names. There is a bunch of these that you
% can simply set during trial generation and let the internal experiment
% scripts handle them. See Readme.md for documentation.

tg.s.experimentName = 'example'; % affects result file name
tg.s.bgColor = 'white';          % sets background color
tg.s.shuffleTrialOrder = true;   % makes sure trial order is randomized
tg.s.useTrialBlocks = true;      % tells experiment that trials are blocked
tg.s.desiredMouseScreenToDeskRatioXY = [1,1]; % modifies mouse "speed"

% Custom field names. These can be defined here as needed and used inside
% custom experiment code.

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%% Define some trials %%%%%%%%%%%%%%%%%%%%%%%%%%%

tg.triallist = table();                     % The trial list must be a table 

row = 0;                                    % We'll add trials row by row
                                            % for demonstration...

row = row+1;
tg.triallist.colors(row,:) = [1, 2, 1];     % use color 1, 2, and 1 (target has color 2)
tg.triallist.horzPos(row,:) = [-1, 0, 1];   % horizontal stimulus positions
tg.triallist.target(row,:) = 2;             % dot 2 is the target
tg.triallist.block(row,:) = 1;              % Label this trial as belonging
                                            % to block 1
row = row+1;
tg.triallist.colors(row,:) = [1, 1, 2];
tg.triallist.horzPos(row,:) = [-2, 0, 2];
tg.triallist.target(row,:) = 3;
tg.triallist.block(row,:) = 1;              

row = row+1;
tg.triallist.colors(row,:) = [2, 1, 1];
tg.triallist.horzPos(row,:) = [-3, 0, 3];
tg.triallist.target(row,:) = 1;
tg.triallist.block(row,:) = 1;              

% Copy the trials from above to form an additional block of trials. To tell
% the experiment that these are a different block, change block number.
trialsSecondBlock = tg.triallist;
trialsSecondBlock.block(:) = 2;

% Also, just for the heck of it, move over all stimuli in the second block
% to the right by three degrees of visual angle.
trialsSecondBlock.horzPos = trialsSecondBlock.horzPos + 3;

% Then simply append to first block of trials
tg.triallist = [tg.triallist; trialsSecondBlock];

% Add an ID to uniquely identify trials
tg.triallist.trialID = (1:size(tg.triallist,1))';


%%%%%%%%%%%%%%%% Save (to folder ../experiment/myTrialFiles') %%%%%%%%%%%%%

fileName = 'exampleTrials.mat';
% Save to folder 'trialFiles' in experiment directory, using relative path
savePath = fullfile(fileparts(mfilename('fullpath')), '..', ...
    'experiment', 'myTrialFiles', fileName);
save(savePath, 'tg');





                                                                    






