%%%%%%%%%%%%%%%%%%%%%%%%%%%% Run experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         
% Run this file to execute the experiment. Do not modify this file.       
%                                                                          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%% %%%%%%%%%%%%%%%%%%
 
 
function runExperiment
try
    % Add some subdirectories (including subfolders) of the current folder
    % to MATLAB path (will be removed again when the experiment ends).
    [expRootDir,~,~] = fileparts(mfilename('fullpath'));
    subdirsToAdd = {'infrastructure', ...
                    'myParadigmDefinition', ...                    
                    'myCustomFiles'}; 
    pathsAdded = {};    
    for pNum = 1:numel(subdirsToAdd)  
        p = subdirsToAdd{pNum};
        p = fullfile(expRootDir, p); 
        withSubfolders = genpath(p);
        addpath(withSubfolders) 
        pathsAdded{pNum} = withSubfolders;  
    end    
    callExpComponentsInOrder; % this calls all experiment scripts in order.
catch ME
    cleanUp;
    rethrow(ME) 
end
