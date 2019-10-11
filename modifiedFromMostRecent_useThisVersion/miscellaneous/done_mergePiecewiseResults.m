% This script merges two results file that are based on trials from one trial
% list that was completed in two steps due to the experiment being inter-
% rupted for some reason. (if this happened, undone trials were extracted 
% from the results file based on the partly completed result list and put into a
% new separate trial file, using done_identifyUndoneTrialsAndPutIntoNewList.m,
% which was then completed, producing the second file).
%
% After merging, the data in e.results and e.trajectories is in the order
% as trials were presented in the experiment. Also, trials in e.trial_main
% are sorted to conform to that order as well.
%
% Note that e.trials_main and tg.triallist in the first loaded file must
% contain the full set of trials from the original trials file (this should
% normally be the case automatically, as no changes are made to the data in 
% the first file by done_identifyUndoneTrialsAndPutIntoNewList.m). 
%
% note that trial order in tg.triallist saved in the final file may differ
% from that in the original trials file because some trials may have been
% aborted and skipped (and appended to end of triallist; this does not
% impact analyses, however, as it exclusively uses data from struct e)

% load first part (produced using original full trial file without
% completing it)
[lfile1, lpath1] = uigetfile('','load first file');
ld1 = load([lpath1,lfile1],'e','tg');
% load second part (produced using trial file generated by
% done_identifyUndoneTrialsAndPutIntoNewList.m used on the first results
% file, that is, holding only trials not completed in the first file.
[lfile2, lpath2] = uigetfile('','load second file');
ld2 = load([lpath2,lfile2],'e','tg');

e = ld1.e;
tg = ld1.tg;

% Concatenate file 1 results and file 2 results.
e.results = [e.results; ld2.e.results];
% Same for trajs
e.trajectories = [e.trajectories; ld2.e.trajectories];
% Remove empty cells in trajectory cell array
emptyCells = cellfun(@(et) isempty(et),e.trajectories);
e.trajectories(emptyCells) = [];

% Sort trials_main to conform with trial order in merged results matrix
[~,ind] = sortrows(e.results,e.s.resCols.trialID);
e.trials_main = sortrows(e.trials_main,tg.triallistCols.trialID);
e.trials_main(ind,:) = e.trials_main(1:end,:);

% save
[sfile, spath] = uiputfile('*.mat','Save',[lpath1,'xxx_results_main']);
save([spath,sfile],'e','tg'); 
