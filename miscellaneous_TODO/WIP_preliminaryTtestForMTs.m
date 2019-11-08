
% preliminary code for movement time paired sample t-tests

mts = cellCollapse(a.byPts.res.avg,a.s.ptsDim,1);
mts = cellfun(@(mtCell)  mtCell(:,a.s.resCols.movementTime_pc),mts,'uniformoutput',0);

% adjust indexing here to compare different cell means
mts_a = mts{1,1};
mts_b = mts{3,1};
%mts_a = mts{1,1};
%mts_b = mts{1,2};

[h_mt, p_mt, ci_mt, stats_mt] = ttest(mts_a,mts_b,'alpha',0.05);

dz = abs(mean(mts_a-mts_b)/std(mts_a-mts_b));

% Make string stating details of t-test
tstr = ['$t(', num2str(stats_mt.df), ')=', num2str(round(stats_mt.tstat,3)), '$, $\p{}=', num2str(p_mt), '$, $d_z=' num2str(dz), '$,', char(10)  ...
        'mean difference ', '\SI{',num2str(round(mean(mts_a-mts_b)*1000,1)), '}{}', '$\pm$', ...
        '\SI{',num2str(round(std(mts_a-mts_b)*1000,1)), '}{\milli\second}'];   
    
% Write text to current axes    
text(.5,1,tstr,'Units','normalized') 
    
%num2str(mean(mts_a)), 's ', char(177),' ', num2str(std(mts_a)), ' versus ', num2str(mean(mts_b)), 's ', char(177),' ', num2str(std(mts_b))]

