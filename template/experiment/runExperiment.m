%%%%%%%%%%%%%%%%%%%%%%%%%%%% Run experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         
% Run this file to execute the experiment. Do not modify this file.       
%                                                                          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
function runExperiment(resumeMode)  
if nargin == 0
    resumeMode = false;
end
try          
    % Add som e subdirectories (including subfold ers) of the current folder
    % to MATLAB path (will be removed again when the experiment ends).
    [expRootDir,~,~] = fileparts(mfilename('fullpath')); 
    subdirsToAdd = {'infrastructure', ...
                    'myParadigmDefinition', ...                    
                    'myCustomFiles', ...
                    'myTrialFiles'}; 
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
    errorDebug;   
    cleanUp;
    rethrow(ME) 
end 
