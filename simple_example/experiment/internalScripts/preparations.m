
% Psychtoolbox settings                       
PsychDefaultSetup(2);               % some default Psychtoolbox settings
Screen('Preference', 'VisualDebuglevel', 3); % suppress PTB splash screen

% Determine experimental screen
screens = Screen('Screens');        % get all connected screens
if ~exist('useScreenNumber', 'var') || isempty(useScreenNumber)
    useScreenNumber = max(screens); % use last screen as stimulus display
end

% Load list of trials and settings from file
[e.s.trialsFileName, trialsPath] = uigetfile('*.mat', 'Select trial file.');
load([trialsPath, e.s.trialsFileName]);

% Get/store spatial configuration of experimental setup (serves as input
% to CRF/unit conversion functions)
tmp = get(useScreenNumber, 'ScreenSize');
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
% (tg.s) to experimental output struct (e.s)
overrideWarningHasFired = false;
for fn = fieldnames(tg.s)'           
    % throw error if field already exists in 'e.s.', but only if that
    % behavior is not overridden for debugging. If overridden, warn once.
    if isfield(e.s, fn{1})        
        if ~isfield(e.s, 'expScriptSettingsOverrideTrialGenSettings') || ...
                e.s.expScriptSettingsOverrideTrialGenSettings == false            
            error(['Field ', fn{1}, ' was about to be copied from tg.s', ...
                ' to e.s, but already exists in e.s']);            
        else            
            if ~overrideWarningHasFired
                warndlg(['Note that ''e.s.expScriptSettingsOverrideTrialGenSettings'' is ', ...
                    'true, which is intended for testing and debugging. It means ', ...
                    'that any fields in struct ''e.s'' that are defined in the ', ...
                    'experimental scripts override the values of fields with the ', ...
                    'same name in struct ''tg.s'' (from trial generation) instead ', ...
                    'of throwing an error. This should be remedied before running ', ...
                    'the final experiment.'])
                overrideWarningHasFired = true;
            end  
            continue; % use value that is already in 'e.s'
        end        
    end     
    % copy over
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
clear tg; % tg won't be needed anymore

% In case blocks enabled, check that trials of different blocks are
% not mixed in the trial list.  If field not defined, create it and disable.
if ~isfield(e.s, 'useTrialBlocks')
    e.s.useTrialBlocks = false;
end
if e.s.useTrialBlocks
    blockNums = [rand(); trials.block];            
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
       blockNums = trials.block;
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
        uniqueBlockNums = unique(trials.block);
        nBlocks = numel(uniqueBlockNums);
        newBlockOrder = uniqueBlockNums(randperm(nBlocks));
        for curBlockNum = newBlockOrder' % TEST            
            curRows = trials.block == curBlockNum;            
            trials = cat(1, trials, trials(curRows,:));
            trials(curRows, :) = [];
        end
    end
end

% In case 'e.s.breakBeforeBlockNumbers' is not defined, the default is to
% break before each block except before the first one.
if e.s.useTrialBlocks && ~isfield(e.s, 'breakBeforeBlockNumbers')        
    allBlockNumbers = unique(trials.block);    
    firstBlockNumber = trials.block(1);
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

% Define anonymous function getMouseRM for getting remapped mouse position,
% if desired mouse screen-desk-ratio was defined during trial generation.
if isfield(e.s, 'desiredMouseScreenToDeskRatioXY')
    % make sure raw ratio is defined as well
    if ~isfield(e.s, 'rawMouseScreenToDeskRatio') || isnan(e.s.rawMouseScreenToDeskRatio)
        error(['When tg.s.desiredMouseScreenToDeskRatioXY is set in trial ', ...
            'generation (which is the case), then e.s.rawMouseScreenToDeskRatio ',...
            'must be defined in generalSettings.m (which is not the case).']);
    end        
    getMouseRM = @() getMouseRemapped(e.s.rawMouseScreenToDeskRatio, ...
        e.s.desiredMouseScreenToDeskRatioXY, ...
        e.s.spatialConfig);  
elseif isfield(e.s, 'rawMouseScreenToDeskRatio')
    e.s = rmfield(e.s, 'rawMouseScreenToDeskRatio'); % unneeded in this case
end


% Preparation for the trial loop
curTrial = 1;
sequNum = 0;