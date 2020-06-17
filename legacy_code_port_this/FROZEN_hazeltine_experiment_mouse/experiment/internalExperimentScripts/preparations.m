% Initialize results matrix
e.results = [];

% Psychtoolbox settings                       
PsychDefaultSetup(2);               % some default Psychtoolbox settings
Screen('Preference', 'VisualDebuglevel', 3); % suppress PTB splash screen

% Determine experimental screen
screens = Screen('Screens');        % get all connected screens
expScreen = max(screens);           % use last screen as stimulus display

% Load list of trials and settings from file
[e.s.trialsFileName, trialsPath] = uigetfile('*.mat', 'Select trial file.');
load([trialsPath, e.s.trialsFileName]);

% Get/store spatial configuration of experimental setup (serves as input
% to CRF/unit conversion functions)
tmp = get(expScreen,'ScreenSize');
e.s.expScreenSize_px = tmp(3:4);         % get screen res
e.s.spatialConfig.viewingDistance_mm = e.s.viewingDistance_mm;
e.s.spatialConfig.expScreenSize_mm = e.s.expScreenSize_mm;
e.s.spatialConfig.expScreenSize_px = e.s.expScreenSize_px;
% Default for presentation area extent: [0,0] = origin in screen center
if ~isfield(tg.s, 'presArea_va')
    pa = [0,0];
else
    pa = tg.s.presArea_va;
end
e.s.spatialConfig.presArea_va = pa;   

% copy experimental setup data (not trials) from trial generation struct
% (tg.s) to experimental output struct (e.s); except for tg.s.triallistCols
% which is dealt with below.
for fn = fieldnames(tg.s)'    
    if strcmp(fn{1}, 'triallistCols')
        continue; 
    end    
    if isfield(e.s, fn{1})
        error(['Field ', fn{1}, ' was about to be copied from tg.s', ...
            ' to e.s, but already exists in e.s']);
    end
    e.s.(fn{1}) = tg.s.(fn{1});    
end
 
% Request save path or warn in case saving is disabled
if doSave       
    % add experiment name field if not specified (postfixed to file name)
    if ~isfield(e.s, 'experimentName')        
        e.s.experimentName = '';
    end
    % Get path through user input
    savePath = requestSavePath(e.s.experimentName);
else
    resp = ...
    questdlg('Saving is disabled, results will not be recorded.', 'Warning', ...
                'Continue without saving','Abort', 2);
    if strcmp(resp, 'Abort')
        return
    end  
end

% Transfer trial data to variables that will be used throughout rest of code  
trials = tg.triallist;
triallistCols = tg.s.triallistCols;
clear tg; % tg won't be needed anymore

% In case blocks enabled, check that trials of different blocks are
% not mixed in the trial list.  If field not defined, create it and disable.
if ~isfield(e.s, 'useTrialBlocks')
    e.s.useTrialBlocks = false;
end
if e.s.useTrialBlocks
    blockNums = [rand(); trials(:, triallistCols.block)];
    uniqueBlockNums = unique(blockNums);
    if any(sum(abs(diff(blockNums == uniqueBlockNums'))) > 2)
        error('Found trials with shared block number in non-consecutive trial list rows!')
    end    
end
   
% shuffle trial order if desired (if field not defined, create & set to false)
% only within blocks if blocks enabled
if ~isfield(e.s, 'shuffleTrialOrder')
   e.s.shuffleTrialOrder = false; 
end
if e.s.shuffleTrialOrder            
    if e.s.useTrialBlocks
       blockNums = trials(:, triallistCols.block);
       uniqueBlockNums = unique(blockNums);
       for bn = uniqueBlockNums'
            indFirst = find(blockNums==bn, 1, 'first');
            indLast = find(blockNums==bn, 1, 'last');   
            block = trials(indFirst:indLast, :);
            block = block(randperm(size(block, 1)),:);            
            trials(indFirst:indLast, :) = block;
       end
    else 
       trials = trials(randperm(size(trials, 1)),:);            
    end        
end

% shuffle block order if desired (if trial blocking enabled but field not
% defined, create it and set to false)
if e.s.useTrialBlocks 
    if ~isfield(e.s, 'shuffleBlockOrder')
        e.s.shuffleBlockOrder = false;
    end
    if e.s.shuffleBlockOrder        
        uniqueBlockNums = unique(trials(:, triallistCols.block));
        nBlocks = numel(uniqueBlockNums);
        newBlockOrder = uniqueBlockNums(randperm(nBlocks));
        for curBlockNum = newBlockOrder' % TEST            
            curRows = trials(:, triallistCols.block) == curBlockNum;            
            trials = cat(1, trials, trials(curRows,:));
            trials(curRows, :) = [];
        end
    end
end

% In case 'e.s.breakBeforeBlockNumbers' is not defined, the default is to
% break before each block except before the first one.
if e.s.useTrialBlocks && ~isfield(e.s, 'breakBeforeBlockNumbers')        
    allBlockNumbers = unique(trials(:, triallistCols.block));
    firstBlockNumber = trials(1, triallistCols.block);      
    allBlockNumbers(allBlockNumbers == firstBlockNumber) = [];    
    e.s.breakBeforeBlockNumbers = allBlockNumbers;
end

% Default background color for all windows is gey (if not defined during
% trial generation)
if ~isfield(e.s, 'bgColor')
    e.s.bgColor = 'grey';
end

% Convert color-defining field in e.s from strings to RGB
colorDefinition;

% Hide mouse cursor
HideCursor;

% Construct e.s.resCols (holds column indices for 'e.results'. It is
% initialized here by transferring the indices from 'triallistCols', since
% on each trial not only results are stored in 'e.results', but also all
% trial properties).
createResCols;

% Preparation for the trial loop
curTrial = 1;
sequNum = 0;