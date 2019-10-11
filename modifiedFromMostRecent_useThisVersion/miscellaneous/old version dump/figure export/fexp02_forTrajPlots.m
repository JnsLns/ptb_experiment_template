
clear

imgPath = 'd:\';
imgName = 'test2';
imgExt = '.pdf';
%Note: to change format, code below must be adjusted

%% Figure adjustments

%title ''
%suptitle('')
%set(gcf,'color','w')

hAll = get(gcf,'children');

% (needs font installed and may require re-adjustment of legend position)
% set(hAll,'FontSize',10,'linewidth',1) 
% set(hAll,'FontWeight','default') 
% set(hAll,'FontName','LM Roman 12');
% set(gca,'LabelFontSizeMultiplier',1.2);

% set(gca, 'XColor','k','YColor','k');
% set(hAll,'linewidth',1,'box','on');
set(gca,'TickLength',[0.01 0]) ;


%% First, save transparent patches separately

% all non-patch, non-figure, non-axis objects
hnop = findobj(gcf,'-not','type','patch','-not','type','figure','-not','type','axes'); 
% all patch objects 
hp = findobj(gcf,'type','patch'); 
set(hnop,'visible','off');
axis off
hold on
tmpLine = plot(get(gca,'xlim')',[0 0]); % line for placement
allPs = 1:numel(hp);
for i = 1:numel(hp)   
   set(hp(allPs~=i),'visible','off')
   print(gcf, '-dpdf',[imgPath,imgName,'_patch',num2str(i),imgExt]);    
   set(hp(allPs~=i),'visible','on')   
end
set(hnop,'visible','on');
axis on
delete(tmpLine) % line for placement


%% Then save rest of figure w/o patches

% patches
delete(hp);

export_fig([imgPath,imgName,imgExt],'-q100','-pdf','-CMYK');

