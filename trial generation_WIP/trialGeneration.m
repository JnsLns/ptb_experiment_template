 


%%%% Fields of tg.s expected by the experimental script:

% Size and position measures are in degrees visual angle ('_va')
% unless fieldnames are postfixed with '_mm' (millimeters). All position
% data is in the presentaion-area-based coordinate frame.
 
tg.s.fixRadius_va = 1;   % Radius of fixation cross (visual angle)
tg.s.fixLineWidth_va = 0.2; % Line width of fixation cross (visual angle)
tg.s.fixColor = 'white';        % Color of fixation cross (rgb vec or string)
tg.s.presArea_va = [20, 15]; % horz/vert size of presentation angle in degrees visual angle
                          % (always centered within screen)
tg.s.startPosZ_mm = [];     % Distance of pointer tip starting position
                         % from screen surface (x and y are determined
                         % automatically as center of presentation are).
tg.s.startRadius_mm = 5;  % Radius around strating position in which pointer tip
                        % has to be situated to count as being on the starting position
tg.s.circleLineWidth_va;  % Line width of circle that indicates to the participant
                       % how far the pointer is from the strating
                       % position. in visual angle.
tg.s.durOnStart = 1;  % Time that pointer must dwell in starting position [s] before exp proceeds
tg.s.durWaitForStart = inf; % Time to wait for participant to assume strating position 
tg.s.durPreStimFixation = 1; % Time fixation cross is shown after starting position has been 
                      % assumed and before stimuli are presented 
tg.s.durItemPresentation = 0.15;  % Duration of stimulus presentation
tg.s.allowedLocResponseTime = 1.5;  % Max duration to make location response
tg.s.allowedTgtResponseTime = 1.5;  % Max duration to make tgt presence response
tg.s.zZeroTolerance_mm = 1;   % pointer's *absolute* z-value must be below this value
                        % for response to be registered (mm)
tg.s.pointerStartAngle = 15;   % max angle (deg) between lines from pointer tip
                           % to pointer markers and z-axis during start phase
tg.s.circleNotOkColor = 'white';  % color of start pos indicator circle when pointer is too far
tg.s.circleOkColor = 'black';     % color of start pos indicator circle when pointer is within
                                  % tg.s.startRadius_mm millimeters of starting position
