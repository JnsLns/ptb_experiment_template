
if a.s.balancingByMeanOfMeans
    
    a.s.ivs{end+1,a.s.ivsCols.name} = 'internalBalancingCategoryIV';
    a.s.ivs{end,a.s.ivsCols.style} = '';
    a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.relevantBalancingColumn;
    a.s.ivs{end,a.s.ivsCols.values} = a.s.expectedBalancingValues';
    a.s.ivs{end,a.s.ivsCols.valLabels} = cellfun(@(tmp) num2str(tmp) ,num2cell(a.s.expectedBalancingValues),'uniformoutput',0);
    a.s.ivs{end,a.s.ivsCols.useVal} = ones(numel(a.s.expectedBalancingValues),1);
    a.s.ivs{end,a.s.ivsCols.diffs} = [];
    a.s.ivs{end,a.s.ivsCols.doMirror} = zeros(numel(a.s.expectedBalancingValues),1);
    a.s.ivs{end,a.s.ivsCols.joinVals} = {};
    a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
    
end

clearvars -except a e tg aTmp

