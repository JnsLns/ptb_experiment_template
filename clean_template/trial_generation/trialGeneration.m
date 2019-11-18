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
%                       property. Trials will be presented in row order
%                       (top to bottom). Actual presentation order may be
%                       affected, however, if you set trials to be repeated
%                       in 'runTrial.m' (see documentation there).
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

trialFileSavePathName = ''; % adjust this to desired save path 




save(trialFileSavePathName, 'tg')                     % ** DO NOT MODIFY **
% Remove common_functions from path                   % ** DO NOT MODIFY **
rmpath(genpath(pathToAdd))                            % ** DO NOT MODIFY **
catch                                                 % ** DO NOT MODIFY **
rmpath(genpath(pathToAdd))                            % ** DO NOT MODIFY **
end                                                   % ** DO NOT MODIFY **