tg.s.yesKeyName = 'return';      % name of yes-key for target present response
tg.s.noKeyName = '.';            % % name of no-key for target present response
tg.s.instructionTextFont = 'Arial'; % font for instruction test
tg.s.instructionTextHeight_va % font height in degrees visual angle
tg.s.instructionTextColor = 'black'; % color for instruction text (RGB triplet or string, see bgColor)
tg.s.bgColor = 'grey';  % background color (can be either an RGB triplet or one of the strings
                        % 'black', 'white', or 'grey'
tg.s.feedbackTextColor = 'black';    % color of feedback text
  
% cell array with letter specifications for function lineItem:
                                            
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
 
% stim color specification. color codes in triallist should correspond to
% element number in this array. 
% TODO: Adjust these to have the correct colors used by Hazeltine!
tg.s.stimColors{1} = [1 0 0]; % red
tg.s.stimColors{2} = [0 1 0]; % green
tg.s.stimColors{3} = [0 0 1]; % blue
tg.s.stimColors{4} = [1 1 0]; % yellow
tg.s.stimColors{5} = [0 0 0]; % black
tg.s.stimColors{6} = [1 1 1]; % white
 
% Feedback parameters:
tg.s.feedback.dur_nonAbort = 1; % duration of feedback if trial completed
tg.s.feedback.dur_abort = 1;  % duration of feedback if trial aborted
% feedback text
tg.s.feedback.correct = 'Richtig!';    
tg.s.feedback.incorrect = 'Falsch!'; 
tg.s.feedback.notMovedToStart = 'Startposition nicht rechtzeitig eingenommen';
tg.s.feedback.leftStartInFix = 'Bitte erst nach den Buchstaben';
tg.s.feedback.leftStartInStim = 'Bitte erst nach den Buchstaben';
tg.s.feedback.exceededLocRT = 'Ortsauswahl zu sp�t';
tg.s.feedback.exceededTgtRT = 'Reaktion zu sp�t';
 

%%%% Notes

% Regardless of the length of the number of elements covered by the
% above spans of columns, items can be left unspecified by putting nan in
% the stimShapes column.


%%%% Create tg.s.triallistCols (holds column numbers for triallist)

nItems = 5;
% Fields and number of columns for tg.s.triallistCols (struct holding column
% indices of trial matrix). .
triallistColsFields = ...
    { ...
    'trialID', 1; ...           % unique ID of this trial
    'trialSequNum', 1; ...      % sequential number in original trial list
    'trialType', 1; ...         % 1 = target present, 2 = both ftrs present, 3 = color only
    'nItemsBtwFeatures'; ...     % number of items between tgt shape and tgt color (0=tgt present, 1=neighboring, 2= one intermediate item, ...) 
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


%%%% stim color specification. color codes in triallist should correspond to
% element number in this array.
%
% TODO: Adjust to colors used in Hazeltine
stimColors{1} = [70 0 0]; % orange
stimColors{2} = [0 0 255]; % blue
stimColors{3} = [255 255 0]; % yellow
stimColors{4} = [100 0 100]; % purple
stimColors{5} = [100 100 100]; % gray
tgtColor = [0 255 0]; % green, corresponds to color code 0
tgtColorCode = 0;

% stim shape specification (for function lineItem)
stimShapes{1} = {[1,3,9]};             % 1  = L
stimShapes{2} = {[1,9],[3,7]};         % 2  = X
stimShapes{3} = {[4,6],[1,7],[3,9]};   % 3  = I
stimShapes{4} = {[1,3,5,9,7]};         % 4  = W
stimShapes{5} = {[7,1,3],[2,8]};       % 5  = F
stimShapes{6} = {[3,1,5,7,9]};         % 6  = M
stimShapes{7} = {[7,1,3,9],[2,8]};     % 7  = E
stimShapes{8} = {[1,3],[2,8],[7,9]};   % 8  = H
stimShapes{9} = {[1,6,7]};             % 9  = V
stimShapes{10} = {[1,7,3,9]};          % 10 = Z
stimShapes{11} = {[1,7],[4,6]};        % 11 = T
stimShapes{12} = {[1,5,7],[5,6]};      % 12 = Y
stimShapes{13} = {[3,1,9,7]};          % 13 = N
tgtShapeCode = 0;

presArea = [40, 28];
fixPos = [presArea./2];

stimRegionsWidth = 4.02;
stimRegionsHeight = 0.88;

% stim regions (stim string center will be placed within randomly).
% above fix cross:
stimRegions{1} = [fixPos(1) - stimRegionsWidth/2, ...  % left
                  fixPos(2) + 0.88, ...                % bottom                  
                  stimRegionsWidth, ...             % width
                  stimRegionsHeight];               % height              
% below fix cross:
stimRegions{2} = stimRegions{1};
stimRegions{2}(2) = fixPos(2) - (0.88 + stimRegionsHeight);


stimSize_xy = [0.54, 0.71];
stimSep_x = 0.94;

% refers to elements of stimShapes
% each of these sequences in 25 % of trials
stimShapeSequences{1} = [1,2,3,4,5];     % LXIWF
stimShapeSequences{2} = [6,7,8,9,10];    % MEHVZ
stimShapeSequences{3} = [8,11,12,1,13];  % HTYLN
stimShapeSequences{4} = [3,9,10,11,7];   % IVZTE

% refers to elements of stimColors
% each of these sequences in 25 % of trials
stimColorSequences{1} = [1,2,3,4,6];     % OBYPR
stimColorSequences{2} = [3,6,5,1,2];     % YRGOB
stimColorSequences{3} = [4,1,2,3,5];     % POBYG
stimColorSequences{4} = [1,6,4,2,5];     % ORPBG


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




%%%% target present trials

tgtPresentTriallist = [];   % List of all possible target present trials
                            % (i.e. all 48 combinations of 4 shape-sequence
                            % � 4 color sequence � 3 tgt slot)

possTgtPositions = 2:4;

% letter sequences
for shapesNum = 1:numel(stimShapeSequences)        
    
    % color sequences
    for colorsNum = 1:numel(stimColorSequences)

        % green O-positions
        for oPos = possTgtPositions
            
            shapes = stimShapeSequences{shapesNum};
            colors = stimShapeSequences{colorsNum};
                  
            % Place target
            shapes(oPos) = tgtShapeCode;                        
            colors(oPos) = tgtColorCode;                                                
                    
            trialRow = [];
                                                           
            trialRow(tg.s.triallistCols.trialType) = 1;
            trialRow(tg.s.triallistCols.nItemsBtwFeatures) = 0;
            trialRow(tg.s.triallistCols.tgtColorItemNum) = oPos;
            trialRow(tg.s.triallistCols.tgtShapeItemNum) = oPos;
            trialRow(tg.s.triallistCols.letterStringCode) = shapesNum;
            trialRow(tg.s.triallistCols.colorStringCode) = colorsNum;
            trialRow(tg.s.triallistCols.shapesStart:tg.s.triallistCols.shapesEnd) = shapes;
            trialRow(tg.s.triallistCols.colorsStart:tg.s.triallistCols.colorsEnd) = colors;                        
                                        
            tgtPresentTriallist(end+1,:) = trialRow;
            
        end
        
    end
    
end



%%%% both- present trials

bothPresentTriallist = [];  % List of all possible both-present trials
                            % (i.e. all 48 combinations of 4 shape-sequence
                            % � 4 color sequence � 3 tgt slot)

possTgtFtrPositions = 2:4;  



% I AM HERE!!!! BELOW CODE HAS TO BE ADJUSTED (was copied from above)

% letter sequences
for shapesNum = 1:numel(stimShapeSequences)        
    
    % color sequences
    for colorsNum = 1:numel(stimColorSequences)

        % green O-positions
        for oPos = possTgtPositions
            
            shapes = stimShapeSequences{shapesNum};
            colors = stimShapeSequences{colorsNum};
                  
            % Place target
            shapes(oPos) = tgtShapeCode;                        
            colors(oPos) = tgtColorCode;                                                
                    
            trialRow = [];
                                                           
            trialRow(tg.s.triallistCols.trialType) = 1;
            trialRow(tg.s.triallistCols.nItemsBtwFeatures) = 0;
            trialRow(tg.s.triallistCols.tgtColorItemNum) = oPos;
            trialRow(tg.s.triallistCols.tgtShapeItemNum) = oPos;
            trialRow(tg.s.triallistCols.letterStringCode) = shapesNum;
            trialRow(tg.s.triallistCols.colorStringCode) = colorsNum;
            trialRow(tg.s.triallistCols.shapesStart:tg.s.triallistCols.shapesEnd) = shapes;
            trialRow(tg.s.triallistCols.colorsStart:tg.s.triallistCols.colorsEnd) = colors;                        
                                        
            tgtPresentTriallist(end+1,:) = trialRow;
            
        end
        
    end
    
end



% add later for all trials together (these don't differ between conditions)
            %'trialID', 1; ...           % unique ID of this trial
            %'horzPos', nItems; ...      % horizontal item center positions
            %'vertPos', nItems; ...      % vertical item center positions
            %'horzSizes', nItems; ...    % horizontal item extent
            %'vertSizes', nItems; ...    % vertical item extent                        
            %'lineWidths', nItems ...    % item line widths

% add this only after shuffeling:
            %'trialSequNum', 1; ...      % sequential number in original trial list                                                        












