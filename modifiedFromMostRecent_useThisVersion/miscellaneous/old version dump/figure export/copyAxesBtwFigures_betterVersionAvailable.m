
% delete suptitle axes in all figures
tmp = findobj(gcf,'type','axes');
delete(tmp(2))

% resize all axes in hiehgt to fit figure


% ---click on a figure with one axis of the desired position
f = gcf;
axPos = get(gca,'position');

% copy figure
f_copy = copyobj(f,0);

% delete all axes in figure
f_copy_axes = findobj(f_copy,'type','axes');
delete(f_copy_axes);

% ---click on subplot axis that should be moved into new figure
f_source = gcf;
ax_source = gca;
legends = findobj(f_source,'type','legend'); 
% Find legend handle associated with copied axis
tmpLgs = get(legends,'axes') ;
for lgNum = 1:numel(tmpLgs)
if tmpLgs{lgNum} == ax_source
break
end
end

% Copy axes along with its legend
ax_copy = copyobj([ax_source,legends(lgNum)],f_copy);

% change to same position as axes in source figure
set(ax_copy(1),'position',axPos)




