%%%%%%%%%%%%%%%%%%%%%%%%%% Trial generation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Define a triallist and paradigm settings here. See Readme.md for help.  % 
% Remember, you minimally must define 'tg.triallist', 'tg.s', and         %
% 'tg.s.triallistCols' and its sub-fields.                                %
%                                                                         % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% EXAMPLE CODE

% All code below is example code. It creates a list of three trials and
% some settings, and saves it to '../experiment/trialFiles/exampleTrials.m'.
% It can be loaded and presented by the example experiment code. 
% To implement your own, delete all code below first (or build on it).

%%% Define column names and numbers for the trial list

tg.s.triallistCols.trialID = 1;       % let's call column 1 "trialID"
tg.s.triallistCols.color = 2;         % and column 2 "color"
tg.s.triallistCols.horzPos = [3,4,5]; % horizontal positions in these columns
tg.s.triallistCols.target = 6;        % tgt number is given in column 6                                      

%%% Define some trials (yes, you should do that more efficiently in practice)

tlcs = tg.s.triallistCols; % the long names are for readibility. Abbreviate
                           % for convenience if you like.
% trial 1
tg.triallist(1, tlcs.trialID) = 1;            
tg.triallist(1, tlcs.color) = 2;            % use color 2
tg.triallist(1, tlcs.horzPos) = [-2,0,1];   % horizontal positions
tg.triallist(1, tlcs.target) = 2;           % dot 2 is the target

% trial 2
tg.triallist(2, tlcs.trialID) = 2;            
tg.triallist(2, tlcs.color) = 1;            % use color 1
tg.triallist(2, tlcs.horzPos) = [-5,0,5];   % horizontal positions
tg.triallist(2, tlcs.target) = 3;           % dot 3 is the target

% trial 3
tg.triallist(3, tlcs.trialID) = 3;            
tg.triallist(3, tlcs.color) = 1;            % use color 1
tg.triallist(3, tlcs.horzPos) = [-5,0,5];   % horizontal positions
tg.triallist(3, tlcs.target) = 3;           % dot 3 is the target

% Note that the target number in column 'tlcs.target' can later be used
% to get the horizontal position of the target, e.g. in trial 3:
% tgtHorzPosTrial3 = tg.triallist(3, tlcs.horzPos(tg.triallist(3, tlcs.target)))

%%% Define some paradigm-level settings

% These are reserved / predefined (see Readme.md)

tg.s.experimentName = 'example';
tg.s.bgColor = 'white'; 
tg.s.shuffleTrialOrder = true;

% These are custom

tg.s.stimColors = {[1 0 0], [0 1 0]};  % red and green
tg.s.stimRadius = 1;  % radius of color dots
tg.s.mousePointerColor = [0 0 0];
tg.s.mousePointerRadius = 0.2;
% The experiment will record mouse trajecories in matrix from. I define a
% column-struct here as a custom paradigm-setting so I'll know later what
% the matrix' columns contain:
tg.s.trajCols.x = 1; % cursor x coordinates
e.s.trajCols.y = 2;  % cursor y coordinates
e.s.trajCols.t = 3;  % time stamp


%%% Save (to folder ../experiment/trialFiles')

fileName = 'exampleTrials.mat';
savePath = fullfile(fileparts(mfilename('fullpath')), '..', ...
    'experiment', 'trialFiles', fileName);
save(savePath, 'tg');





                                                                    






