    
% this is pretty hacked... worked the last time I used it, though. Use
% thisfor plotting screen setup figures... 

% run this first, then strg+c when suitable trial found, then use code
% below...
trajViewerComparison_temp(tr,rs,[0 expScreenSize(3)],[0 expScreenSize(4)], ...
        tr, rs,[-screen_mm(1)/2 screen_mm(1)/2],[0 screen_mm(2)], ...
        resCols,trajCols,sptStrings,[1 0],1,pxPerMm);



hold on;


array_pos_tmp = array_pos%./pxPerMm;
array_pos_tmp(2) = expScreenSize(4)/pxPerMm(2)-array_pos_tmp(2);


mdfch_mm = maxDistFromCenterHorz_all/pxPerMm(1);
mdfcv_mm = maxDistFromCenterVert_all/pxPerMm(2);
stimRgn = rectangle('position',[array_pos_tmp(1)-mdfch_mm, array_pos_tmp(2)-mdfcv_mm, mdfch_mm*2, mdfcv_mm*2],'linewidth',2)

% Start marker
%start_pos_tmp(2) = expScreenSize(4)/pxPerMm(2)-start_pos(2);
start_r_tmp = start_r/mean(pxPerMm);
start_pos_tmp(1) = start_pos(1);
start_pos_tmp(2) = screen_mm(2)-start_pos(2);

ylim([0 screen_mm(2)])
xlim([0 screen_mm(1)])
box on

smar = rectangle('position',[start_pos_tmp(1)-start_r_tmp, start_pos_tmp(2)-start_r_tmp, start_r_tmp*2, start_r_tmp*2],'facecolor','k','Curvature',[1 1]);
% NOTE HACKED TARGET SLOT COORDINATES (WORKS AS LONG AS NUMBERING IRRELVANT)
ts = [100,-100; -100, 100; -100, -100; 100, 100]./repmat(pxPerMm,size(tgtSlots_xy,1),1) + repmat(array_pos_tmp,size(tgtSlots_xy,1),1);
%ts(:,2) = (expScreenSize(4)/pxPerMm(2)-ts(:,2));

hold on
tsplot = plot(ts(:,1),ts(:,2),'x','markersize',25,'markeredgecolor','k');
uistack(tsplot, 'bottom')

% hide buttons
hButtons = findobj(gcf,'Type','uicontrol');
delete(hButtons);

% save figure
savefig('D:\docrepos\cogsci2017\figures\source\trialgen\screenSetupID667.fig');

