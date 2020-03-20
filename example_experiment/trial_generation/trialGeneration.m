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
% TODO: Mouse movement multiplier?


try                                                   % ** DO NOT MODIFY **
% Add common_functions folder to MATLAB path          % ** DO NOT MODIFY **
% temporarily (will be removed at the end of this     % ** DO NOT MODIFY **
% script) Allows using functions from that folder.    % ** DO NOT MODIFY **
[curFilePath,~,~] = fileparts(mfilename('fullpath')); % ** DO NOT MODIFY **
[pathstr, ~, ~] = fileparts(curFilePath);             % ** DO NOT MODIFY **  
dirs = regexp(pathstr, filesep, 'split');             % ** DO NOT MODIFY **  
pathToAdd = fullfile(dirs{1:end}, 'common_functions');% ** DO NOT MODIFY **
addpath(genpath(pathToAdd))                           % ** DO NOT MODIFY **

trialFileSavePathName = 'my_trials_Hazeltine1997.mat';

%%%% Define experiment settings:

% Size and position measures are in degrees visual angle ('_va')
% unless fieldnames are postfixed with '_mm' (millimeters). All position
% data is in the presentaion-area-based coordinate frame.
 
tg.s.experimentName = 'paradigm_1'; % This will be appended to each results file name
tg.s.mouseMovementMultiplier = [1 1]; % mouse movement speed in each dimension
tg.s.startMarkerColor = 'black';
tg.s.startMarkerRad_va = 0.2;
tg.s.cursorRad_va = 0.1;
tg.s.cursorColor = 'white';
tg.s.fixRadius_va = 0.5;            % Radius of fixation cross (visual angle)
tg.s.fixLineWidth_va = 0.1;         % Line width of fixation cross (visual angle)
tg.s.fixColor = 'white';            % Color of fixation cross (rgb vec or string)
tg.s.presArea_va = [40, 30];        % horz/vert size of presentation angle in degrees visual angle
                                    % (always centered within screen)
tg.s.startRadius_va = 0.2;          % Radius around strating position in which pointer tip
                                    % has to be situated to count as being on the starting position
tg.s.durOnStart = 1;                % Time that pointer must dwell in starting position [s] before exp proceeds
tg.s.durWaitForStart = inf;         % Time to wait for participant to assume strating position 
tg.s.durPreStimFixation = 0.5;      % Time fixation cross is shown after starting position has been 
                                    % assumed and before stimuli are presented 
