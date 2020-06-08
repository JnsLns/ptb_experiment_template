
%%%%% Run this file to execute the experiment.
%%%%% Do not modify this file.

%%%%%%%%%%%%%%%%%%%%% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function runExperiment
try
    % Add some subdirectories (including subfolders) of the current folder
    % to MATLAB path (will be removed again when the experiment ends).
    [curFilePath,~,~] = fileparts(mfilename('fullpath'));
    subdirsToAdd = {'internalExperimentScripts', ...
                    'paradigmDefinition', ...
                    'helperFunctions', ...
                    'customFiles'};
    pathsAdded = {};  
    for pNum = 1:numel(subdirsToAdd) 
        p = subdirsToAdd{pNum};
        p = fullfile(curFilePath, p);
        withSubfolders = genpath(p);
        addpath(withSubfolders)
        pathsAdded{pNum} = withSubfolders; 
    end
    % This script will call all experiment scripts in order.
    callExpComponentsInOrder;
catch ME
    cleanUp;
    rethrow(ME) 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%