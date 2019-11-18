% Generate a list of trials for the example experiment.
%
%                       !!! WORK IN PROGRESS !!!
%
% This works, but generated trial files currently only contain
% target-presence trials. Both-present and color-only trials will be
% implemented later. The code below is also quite untidy and contains
% various notes and todos, which will change in the future.




% Notes/todos
%
% It is possible to have less than nItems items (that is the max
% number used in any trial in the list). To use less items, pad the
% span of triallist columns for shapes (tg.triallistCols.shapesStart to 
% tg.triallistCols.shapesEnd) with nans. These positions will be skipped in
% drawStimuli.m in the experimental script. The other item column spans
% need to be padded too, of course.
%
% TODO: Check coding of item shapes and colors
%
% TODO: Currently there are only target present trials. Implement the other conditions. 
%
% NOTE on trials in Hazeltine 1997:
%
% In each trial, one of the middle three letters replaced by green
%
% In 75 % of trials, (i.e. tgt-present and both-present) one of the middle
% three letters is replaced by 'O' (code 0)
%
% 50% target present (green and O in the same letter)
% 25% both features present (but in different letters)
%       2/3 of those features neighboring
%       1/3 of those with intermediate letter
% 25% color only (none of the letters replaced by O)


try
% Add common_functions folder to MATLAB path temporarily 
% (will be removed at the end of this script)
[curFilePath,~,~] = fileparts(mfilename('fullpath'));
[pathstr, ~, ~] = fileparts(curFilePath);
dirs = regexp(pathstr, filesep, 'split');
pathToAdd = fullfile(dirs{1:end}, 'common_functions');
addpath(genpath(pathToAdd))


%%%% Define experiment settings:

% Size and position measures are in degrees visual angle ('_va')
% unless fieldnames are postfixed with '_mm' (millimeters). All position
% data is in the presentaion-area-based coordinate frame.
 
tg.s.experimentName = 'paradigm_1'; % This will be appended to each results file name
tg.s.mouseMovementMultiplier = [1 1];
tg.s.startMarkerColor = 'black';
tg.s.startMarkerRad_va = 0.2;
tg.s.cursorRad_va = 0.1;
tg.s.cursorColor = 'white';
tg.s.fixRadius_va = 0.5;            % Radius of fixation cross (visual angle)
tg.s.fixLineWidth_va = 0.1;         % Line width of fixation cross (visual angle)
tg.s.fixColor = 'white';            % Color of fixation cross (rgb vec or string)
tg.s.presArea_va = [40, 30];        % horz/vert size of presentation angle in degrees visual angle
                                    % (always centered within screen)
tg.s.startPosZ_mm = 200;            % Distance of pointer tip starting position
                                    % from screen surface (x and y are determined
                                    % automatically as center of presentation are).
tg.s.startRadius_va = 0.2;          % Radius around strating position in which pointer tip
                                    % has to be situated to count as being on the starting position
tg.s.circleLineWidth_va = 0.4;      % Line width of circle that indicates to the participant
                                    % how far the pointer is from the strating
                                    % position. in visual angle.
tg.s.durOnStart = 1;                % Time that pointer must dwell in starting position [s] before exp proceeds
tg.s.durWaitForStart = inf;         % Time to wait for participant to assume strating position 
tg.s.durPreStimFixation = 1.5;      % Time fixation cross is shown after starting position has been 
                                    % assumed and before stimuli are presented 
tg.s.durItemPresentation = 0.15;    % Duration of stimulus presentation
tg.s.allowedLocResponseTime = 2;    % Max duration to make location response
tg.s.allowedTgtResponseTime = 2;    % Max duration to make tgt presence response
tg.s.zZeroTolerance_mm = 1;         % pointer's *absolute* z-value must be below this value
                                    % for response to be registered (mm)
tg.s.pointerStartAngle = 15;        % max angle (deg) between lines from pointer tip
                                    % to pointer markers and z-axis during start phase
