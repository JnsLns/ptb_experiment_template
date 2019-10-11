
% click on axis with overall mean line
oaline = findobj(gca,'type','line');
set(oaline,'linestyle',':','color',[.5 .5 .5])

% click on axis the line should be copied to
copyobj(oaline,gca)




% tmp = findobj(gca,'type','line');
% delete(tmp(1))


%% Remove axes labels and tick labels
set(gca, 'XTickLabel','')
set(gca, 'YTickLabel','')
ylabel(gca,'')
xlabel(gca,'')


%% get size and copy to all figures

desPos = get(gcf,'position');

set(findobj(0,'type','figure'),'position',desPos);

set(gcf,'position',desPos)


