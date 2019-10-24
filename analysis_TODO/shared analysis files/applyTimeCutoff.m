% This script (1) finds trajectories whose duration (first to last data
% point) is shorter than a.s.tCutoff and removes these from all row sets (i.e.,
% from all remaining analyses), (2) removes data beyond that cutoff from
% all other trajectories (note that the time stamp for each last data point,
% i.e., the one closest to a.s.tCutoff, us changed to to a.s.tCutoff,
% which introduces a tiny imprecision in the last data points).
% This script is meant to be used with time-aligned interpolation, so that
% all time points in mean trajectory data are based on the same number of
% trajectories (otherwise later portions of the mean trajectories are based
% on less and less data).
%
% CAUTIONARY NOTE: Unlike the other scripts, this one changes a.tr directly,
% that is, the data on which all following scripts draw, and the change
% cannot be reversed without reloading or re-preprocessing the data.

if a.s.doApplyTimeCutoff
    
    % Logical col vector holding indicating all trials set to one in any sow set
    allUsedTrials = sum(cell2mat(a.s.rowSets(:)'),2)>0;
    % Get shortest movement time from all used trials
    %trTmp = a.tr(allUsedTrials);
    %rsTmp = a.rs(allUsedTrials,:);
    
    % all movement times
    allMT = cellfun(@(trtmp) trtmp(end,a.s.trajCols.t)-trtmp(1,a.s.trajCols.t),a.tr);
    % those below cutoff
    belowCutoff = allMT < a.s.tCutoff;
    
    % remove these from all rowsets
    a.s.rowSets = cellfun(@(rowSet)  rowSet & ~belowCutoff,a.s.rowSets,'uniformoutput',0);
    
    disp([num2str(sum(belowCutoff)) ' trajectories dicarded bue to being below MT cutoff.']);
    
    % trim to cutoff (only those above thresh)
    for curTr = 1:numel(a.tr)
        if belowCutoff(curTr)
            continue
        end
        cutoff_lind = find((abs(a.tr{curTr}(:,a.s.trajCols.t)-a.s.tCutoff) == min(abs(a.tr{curTr}(:,a.s.trajCols.t)-a.s.tCutoff))));
        a.tr{curTr} = a.tr{curTr}(1:cutoff_lind,:);
        a.tr{curTr}(end,a.s.trajCols.t) = a.s.tCutoff;
    end
    
    % override pad setting
    a.s.padAlignedToLength = a.s.tCutoff/a.s.samplingPeriodForInterp+1;
    
    clearvars -except a e tg aTmp
    
end