% Generate a list of trials to load and use in the experiment scripts.

try
% Add common_functions folder to MATLAB path temporarily 
% (will be removed at the end of this script)
% Allows using functions from that folder here.
% ** DO NOT MODIFY THIS **
[curFilePath,~,~] = fileparts(mfilename('fullpath'));
[pathstr, ~, ~] = fileparts(curFilePath);
dirs = regexp(pathstr, filesep, 'split');
pathToAdd = fullfile(dirs{1:end}, 'common_functions');
addpath(genpath(pathToAdd))


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

trialFileSavePathName = ''; % adjust this

% ** DO NOT MODIFY THIS **
save(trialFileSavePathName, 'tg')
% Remove common_functions folder from MATLAB path
rmpath(genpath(pathToAdd))
catch
rmpath(genpath(pathToAdd))
end
