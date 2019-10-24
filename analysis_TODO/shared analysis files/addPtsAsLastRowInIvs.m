%% add individual participants as last dimension of IVS 
% THIS IS ABSOLUTELY MANDATORY AND MUST BE THE LAST ROW IN CELL ARRAY IVS
% (due to how it is interpreted by averageAcrossPtsMeans)

if a.s.averageAcrossParticipantMeans
    a.s.ivs{end+1,a.s.ivsCols.name } = 'internalPtsDim';
    a.s.ivs{end,a.s.ivsCols.style } = '';
    a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.pts;
    a.s.ivs{end,a.s.ivsCols.values} = unique(a.rs(:,a.s.resCols.pts));
    a.s.ivs{end,a.s.ivsCols.valLabels} = num2cell(unique(a.rs(:,a.s.resCols.pts)));
    a.s.ivs{end,a.s.ivsCols.useVal} = ones(1,numel(a.s.ivs{end,a.s.ivsCols.values}))';
    a.s.ivs{end,a.s.ivsCols.diffs} = [];
    a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
    a.s.ivs{end,a.s.ivsCols.joinVals} = {};
    
    a.s.ptsDim = size(a.s.ivs,1); % has to be the last row of ptsDim or else everything will explode!!!
    
end

