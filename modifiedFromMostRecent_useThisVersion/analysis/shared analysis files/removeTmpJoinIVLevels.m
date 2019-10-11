
% remove data from a.s.rowSets array that was inserted temporarily only for the
% purpose of computing joined sets in combineRowSets.m (and which themselves should not be plotted).
for curIv = 1:size(a.s.ivs,1)
   
    % Find set of values temporarily activated due to joining (and not due
    % to diffs, which are used later and only then removed).
    curTmpVals = intersect(a.s.ivs{curIv,a.s.ivsCols.tmpValsJoin},a.s.ivs{curIv,a.s.ivsCols.tmpValsDiff});       
    curTmpVals = a.s.ivs{curIv,a.s.ivsCols.tmpValsJoin}(~(arrayfun(@(x) any(x==curTmpVals), a.s.ivs{curIv,a.s.ivsCols.tmpValsJoin})));
    
    while ~isempty(curTmpVals)    
       
       curTmpVal = curTmpVals(1);
        
       % Find number of page that needs to be removed from the dimension
       % given by curIv to get rid of current temp value data
       pageNum = find(a.s.ivs{curIv,a.s.ivsCols.values} == curTmpVal);
       
       % delete that page from a.s.rowSets       
       a.s.rowSets = cellPageDelete(a.s.rowSets,curIv,pageNum);           
                     
       % remove current temp val from storage and from values and delete
       % corresponding label from a.s.ivs
       curTmpVals(1) = [];       
       a.s.ivs{curIv,a.s.ivsCols.values}(pageNum) = [];       
       a.s.ivs{curIv,a.s.ivsCols.valLabels}(pageNum) = [];         
              
    end

end

clearvars -except a e tg aTmp