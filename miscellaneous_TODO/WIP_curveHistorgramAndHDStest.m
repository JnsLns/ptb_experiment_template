
% only correct
responseSet = (a.rs((a.rs(:,a.s.resCols.correct)==1),a.s.resCols.maxCurvature));
nKept = sum(responseSet<=a.s.curvatureCutoff);
nDiscarded = sum(responseSet>a.s.curvatureCutoff);
percKept = nKept/(nKept+nDiscarded)*100;
percDiscarded = nDiscarded/(nKept+nDiscarded)*100;

figure; 
hh = histogram(responseSet,100);

delete(findobj(gca,'tag','threshMark'))
curYLims = get(gca,'ylim');
curXLims = get(gca,'xlim');
line([a.s.curvatureCutoff,a.s.curvatureCutoff],curYLims,'tag','threshMark','color','k','linestyle',':','linewidth',2);

[dip, pVal] = HartigansDipSignifTest(responseSet,100);
text(0.05,0.8,...
    ['--Across pts, including all correct responses--', char(10), ...
     'HDS p-value: ', num2str(pVal), char(10), ...
     'dip: ', num2str(dip), char(10), ...
     'total correct: ' num2str(numel(responseSet)), char(10) ...
     'included: ', num2str(nKept), ' (' num2str(percKept), '%)', char(10)...
     'excluded: ', num2str(nDiscarded), ' (' num2str(percDiscarded), '%)'],...
     'units','normalized');

 set(hh, 'edgecolor', 'none', 'facecolor','b')
 
 xlabel('max. curvature');