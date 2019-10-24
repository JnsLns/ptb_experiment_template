
% Use this after running analysis script, with struct a in workspace, to
% visually examine indidividual trajectories. Define sets & intersections
% to look at specific trials.

% sets
nonCurved = a.rs(:,a.s.resCols.exceedsCurveThresh)  == 0;
curved = a.rs(:,a.s.resCols.exceedsCurveThresh)  == 1;
correct = a.rs(:,a.s.resCols.correct)  == 1;
incorrect = a.rs(:,a.s.resCols.correct)  == 0;
maxMTExceeded = a.rs(:,a.s.resCols.maxMTExceeded)  == 1;
maxMTNotExceeded = a.rs(:,a.s.resCols.maxMTExceeded)  == 0;

% intersect sets
%useRows = maxMTNotExceeded & curved;
useRows = maxMTNotExceeded & correct & nonCurved;

tmp_rs = a.rs(useRows,:);
tmp_tr = a.tr(useRows);

% sort trial list such that equivalent trials from different addItem conditions are 
% grouped together
[tmp_rs, newOrder] = sortrows(tmp_rs,[a.s.resCols.spt, a.s.resCols.tgtSlot, a.s.resCols.pair2VsRef1VsComSide, a.s.resCols.horzPosStart, a.s.resCols.additionalItemCondition]);
tmp_tr = tmp_tr(newOrder,1);

trajViewerTwoPair(tmp_tr,tmp_rs, [-a.s.presArea_mm(1)/2 a.s.presArea_mm(1)/2], [0 a.s.presArea_mm(2)],a.s.resCols,a.s.trajCols,a.s.sptStrings,0);