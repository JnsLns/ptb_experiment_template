%%%%%%%%%%%%%%%%%%%%%%%%%% Trial generation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Define a triallist and paradigm settings here. See Readme.md for help.  % 
% Remember, you minimally must define 'tg.triallist', 'tg.s', and         %
% 'tg.s.triallistCols' and its sub-fields.                                %
%                                                                         % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%                               EXAMPLE CODE

% All code below is example code. It creates a list of three trials and
% some settings, and saves it to '../experiment/trialFiles/exampleTrials.m'.
% It can be loaded and presented by the example experiment code. 
% To implement your own, delete all code below first.


%%%%%%%%%%%%% Define column names and numbers for the trial list %%%%%%%%%%

tg.s.triallistCols.trialID = 1;       % let's call column 1 "trialID"
tg.s.triallistCols.color = 2;         % and column 2 "color"
tg.s.triallistCols.horzPos = [3,4,5]; % horizontal positions in cols 3,4,5
tg.s.triallistCols.target = 6;        % target item number is in column 6                                      


%%%%%%%%%%%%%%%%%%%%%%%%%%%% Define some trials %%%%%%%%%%%%%%%%%%%%%%%%%%%

tlc = tg.s.triallistCols;  % the long names are for legibility. Abbreviate
                           % for convenience where appropriate
% trial 1
tg.triallist(1, tlc.trialID) = 1;            
tg.triallist(1, tlc.color) = 2;            % use color 2
tg.triallist(1, tlc.horzPos) = [-2,0,1];   % horizontal positions
tg.triallist(1, tlc.target) = 2;           % dot 2 is the target

% trial 2
tg.triallist(2, tlc.trialID) = 2;            
tg.triallist(2, tlc.color) = 1;            % use color 1
tg.triallist(2, tlc.horzPos) = [-5,0,5];   % horizontal positions
tg.triallist(2, tlc.target) = 3;           % dot 3 is the target

% trial 3
tg.triallist(3, tlc.trialID) = 3;            
tg.triallist(3, tlc.color) = 1;            % use color 1
tg.triallist(3, tlc.horzPos) = [-5,0,5];   % horizontal positions
tg.triallist(3, tlc.target) = 3;           % dot 3 is the target

% Note that the target number in column 'tlcs.target' can later be used
% to get the horizontal position of the target, e.g. in trial 3:
% tgtHorzPosTrial3 = tg.triallist(3, tlcs.horzPos(tg.triallist(3, tlcs.target)))


%%%%%%%%%%%%%%%%%%%%% Define some paradigm-level settings %%%%%%%%%%%%%%%%%

tg.s.experimentName = 'example'; % reserved field name, affects result file
                                 % name (see Readme.md)

tg.s.bgColor = 'white';          % reserved field name, sets background
                                 % color (see Readme.md)

tg.s.shuffleTrialOrder = true;   % reserved field name, makes sure trial 
                                 % order is randomized

tg.s.stimColors = {[1 0 0], [0 1 0]};  % red and green

tg.s.stimRadius = 1;             % radius of dot stimuli (°visual angle)

tg.s.mouseCursorColor = [0 0 0]; % color of mouse cursor

tg.s.mouseCursorRadius = 0.2;    % size of mouse cursor

tg.s.startMarkerPos = [0, -10];  % this is the position of the start marker
                                 % where participants will have to move the
                                 % mouse to start a trial.                                 

tg.s.startMarkerRadius = 2;      % ...and its radius

% The experiment will record mouse trajecories in matrix from. I define a
% column-struct here as a custom paradigm-setting so I'll know later what
% the matrix' columns contain:

tg.s.trajCols.x = 1;             % cursor x coordinates will be in col 1
tg.s.trajCols.y = 2;              % cursor y coordinates will be in col 2
tg.s.trajCols.t = 3;              % time stamp will be in column 3


%%%%%%%%%%%%%%%%%% Save (to folder ../experiment/trialFiles') %%%%%%%%%%%%%

fileName = 'exampleTrials.mat';
savePath = fullfile(fileparts(mfilename('fullpath')), '..', ...
    'experiment', 'trialFiles', fileName);
save(savePath, 'tg');





                                                                    






