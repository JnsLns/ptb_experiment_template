
% preliminary ttest for times

useResCol = a.s.resCols.movementTime_pc;
%useResCol = a.s.resCols.reactionTime_pc;
%useResCol = a.s.resCols.responseTime_pc;
%useResCol = a.s.resCols.maxCurvature;

dataCond1 = a.byPts.res.avg(1,1,1:12);
dataCond1 = cellCollapse(dataCond1,a.s.ptsDim,1);
dataCond1 = dataCond1{1}(:,useResCol);

dataCond2 = a.byPts.res.avg(1,2,1:12);
dataCond2 = cellCollapse(dataCond2,a.s.ptsDim,1);
dataCond2 = dataCond2{1}(:,useResCol);


 [h, p, ci, stats] = ttest(dataCond1,dataCond2,'alpha',0.01)