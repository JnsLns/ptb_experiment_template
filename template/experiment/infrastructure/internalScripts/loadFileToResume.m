% If resume mode is active, ask for incomplete result file to finish and
% load relevant variables from it. Note that this happens in the very
% beginning, meaning that any content of what is loaded here can be
% overwritten by subsequent assignments. E.g., settings specified in 'e.s'
% subsequently will override what's stored in the loaded 'e.s' (and that is
% intended).

if resumeMode
    
    [incompleteFileName, incompleteFilePath] = ...
        uigetfile('*.incomplete', 'Select incomplete result file.', ...
        fullfile(expRootDir, 'results', 'select incomplete result file'));
    load(fullfile(incompleteFilePath, incompleteFileName), '-mat', ...
        'e', 'triallist', 'resumeAtTrialNumber');
    
end