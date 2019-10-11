
% This script loads a results file, determines undone trials which are in
% the triallist (stored alongside the results) but not in the results list,
% removes overlapping trials from the triallist, and saves this new
% triallist in a separate trials file. The output file can be used just
% as a regular trials file to complete the triallist. (Results files can
% later be merged using done_mergePiecewiseResults.m)

% load result file with some undone trials
[lfile, lpath] = uigetfile();
load([lpath,lfile]);

% Get IDs of trial in results matrix (done)
doneIDs_row = e.results(:,e.s.resCols.trialID)';

% Get IDs of all trials in trial list
triallistIDs_col = tg.triallist(:,tg.triallistCols.trialID);

% determine row indices of undone trials in triallist
triallistUndoneIDsRows_logical = ~any(repmat(triallistIDs_col,1,size(doneIDs_row,2)) == repmat(doneIDs_row,size(triallistIDs_col,1),1),2);

% apply to triallist
tg.triallist = tg.triallist(triallistUndoneIDsRows_logical,:);

% save to new trial file
doOverwrite = 0;
while 1    
    if ~doOverwrite
    [sfile, spath] = uiputfile();        
    end
    if ~exist([spath,sfile],'file') || doOverwrite
        save([spath,sfile],'tg','-mat');
        break
    else
        usrch = questdlg('File already exists. Overwrite?','Yes','No');
        if strcmp('Yes',usrch)
            doOverwrite = 1;
        end
    end    
end