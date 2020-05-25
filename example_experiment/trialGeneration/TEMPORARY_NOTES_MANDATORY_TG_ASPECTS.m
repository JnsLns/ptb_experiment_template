
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Settings   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Note: Size and position measures are in degrees visual angle ('_va')
% unless fieldnames are postfixed with '_mm' (millimeters). All position
% data is in the presentation-area-based coordinate frame.


%%%% Reserved field names in struct 'tg.s' (detailed documentation below)

% It is optional to define these fields, default behavior is indicated below.
% IF they are defined, however, use them only for the intended functionality! 

tg.s.experimentName = 'my_experiment'; % Will be appended to results file name                                   
                                       % Default if undefined: ''                                       
tg.s.useTrialBlocks = true;            % Run 's5a_blockBreak.m' btw. blocks                                       
                                       % Default if undefined: false
                                       % See Readme.md for details.
tg.s.shuffleTrialOrder = true;         % Shuffle trials (within blocks) at
                                       % start of experiment
                                       % Default if undefined: false
                                       % See Readme.md for details.
tg.s.shuffleTrialOrder = true;         % Shuffle blocks at start of experiment
                                       % Default if undefined: false
                                       % See Readme.md for details.                                       

tg.s.presArea_va = [40, 30];        % [horizontal, vertical] extent of
                                    % presentation area [°visual angle]
                                    % Default if undefined: [0, 0] (i.e., 
                                    % the coordinate origin will be in the
                                    % screen center).
                                    % See Readme.md                                          
                                    
tg.s.onscreenWindowTextFont = 'Arial';    % Default font for onscreen window. 
                                          % Default if undefined: 'Arial'
tg.s.onscreenWindowTextHeight_va = 0.75;  % Default font height for onscreen 
                                          % window [°visual angle]
                                          % Default if undefined: 0.75°
tg.s.bgColor = 'grey';              % default background color for all
                                    % Psychtoolbox windows; either an
                                    % RGB triplet or one of the strings
                                    % 'black', 'white', or 'grey'. Default
                                    % if undefined: 'grey'.                                    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% I AM HERE  %%%%%%%%%%%%                  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% ONLY NEEDED IF USING getMouseRemapped
tg.s.mouseMovementMultiplier = [1 1]; % Mouse movement speed multiplier for
                                      % each dimension (horz, vert).
                                      % Will be applied to raw mouse input.
                                      % How mouse movement speed on the
                                      % desk maps to cursor movement speed
                                      % on the screen is determined by
                                      % the interplay of this setting and
                                      % mouse system settings.                                                                                                                                                                                                                                   
                                    
                                    
% NOT STRICTLY NECESSARY BUT USEFUL IF USING MOUSE (used in
% drawStaticGraphics)
tg.s.startMarkerColor = 'black';    % Color of dot at mouse starting position
tg.s.startMarkerRad_va = 0.2;       % Radius of start dot [°visual angle]
tg.s.startRadius_va = 0.2;          % Radius around stating position in
                                    % which mouse pointer is considered as
                                    % being on the starting position

% NOT STRICTLY NECESSARY BUT USEFUL IF USING MOUSE (used in
% oneTrial)
tg.s.cursorColor = 'white';         % Mouse pointer color
tg.s.cursorRad_va = 0.1;            % Radius of mouse cursor [°visual angle]

% note: think about making a mouse cursor plot function... 

% NOT STRICTLY NECESSARY BUT USEFUL IF USING FIXCROSS (used in
% oneTrial)
tg.s.fixRadius_va = 0.5;            % Radius of fixation cross [°visual angle]
tg.s.fixLineWidth_va = 0.1;         % Line width of fixation cross [°visual angle]
tg.s.fixColor = 'white';            % Color of fixation cross
tg.s.fixPos_va = tg.s.presArea_va./2; % fix cross position in pres. area
                                      % [°visual angle]

% note: think about making a fixcross plot function...


    
         
%%% Define instructions and breaks before blocks                                    

tg.s.breakBeforeBlockNumbers = 1:9; % blockBreak.m will be executed before
                                    % these blocks. Numbers correspond to
                                    % the value in column tg.s.triallistCols.block
                                    % within triallist. When this number 
                                    % changes from one block to the next, 
                                    % blockBreak.m will be executed. Must
                                    % be a row vector of integers.

                                

                
                                                                                                                                                                       
                

 
%%% TODO: CHECK WHAT ASPECTS OF TRIALLISTCOLS ARE MANDATORY

% Fields and number of columns for tg.s.triallistCols (struct holding column
% indices of trial matrix). 

triallistColsFields = ...
    {'trialID', 1; ...           % unique ID of this trial
    'block', 1; ...              % block number
    'isPractice', 1; ...         % 1 for practice trials, 0 for 
                                 % experimental trials.
    'numberInUnshuffledTriallist', 1; ...  % sequential number in original trial list
    'trialType', 1; ...         % 1 = target present, 2 = both ftrs present, 3 = color only
    'nItemsBtwFeatures', 1; ... % number of items between tgt shape and tgt
                                % color (0=tgt present, 1=neighboring, 2=
                                % one intermediate item, ...) 
    'tgtColorItemNum', 1; ...   % number of item in target color 
    'tgtShapeItemNum', 1; ...   % number of item with target shape    
    'letterStringCode', 1; ...  % letter string code (index into tg.s.stimShapes)
    'colorStringCode', 1; ...   % color string code (index into tg.s.stimColors)
    'horzPos', nItems; ...      % horizontal item center positions
    'vertPos', nItems; ...      % vertical item center positions    
    'horzSizes', nItems; ...    % horizontal item extent 
    'vertSizes', nItems; ...    % vertical item extent 
    'shapes', nItems; ...       % item shape identity codes (index into tg.s.stimShapes)
    'colors', nItems; ...       % item color codes (index into tg.s.stimColors)
    'lineWidths', nItems; ...   % item line widths  
    'stimDuration', 1 ...       % presentation time for stimuli
    };

%%%% Create struct 'tg.s.triallistCols' from triallistColsFields

tg.s.triallistCols = struct;
for row = 1:size(triallistColsFields, 1)
    fName = triallistColsFields{row, 1};
    nCols = triallistColsFields{row, 2};
    tg.s.triallistCols = colStruct(fName, nCols, tg.s.triallistCols);
end















% TODO: NOT MANDATORY BUT BEST PRACTICE...
%...          
%%%% create unique ID for current trial
trialID = round(rand()* 1e+12);
while any(triallist(:, tg.s.triallistCols.trialID) == trialID)
    trialID = round(rand()* 1e+12);
end
triallist(curRow, tg.s.triallistCols.trialID) = trialID;
%...
% add sequential numbers
triallist(:,tg.s.triallistCols.numberInUnshuffledTriallist) = 1:size(triallist,1);
   

%%%% SAVE HERE

tg.triallist = triallist(1:nTotalTrials_day1, :);
save(['day1_' trialFileSavePathName], 'tg')                   






% Remove common_functions from path                   % ** DO NOT MODIFY **
rmpath(genpath(pathToAdd))                            % ** DO NOT MODIFY **
catch ME                                              % ** DO NOT MODIFY **
rmpath(genpath(pathToAdd))                            % ** DO NOT MODIFY **
rethrow(ME)
end                                                   % ** DO NOT MODIFY **
