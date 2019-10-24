%% Make figure titles by checking included values etc. for each IV and 
% concatenating to single string.

% only zeros in a.s.ivs --> all included
% only one non-zero in a.s.ivs --> only this one used
aTmp.titleStr = {};
for curIv = 1:size(a.s.ivs,1)
    if sum(a.s.ivs{curIv,a.s.ivsCols.useVal}) == 0
        aTmp.titleStr{curIv} = ['across ', a.s.ivs{curIv,a.s.ivsCols.name} ', '];
    elseif sum(a.s.ivs{curIv,a.s.ivsCols.useVal}) == 1
        aTmp.titleStr{curIv} = ['only ', a.s.ivs{curIv,a.s.ivsCols.valLabels}{find(a.s.ivs{curIv,a.s.ivsCols.useVal})} ', '];
    end        
end
if ~isempty(aTmp.titleStr)
aTmp.titleStr = cellCollapse(aTmp.titleStr,2,2);
else
aTmp.titleStr = {''};
end

clearvars -except a e tg aTmp