tg.s.durItemPresentation = 0.1;     % Duration of stimulus presentation
tg.s.durPostStimMask = 0.057;       % Duration of white mask after stimulus presentation
tg.s.postStimMaskColor = 'white';   % Color of post-stimulus mask
tg.s.allowedLocResponseTime = 2;    % Max duration to make location response
tg.s.allowedTgtResponseTime = 2;    % Max duration to make tgt presence response
tg.s.feedbackBeepCorrect = ...      % Properties (freq, amplitude, duration) of
[600, 0.3, 0.05];                   % beep when target presence resp. correct
tg.s.feedbackBeepIncorrect = ...    % Properties (freq, amplitude, duration) of
[100, 0.3, 0.05];                   % beep when target presence resp. INcorrect
tg.s.yesKeyName = 'x';              % name of yes-key for target present response
tg.s.noKeyName = 'y';               % name of no-key for target present response
tg.s.instructionTextFont = 'Arial'; % font for instruction test
tg.s.instructionTextHeight_va = 0.75; % font height in degrees visual angle
tg.s.instructionTextColor = 'black';% color for instruction text (RGB triplet or string, see bgColor)
tg.s.bgColor = 'grey';              % background color (can be either an RGB triplet or one of the strings
                                    % 'black', 'white', or 'grey'
tg.s.feedbackTextColor = 'black';   % color of feedback text
tg.s.shuffleTrialOrder = true;      % If true, the order of trials in the triallist
                                    % loaded from the file generated here is
                                    % shuffled in the experimental script before
                                    % presenting them to the participant (so that
                                    % the order created here is changed!). Note that 
                                    % if blocks are used (tg.s.useTrialBlocks),
                                    % shuffling will occur only within blocks.
tg.s.useTrialBlocks = true;         % trials are blocked.
tg.s.breakBetweenBlocks = true;     % Execute code in blockBreak.m (pause)
                                    % before each new block of trials.
tg.s.blockBreakString = ...         % Display text for breaks. 
'Pause. Taste drücken um fortzufahren.';

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
% Colors are adjusted to accord with those used by Hazeltine.
tg.s.stimColors{1} = [254 219 80]/255; % orange
tg.s.stimColors{2} = [70 138 255]/255; % blue
tg.s.stimColors{3} = [232 216 69]/255; % yellow
tg.s.stimColors{4} = [175 117 249]/255; % purple
tg.s.stimColors{5} = [204 231 255]/255; % gray
tg.s.stimColors{6} = [228 96 104]/255; % red
tg.s.stimColors{7} = [92 197 128]/255; % green TARGET COLOR!

tg.s.tgtColorCode = 7;
 
% Feedback parameters:
tg.s.feedback.dur_abort = 1;  % duration of feedback if trial aborted
% feedback text
tg.s.feedback.notMovedToStart = 'Startposition nicht rechtzeitig eingenommen';
tg.s.feedback.leftStartInFix = 'Bitte erst nach den Buchstaben bewegen.';
tg.s.feedback.leftStartInStim = 'Bitte erst nach den Buchstaben bewegen.';
tg.s.feedback.exceededLocRT = 'Ortsauswahl zu spät';
tg.s.feedback.exceededTgtRT = 'Ziel-vorhanden-Reaktion zu spät';
 
% Positions of fix cross and stimulus regions (above and below fix cross)
tg.s.fixPos_va = tg.s.presArea_va./2;
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
    'block', 1; ...              % block number
    'numberInUnshuffledTriallist', 1; ...  % sequential number in original trial list
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



%%%% Generate trials
 
% In Hazeltine:
% - 3 blocks of 160 trials each * 2 days -> 3*2*160 = 960 trials in total 
% - per block:
%       50 % (80) target present trials (green and O in one item)
%       25 % (40) both-present trials   (green and O in different items)
%       25 % (40) color only trials     (green in one item, O absent)
%
% Thus, for the differet trials:
% - target present: take one letter string, one color string, put green O in
%   position 2,3,4 in 2/3 (of all trials). There are 4*4*3 = 48 combi-
%   nations. 80 such trials are needed in each block. There
%   are 6 blocks in total, so that 6*80 = 480 such trials are needed in
%   total; thus the set of target present trials needs to be repeated 10
%   times in total (take care to split them equally over blocks by making
%   an ordered list and dividing it into 80-trial batches).
% - both-present: take one letter string, one color string, place O in one
%   of the three center positions and green in the other (there are 6 of
%   them). There are 4*4*6 = 96 combinations (two thirds of which have the
%   two target features in adjacent positions), 40 are needed per block,
%   two thirds of which should have adjacent items. There are six blocks,
%   so a total of 6*40 = 240 are needed. 240/96 = 2.5. Need to find a
%   sensible split... Note: Check whether 2/3 need to be adjaent *within
%   each block*
% - color-only: take one letter string, one-color string. Color one of the
%   three center letters green . There are 4*4*3 = 48 combinations and 40
%   are needed per block. 6*40 = 240 in total. 240/48 = 5, so no problem.

%%%% target present trials (trialType 1)

% order in target present pool:
% 3 positions                             = blocks of 3 trials
% 4 color seq * 3 positions               = blocks of 12 trials
% 4 shape seq * 4 color seq * 3 positions = pool of 48 trials

basePoolTargetPresent = [];  
possTgtPositions = 2:4;     % sequence positions where target may be placed
% letter sequences
for shapesNum = 1:numel(stimShapeSequences)         
    % color sequences
    for colorsNum = 1:numel(stimColorSequences)
        % green O-positions
        for oPos = possTgtPositions            
            trialRow = [];            
            % pick shape and color sequence
            shapes = stimShapeSequences{shapesNum};
            colors = stimColorSequences{colorsNum};                  
            % Place target
            shapes(oPos) = tg.s.tgtShapeCode;                        
            colors(oPos) = tg.s.tgtColorCode;                                                                                  
            % Fill trial row                                               
            trialRow(tg.s.triallistCols.trialType) = 1;
            trialRow(tg.s.triallistCols.nItemsBtwFeatures) = nan;
            trialRow(tg.s.triallistCols.tgtColorItemNum) = oPos;
            trialRow(tg.s.triallistCols.tgtShapeItemNum) = oPos;
            trialRow(tg.s.triallistCols.letterStringCode) = shapesNum;
            trialRow(tg.s.triallistCols.colorStringCode) = colorsNum;
            trialRow(tg.s.triallistCols.shapesStart:tg.s.triallistCols.shapesEnd) = shapes;
            trialRow(tg.s.triallistCols.colorsStart:tg.s.triallistCols.colorsEnd) = colors;                                                                                                                                       
            % add to trial pool
            basePoolTargetPresent(end+1,:) = trialRow;            
        end        
    end    
end


%%%% both-present adjacent trials (trialType 2)

% order in both-present pool:
% 4 position combinations (all adjacent) = blocks of 4 trials
% 4 color seq * 4 position combinations   = blocks of 16 trials
% 4 shape seq * 4 color seq * 4 pos com.  = pool of 64 trials

basePoolBothPresentAdj = [];               
% first element in each vector is position of green, second O
possFtrPositions = {[3 4],[4 3],[2 3],[3 2]};
for shapesNum = 1:numel(stimShapeSequences)         
    % color sequences
    for colorsNum = 1:numel(stimColorSequences)
        % green O-positions
        for oPos = possFtrPositions            
            oPos = oPos{1};            
            trialRow = [];
            % pick shape and color sequence
            shapes = stimShapeSequences{shapesNum};
            colors = stimColorSequences{colorsNum};                  
            % Place green            
            colors(oPos(1)) = tg.s.tgtColorCode;                                                                                  
            shapes(oPos(2)) = tg.s.tgtShapeCode;                        
            % Fill trial row                                        
            trialRow(tg.s.triallistCols.trialType) = 2;
            trialRow(tg.s.triallistCols.nItemsBtwFeatures) = abs(diff(oPos))-1;
            trialRow(tg.s.triallistCols.tgtColorItemNum) = oPos(1);
            trialRow(tg.s.triallistCols.tgtShapeItemNum) = oPos(2);
            trialRow(tg.s.triallistCols.letterStringCode) = shapesNum;
            trialRow(tg.s.triallistCols.colorStringCode) = colorsNum;
            trialRow(tg.s.triallistCols.shapesStart:tg.s.triallistCols.shapesEnd) = shapes;
            trialRow(tg.s.triallistCols.colorsStart:tg.s.triallistCols.colorsEnd) = colors;                                                                                                                                       
            % add to trial pool
            basePoolBothPresentAdj(end+1,:) = trialRow;            
        end        
    end    
end


%%%% both-present non-adjacent trials (trialType 2)

% order in both-present pool:
% 2 position combinations (last four adj) = blocks of 2 trials
% 4 color seq * 2 position combinations   = blocks of 8 trials
% 4 shape seq * 4 color seq * 2 pos com.  = pool of 32 trials

basePoolBothPresentNonadj = [];               
% first element in each vector is position of green, second O
possFtrPositions = {[2 4],[4 2]};
for shapesNum = 1:numel(stimShapeSequences)         
    % color sequences
    for colorsNum = 1:numel(stimColorSequences)
        % green O-positions
        for oPos = possFtrPositions            
            oPos = oPos{1};            
            trialRow = [];
            % pick shape and color sequence
            shapes = stimShapeSequences{shapesNum};
            colors = stimColorSequences{colorsNum};                  
            % Place green            
            colors(oPos(1)) = tg.s.tgtColorCode;                                                                                  
            shapes(oPos(2)) = tg.s.tgtShapeCode;                        
            % Fill trial row                                        
            trialRow(tg.s.triallistCols.trialType) = 2;
            trialRow(tg.s.triallistCols.nItemsBtwFeatures) = abs(diff(oPos))-1;
            trialRow(tg.s.triallistCols.tgtColorItemNum) = oPos(1);
            trialRow(tg.s.triallistCols.tgtShapeItemNum) = oPos(2);
            trialRow(tg.s.triallistCols.letterStringCode) = shapesNum;
            trialRow(tg.s.triallistCols.colorStringCode) = colorsNum;
            trialRow(tg.s.triallistCols.shapesStart:tg.s.triallistCols.shapesEnd) = shapes;
            trialRow(tg.s.triallistCols.colorsStart:tg.s.triallistCols.colorsEnd) = colors;                                                                                                                                       
            % add to trial pool
            basePoolBothPresentNonadj(end+1,:) = trialRow;            
        end        
    end    
end


%%%% color-only trials (trialType 3)

% order in color-only pool:
% 3 tgt color positions                   = blocks of 3 trials
% 4 color seq * 3 tgt col pos             = blocks of 12 trials
% 4 shape seq * 4 color seq * 3 tgt pos   = pool of 48 trials

basePoolColorOnly = [];               
possTgtColPositions = 2:4;     % sequence positions where target color may be placed
for shapesNum = 1:numel(stimShapeSequences)         
    % color sequences
    for colorsNum = 1:numel(stimColorSequences)
        % green O-positions
        for oPos = possTgtColPositions                        
            trialRow = [];
            % pick shape and color sequence
            shapes = stimShapeSequences{shapesNum};
            colors = stimColorSequences{colorsNum};                  
            % Place green            
            colors(oPos) = tg.s.tgtColorCode;                                                                                  
            % Fill trial row                                               
            trialRow(tg.s.triallistCols.trialType) = 3;
            trialRow(tg.s.triallistCols.nItemsBtwFeatures) = nan;
            trialRow(tg.s.triallistCols.tgtColorItemNum) = oPos;
            trialRow(tg.s.triallistCols.tgtShapeItemNum) = nan;
            trialRow(tg.s.triallistCols.letterStringCode) = shapesNum;
            trialRow(tg.s.triallistCols.colorStringCode) = colorsNum;
            trialRow(tg.s.triallistCols.shapesStart:tg.s.triallistCols.shapesEnd) = shapes;
            trialRow(tg.s.triallistCols.colorsStart:tg.s.triallistCols.colorsEnd) = colors;                                                                                                                                       
            % add to trial pool
            basePoolColorOnly(end+1,:) = trialRow;           
        end        
    end    
end

% In Hazeltine:
% - 3 blocks of 160 trials each * 2 days -> 3*2*160 = 960 trials in total 
% - per block:
%       50 % (80) target present trials (green and O in one item)
%       25 % (40) both-present trials   (green and O in different items)
%       25 % (40) color only trials     (green in one item, O absent)
%
% Thus, for the differet trials:
% - target present: take one letter string, one color string, put green O in
%   position 2,3,4 in 2/3 (of all trials). There are 4*4*3 = 48 combi-
%   nations. 80 such trials are needed in each block. There
%   are 6 blocks in total, so that 6*80 = 480 such trials are needed in
%   total; thus the set of target present trials needs to be repeated 10
%   times in total (take care to split them equally over blocks by making
%   an ordered list and dividing it into 80-trial batches).
% - both-present: take one letter string, one color string, place O in one
%   of the three center positions and green in the other (there are 6 of
%   them). There are 4*4*6 = 96 combinations (two thirds of which have the
%   two target features in adjacent positions), 40 are needed per block,
%   two thirds of which should have adjacent items. There are six blocks,
%   so a total of 6*40 = 240 are needed. 240/96 = 2.5. Need to find a
%   sensible split... Note: Check whether 2/3 need to be adjaent *within
%   each block*
% - color-only: take one letter string, one-color string. Color one of the
%   three center letters green . There are 4*4*3 = 48 combinations and 40
%   are needed per block. 6*40 = 240 in total. 240/48 = 5, so no problem.

% order in target present pool:
% 3 positions                             = blocks of 3 trials
% 4 color seq * 3 positions               = blocks of 12 trials
% 4 shape seq * 4 color seq * 3 positions = pool of 48 trials

% order in both-present pool:
% 6 position combinations (last four adj) = blocks of 6 trials
% 4 color seq * 6 position combinations   = blocks of 24 trials
% 4 shape seq * 4 color seq * 6 pos com.  = pool of 96 trials

% order in color-only pool:
% 3 tgt color positions                   = blocks of 3 trials
% 4 color seq * 3 tgt col pos             = blocks of 12 trials
% 4 shape seq * 4 color seq * 3 tgt pos   = pool of 48 trials

% - 3 blocks of 160 trials each * 2 days -> 3*2*160 = 960 trials in total 
% - per block:
%       50 % (80) target present trials (green and O in one item)
%       25 % (40) both-present trials   (green and O in different items)
%       25 % (40) color only trials     (green in one item, O absent)



poolTargetPresent = repmat(basePoolTargetPresent, 10, 1); % 480 
poolColorOnly = repmat(basePoolColorOnly, 5, 1); % 240 


% For both present 2.5 the total number of both present trials are needed.
% Thus first double number of trials in each subtype and then add half of
% each subtype, picked to distribute uniformly as far as possible
poolBothPresentAdj = repmat(basePoolBothPresentAdj, 2, 1); % 128
poolBothPresentNonadj = repmat(basePoolBothPresentNonadj, 2, 1); % 64

% Pick half of all indices into nonadj pool (the way this is done ensures
% balanced trial set) and add to pool

s = size(basePoolBothPresentNonadj, 1);
indSets = {[1,4,5,8],[2,3,6,7]};
rowInds = 1:size(basePoolBothPresentNonadj, 1);
shapeBatchSize = 8;
batches = mat2cell(rowInds,1, ones(1,s/shapeBatchSize)*shapeBatchSize);
useRows = [];
for batch = batches
    batch = batch{1};
    useRows = cat(2,useRows,batch(indSets{1}));
    indSets = circshift(indSets,1);    
end
% add to pool    
poolBothPresentNonadj = ...
    [poolBothPresentNonadj; basePoolBothPresentNonadj(useRows,:)];

% Pick half of all indices into adj pool (the way this is done ensures
% balanced trial set) and add to pool


s = size(basePoolBothPresentAdj, 1);
indSets = {[2,1],[3,1],[4,1],[3,2],[4,2],[4,3]};
rowInds = 1:size(basePoolBothPresentAdj, 1);
shapeBatchSize = 4;
batches = mat2cell(rowInds,1, ones(1,s/shapeBatchSize)*shapeBatchSize);
useRows = [];
for batch = batches
    batch = batch{1};
    useRows = cat(2,useRows,batch(indSets{1}));
    indSets = circshift(indSets,1);    
end
% add to pool    
poolBothPresentAdj = ...
    [poolBothPresentAdj; basePoolBothPresentAdj(useRows,:)];



% Now make blocks by drawing from pools without replacement
%       50 % (80) target present trials (green and O in one item)
%       25 % (40) both-present trials   (green and O in different items)
%       25 % (40) color only trials     (green in one item, O absent)

tp = poolTargetPresent;
bp_a = poolBothPresentAdj;
bp_n = poolBothPresentNonadj;
co = poolColorOnly;

shuffle = @(arr) arr(randperm(size(arr,1)),:);
tp = shuffle(tp);       
bp_a = shuffle(bp_a);
bp_n = shuffle(bp_n);
co = shuffle(co);

% accumulate triallist from pools, creating 6 similarly composed blocks
triallist = [];
tp_inds = 1:80;
co_inds = 1:40;
bp_a_inds = 1:27;
bp_n_inds = 1:13;
for b = 1:6

    % both present adjacent/non-adjacent cannot be fully balanced. This
    % takes care of it on the last block. See note below loop.
    if max(bp_a_inds) > size(bp_a,1)
        bp_a_inds = 1:size(bp_a,1);
        bp_n_inds = 1:(40-size(bp_a,1));
    end    
    
    % accumulate this block's trials            
    tmp = cat(1, ...
        tp(tp_inds,:), ...
        co(co_inds,:), ...
        bp_a(bp_a_inds,:), ...
        bp_n(bp_n_inds,:));
    
    % remove from pool
    tp(tp_inds,:) = [];
    co(co_inds,:) = [];
    bp_a(bp_a_inds,:) = [];
    bp_n(bp_n_inds,:) = [];
    
    % add block number        
    tmp(:, tg.s.triallistCols.block) = b;       
    
    triallist = cat(1, triallist, tmp);
    
end

% NOTE: In the last block (6) there both-present trials are 25 / 15
% adjacent / non-adjacent feature trials, in contrast to 27 / 13 in the
% other trials (full balancing not possible).





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


% add sequential numbers
triallist(:,tg.s.triallistCols.numberInUnshuffledTriallist) = 1:size(triallist,1);
          
tg.triallist = triallist;




save(trialFileSavePathName, 'tg')                     % ** DO NOT MODIFY **
% Remove common_functions from path                   % ** DO NOT MODIFY **
rmpath(genpath(pathToAdd))                            % ** DO NOT MODIFY **
catch                                                 % ** DO NOT MODIFY **
rmpath(genpath(pathToAdd))                            % ** DO NOT MODIFY **
end                                                   % ** DO NOT MODIFY **
