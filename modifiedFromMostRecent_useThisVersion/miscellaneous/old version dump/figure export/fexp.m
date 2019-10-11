axis off
axis on

title ''
suptitle('')

set(gcf,'color','w')

hAll = get(gcf,'children');

set(hAll,'FontSize',10,'linewidth',1) 
set(hAll,'FontWeight','default') 
set(hAll,'FontName','LM Roman 12');
set(gca,'LabelFontSizeMultiplier',1.2);

xlabel 'Distance From Reference [mm]'
ylabel 'Distance From Reference [mm]'
xlabel 'Vertical Screen Coordinates [mm]'
ylabel 'Horizontal Screen Coordinates [mm]'


set(gca, 'XColor','k','YColor','k');
set(hAll,'linewidth',1,'box','on');
set(gca,'TickLength',[0.01 0]) ;
%set(hAll,'TickDir','in') ;

%set(hAll(2), 'XColor','k','YColor','k');

imgPath = 'd:\docRepos\cogsci2017\figures\source\trialgen\';
imgName = 'resultsTest';
imgExt = '.pdf';

% patches
hp = findobj(gcf,'type','patch'); 

set(hp,'visible','off')
delete(hp)

export_fig([imgPath,imgName,imgExt],'-q100','-pdf','-CMYK');


set(hp,'visible','on')



% X axis tick
% set(gca,'XTick',[-60:20:60])
%hColbar = findobj(findobj(gcf,'Type','Colorbar'));
%set(hColbar,'ytick',[0:0.1:1])
%ylabel(hCb,'');


%% EXPORT FOR BAR CHARTS
imgPath = 'd:\docRepos\cogsci2017\figures\source\results\exported\inOrderOfPlacement_withKinematicLine_andInSize\';
imgName = '08b';
imgExt = '.pdf';

hAll = get(gcf,'children');

set(hAll,'FontSize',10,'linewidth',1) 
set(hAll,'FontWeight','default') 
set(hAll,'FontName','LM Roman 12');
set(gca,'LabelFontSizeMultiplier',1.2);
set(gca, 'XColor','k','YColor','k');
set(hAll,'linewidth',1,'box','on');
set(gca,'TickLength',[0.01 0]) ;

export_fig([imgPath,imgName,imgExt],'-q100','-pdf','-CMYK');




