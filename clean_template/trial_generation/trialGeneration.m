% Generate a list of trials to load and use in the experiment scripts.

try                                                   % ** DO NOT MODIFY **
% Add common_functions folder to MATLAB path          % ** DO NOT MODIFY **
% temporarily (will be removed at the end of this     % ** DO NOT MODIFY **
% script) Allows using functions from that folder.    % ** DO NOT MODIFY **
[curFilePath,~,~] = fileparts(mfilename('fullpath')); % ** DO NOT MODIFY **
[pathstr, ~, ~] = fileparts(curFilePath);             % ** DO NOT MODIFY **  
dirs = regexp(pathstr, filesep, 'split');             % ** DO NOT MODIFY **  
pathToAdd = fullfile(dirs{1:end}, 'common_functions');% ** DO NOT MODIFY **
addpath(genpath(pathToAdd))                           % ** DO NOT MODIFY **




% Construct struct 'tg' here. It must have the following fields:
%
% 'tg.s'                With one sub-field for any non-trial-specific
%                       setting you wish to use in your experiment code.
% 'tg.triallist'        Matrix where each row specifies the properties of
%                       one trial and each column corresponds to one
%                       property. If tg.s.shuffleTrialOrder (see below) is
%                       false, trials will be presented in the row order of
%                       this list (top to bottom). If tg.s.shuffleTrialOrder
%                       is true, the list will be randomly shuffled at the
%                       start of the experiment script. Also note that the
%                       actual order of trials may be affected if you set
%                       aborted trials to be repeated in 'runTrial.m' which
%                       is part of the experimental code (see documentation
%                       there).
% 'tg.s.triallistCols'  Struct with one sub-field for each column of
%                       'tg.triallist'(or two sub-fields for a span of
%                       columns). Each field holds a column number. Allows
%                       addressing into the trial list "by name" within the 
%                       experiment scripts (instead of by column number).
% 'tg.s.experimentName' String that identifies your experiment; will be
%                       appended to results files in the experiment.
% 'tg.s.presArea_va'    Two-element row vectors, specifying horizontal /
%                       vertical extent of presentation area in degrees
%                       visual angle.
% 'tg.s.bgColor'        Background color of onscreen window (RGB vector,
%                       0-1; or one of the strings 'black', 'grey', 'white')
% 'tg.s.instructionTextFont'    Font used when drawing text to onscreen
%                               window (e.g., 'Arial')
% 'tg.s.instructionTextHeight_va'   Font height for onscreen window in
%                                   degrees visual angle.
% 'tg.s.shuffleTrialOrder'   If true, the order of trials in the triallist
%                            loaded from the file generated here is
%                            shuffled in the experimental script before
%                            presenting them to the participant (so that
%                            the order created here is changed!). Note that 
%                            if blocks are used (tg.s.useTrialBlocks),
%                            shuffling will occur only within blocks.
% 'tg.s.useTrialBlocks' If false, no particular effect; if true: pause
%                       between blocks, shuffle only within blocks, place
%                       to-be-repeated trials only within same block.
%                       Details:
%                       If true, a field tg.s.triallistCols.block is
%                       expected, and a corresponding column in tg.triallist.
%                       This column should list a block number for each
%                       trial; trials belonging to the same block must be
%                       in consecutive rows in tg.triallist. Effects:
%                       (1) if shuffling is enabled (see above), it will
%                       only affect trial order within blocks.
%                       (2) if aborted trials are set to be repeated, they
%                       will be moved to somewhere within the remainder of
%                       the block they belong to.
%                       (3) a break will occur between blocks during the
%                       experiment.
% 'tg.s.breakBetweenBlocks'  If false, does nothing. If true, code in
%                            blockBreak.m (part of the experimental
%                            script) is executed before each block of
%                            trials. Only comes to effect if
%                            e.s.useTrialBlocks is also true. A new block
%                            is detected as a change of numbers in column
%                            'triallistCols.block' of 'trials'.



trialFileSavePathName = ''; % adjust this to desired save path 




save(trialFileSavePathName, 'tg')                     % ** DO NOT MODIFY **
% Remove common_functions from path                   % ** DO NOT MODIFY **
rmpath(genpath(pathToAdd))                            % ** DO NOT MODIFY **
catch                                                 % ** DO NOT MODIFY **
rmpath(genpath(pathToAdd))                            % ** DO NOT MODIFY **
end                                                   % ** DO NOT MODIFY **