tg.s.circleNotOkColor = 'white';    % color of start pos indicator circle when pointer is too far
tg.s.circleOkColor = 'black';       % color of start pos indicator circle when pointer is within
                                    % tg.s.startRadius_mm millimeters of starting position
tg.s.yesKeyName = 'x';              % name of yes-key for target present response
tg.s.noKeyName = 'y';               % name of no-key for target present response
tg.s.instructionTextFont = 'Arial'; % font for instruction test
tg.s.instructionTextHeight_va = 0.75; % font height in degrees visual angle
tg.s.instructionTextColor = 'black';% color for instruction text (RGB triplet or string, see bgColor)
tg.s.bgColor = 'grey';              % background color (can be either an RGB triplet or one of the strings
                                    % 'black', 'white', or 'grey'
tg.s.feedbackTextColor = 'black';   % color of feedback text
  
% Starting position (cursor has to be moved to this position to start
% trial)
offsetFromCenter_x = 0;
offsetFromCenter_y = -(tg.s.presArea_va(2)/2 - tg.s.presArea_va(2) * 0.1 );
tg.s.startPos_va = [tg.s.presArea_va(1)/2 + offsetFromCenter_x, ...
                    tg.s.presArea_va(2)/2 + offsetFromCenter_y];

% Letter shape specifications for function lineItem (stimuli):
                                            
                                            % CODES / LETTER
                                            % 0  = O (tgt)
tg.s.stimShapes{1} = {[1,3,9]};             % 1  = L
tg.s.stimShapes{2} = {[1,9],[3,7]};         % 2  = X
tg.s.stimShapes{3} = {[4,6],[1,7],[3,9]};   % 3  = I
tg.s.stimShapes{4} = {[1,3,5,9,7]};         % 4  = W
tg.s.stimShapes{5} = {[7,1,3],[2,8]};       % 5  = F
tg.s.stimShapes{6} = {[3,1,5,7,9]};         % 6  = M
tg.s.stimShapes{7} = {[7,1,3,9],[2,8]};     % 7  = E
tg.s.stimShapes{8} = {[1,3],[2,8],[7,9]};   % 8  = H
tg.s.stimShapes{9} = {[1,6,7]};             % 9  = V
tg.s.stimShapes{10} = {[1,7,3,9]};          % 10 = Z
tg.s.stimShapes{11} = {[1,7],[4,6]};        % 11 = T
tg.s.stimShapes{12} = {[1,5,7],[5,6]};      % 12 = Y
tg.s.stimShapes{13} = {[3,1,9,7]};          % 13 = N
 
tg.s.tgtShapeCode = 0;

% Stimulus color specification. Color codes in triallist correspond to
% element number in this array. 
% TODO: Adjust these to have the correct colors used by Hazeltine!
% TODO: Adjust to colors used in Hazeltine
tg.s.stimColors{1} = [70 0 0]/255; % orange
tg.s.stimColors{2} = [0 0 255]/255; % blue
tg.s.stimColors{3} = [255 255 0]/255; % yellow
tg.s.stimColors{4} = [100 0 100]/255; % purple
tg.s.stimColors{5} = [100 100 100]/255; % gray
tg.s.stimColors{6} = [255 0 0]/255; % red
tg.s.stimColors{7} = [0 255 0]/255; % green TARGET COLOR!

tg.s.tgtColorCode = 7;
 
% Feedback parameters:
tg.s.feedback.dur_nonAbort = 1; % duration of feedback if trial completed
tg.s.feedback.dur_abort = 1;  % duration of feedback if trial aborted
% feedback text
tg.s.feedback.correct = 'Richtig!';    
tg.s.feedback.incorrect = 'Falsch!'; 
tg.s.feedback.notMovedToStart = 'Startposition nicht rechtzeitig eingenommen';
tg.s.feedback.leftStartInFix = 'Bitte erst nach den Buchstaben bewegen.';
tg.s.feedback.leftStartInStim = 'Bitte erst nach den Buchstaben bewegen.';
tg.s.feedback.exceededLocRT = 'Ortsauswahl zu sp�t';
tg.s.feedback.exceededTgtRT = 'Ziel-vorhanden-Reaktion zu sp�t';
 
% Positions of fix cross and stimulus regions (above and below fix cross)
tg.s.fixPos_va = [tg.s.presArea_va./2];
tg.s.stimRegionsWidth_va = 4.02;
tg.s.stimRegionsHeight_va = 0.88;
tg.s.fixCrossToStimRegBorder_va = 0.88; % from center of fix cross to border of stim regions

%%%% Stuff that is not (explicitly) stored in tg.s (but will be available
%    from the item-specific values)

stimSize_xy = [0.54, 0.71];
stimSep_x = 0.94;
stimLineWidth = 0.1;

% refers to elements of stimShapes
% each of these sequences in 25 % of trials
stimShapeSequences{1} = [1,2,3,4,5];     % LXIWF
stimShapeSequences{2} = [6,7,8,9,10];    % MEHVZ
stimShapeSequences{3} = [8,11,12,1,13];  % HTYLN
stimShapeSequences{4} = [3,9,10,11,7];   % IVZTE

% refers to elements of stimColors
% each of these sequences in 25% of all trials
stimColorSequences{1} = [1,2,3,4,6];     % OBYPR
stimColorSequences{2} = [3,6,5,1,2];     % YRGOB
stimColorSequences{3} = [4,1,2,3,5];     % POBYG
stimColorSequences{4} = [1,6,4,2,5];     % ORPBG



%%%% Create tg.s.triallistCols (holds column numbers for triallist)

nItems = 5; % This is the *maximum number* of items per trial. Fill columns
            % tg.s.triallistCols.shapesStart:tg.s.triallistCols.shapesEnd
            % with nans to display less items in some trials.

% Fields and number of columns for tg.s.triallistCols (struct holding column
% indices of trial matrix). 
triallistColsFields = ...
    {'trialID', 1; ...           % unique ID of this trial
    'numberInTriallist', 1; ...  % sequential number in original trial list
    'trialType', 1; ...         % 1 = target present, 2 = both ftrs present, 3 = color only
    'nItemsBtwFeatures', 1; ... % number of items between tgt shape and tgt color (0=tgt present, 1=neighboring, 2= one intermediate item, ...) 
    'tgtColorItemNum', 1; ...   % number of item in target color 
    'tgtShapeItemNum', 1; ...   % number of item with target shape    
    'letterStringCode', 1; ...      % letter string code (index into tg.s.stimShapes)
    'colorStringCode', 1; ...       % color string code (index into tg.s.stimColors)
    'horzPos', nItems; ...      % horizontal item center positions
    'vertPos', nItems; ...      % vertical item center positions    
    'horzSizes', nItems; ...    % horizontal item extent 
    'vertSizes', nItems; ...    % vertical item extent 
    'shapes', nItems; ...       % item shape identity codes (index into tg.s.stimShapes)
    'colors', nItems; ...       % item color codes (index into tg.s.stimColors)
    'lineWidths', nItems ...    % item line widths  
    };
% Create the struct
tg.s.triallistCols = struct;
for row = 1:size(triallistColsFields, 1)
    fName = triallistColsFields{row, 1};
    nCols = triallistColsFields{row, 2};
    tg.s.triallistCols = colStruct(fName, nCols, tg.s.triallistCols);
end



%%%% Compute stim regions

% stim regions (stim string center will be placed within randomly).
% above fix cross:
stimRegions{1} = [tg.s.fixPos_va(1) - tg.s.stimRegionsWidth_va/2, ...  % left
                  tg.s.fixPos_va(2) + tg.s.fixCrossToStimRegBorder_va, ...  % bottom                  
                  tg.s.stimRegionsWidth_va, ...             % width
                  tg.s.stimRegionsHeight_va];               % height              
% below fix cross:
stimRegions{2} = stimRegions{1};
stimRegions{2}(2) = tg.s.fixPos_va(2) - ...
    (tg.s.fixCrossToStimRegBorder_va + tg.s.stimRegionsHeight_va);



triallist = [];   

%%%% target present trials

possTgtPositions = 2:4;     % sequence positions where target may be placed

% letter sequences
for shapesNum = 1:numel(stimShapeSequences)        
    
    % color sequences
    for colorsNum = 1:numel(stimColorSequences)

        % green O-positions
        for oPos = possTgtPositions
            
            trialRow = [];
            
            shapes = stimShapeSequences{shapesNum};
            colors = stimColorSequences{colorsNum};
                  
            % Place target
            shapes(oPos) = tg.s.tgtShapeCode;                        
            colors(oPos) = tg.s.tgtColorCode;                                                                                
                                                           
            trialRow(tg.s.triallistCols.trialType) = 1;
            trialRow(tg.s.triallistCols.nItemsBtwFeatures) = 0;
            trialRow(tg.s.triallistCols.tgtColorItemNum) = oPos;
            trialRow(tg.s.triallistCols.tgtShapeItemNum) = oPos;
            trialRow(tg.s.triallistCols.letterStringCode) = shapesNum;
            trialRow(tg.s.triallistCols.colorStringCode) = colorsNum;
            trialRow(tg.s.triallistCols.shapesStart:tg.s.triallistCols.shapesEnd) = shapes;
            trialRow(tg.s.triallistCols.colorsStart:tg.s.triallistCols.colorsEnd) = colors;                                                                                                                                       
            
            triallist(end+1,:) = trialRow;
            
        end
        
    end
    
end


% TODO
% %%%% both- present trials
% 
% bothPresentTriallist = [];  % List of all possible both-present trials
%                             % (i.e. all 48 combinations of 4 shape-sequence
%                             % � 4 color sequence � 3 tgt slot)
% 
% possTgtFtrPositions = 2:4;  

% TODO 
%%%% color only trials




% Iterate through triallist rows and add positions etc (all things that are
% not condition-specific)

outerItemCentersSep = ((nItems-1) * stimSize_xy(1) + (nItems-1) * stimSep_x);

for curRow = 1:size(triallist, 1)
    
    % Compute stim locations
    
    % select one of the two stim regions at random
    reg = stimRegions{ceil(0.5+rand(1))};
    sequCenter_x = reg(1) + rand(1) * reg(3);
    sequCenter_y = reg(2) + rand(1) * reg(4);
    
    % horizontal item positions (centers)    
    triallist(curRow, tg.s.triallistCols.horzPosStart:tg.s.triallistCols.horzPosEnd) = ...
        (sequCenter_x - outerItemCentersSep/2):...
        (stimSize_xy(1)+stimSep_x):...
        (sequCenter_x + outerItemCentersSep/2);
    
    % vertical item positions (centers)
    triallist(curRow, tg.s.triallistCols.vertPosStart:tg.s.triallistCols.vertPosEnd) = ...
        sequCenter_y;
    
    % sizes
    triallist(curRow, tg.s.triallistCols.horzSizesStart:tg.s.triallistCols.horzSizesEnd) = ...
        stimSize_xy(1);
    triallist(curRow, tg.s.triallistCols.vertSizesStart:tg.s.triallistCols.vertSizesEnd) = ...
        stimSize_xy(2);
            
    % line widths
    triallist(curRow, tg.s.triallistCols.lineWidthsStart:tg.s.triallistCols.lineWidthsEnd) = ...
        stimLineWidth;
           
    %%%% create unique ID for current trial
    trialID = round(rand()* 1e+12);
    while any(triallist(:, tg.s.triallistCols.trialID) == trialID)
        trialID = round(rand()* 1e+12);                
    end
    triallist(curRow, tg.s.triallistCols.trialID) = trialID;
                
end


%%%% Shuffle trials and then add sequential number

% shuffle
triallist = triallist(randperm(size(triallist,1)),:);

% sequential numbers
triallist(:,tg.s.triallistCols.numberInTriallist) = 1:size(triallist,1);
            

tg.triallist = triallist;


save('s:\trials.mat', 'tg')


% Remove common_functions folder from MATLAB path
rmpath(genpath(pathToAdd))
catch
rmpath(genpath(pathToAdd))
end