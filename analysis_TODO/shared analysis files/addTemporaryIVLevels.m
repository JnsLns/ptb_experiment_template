%% temporarily add values that are involved in a requested difference
% but that are not requested to be plotted themselves to
% a.s.ivs(:,a.s.ivsCols.useVal). (The pages in the cell array that will hold data
% about the temporary values will be removed again before plotting, see
% computeDiffsBtwMeans.m).

for curIv = 1:size(a.s.ivs,1)           

    a.s.ivs{curIv,a.s.ivsCols.tmpValsDiff} = [];
    
    % are there values in the requested differences that are not in the set 
    % of plotted values? if yes, activate these (i.e, set to 1 in useval).
    curUsedCodes = a.s.ivs{curIv,a.s.ivsCols.values}(logical(a.s.ivs{curIv,a.s.ivsCols.useVal}));    
    tmpAddVals = setdiff(a.s.ivs{curIv,a.s.ivsCols.diffs},curUsedCodes);                    
    activateLndcs = arrayfun(@(x) any(x==tmpAddVals), a.s.ivs{curIv,a.s.ivsCols.values});    
    a.s.ivs{curIv,a.s.ivsCols.useVal}(activateLndcs) = 1;       
    
    % Store code values (referring to those in a.s.ivsCols.values) temporarily
    % activated, to be able to later remove the data from the computed
    % array. 
    if any(activateLndcs)
        a.s.ivs{curIv,a.s.ivsCols.tmpValsDiff} = tmpAddVals;
    end
    
end


%% temporarily add values that are involved in joined set
% but that are not requested to be plotted themselves to
% a.s.ivs(:,a.s.ivsCols.useVal). 
% Removed again in combineRowSets.m

for curIv = 1:size(a.s.ivs,1)           
    
    a.s.ivs{curIv,a.s.ivsCols.tmpValsJoin} = [];
    
    % loop over desired sets to join for current IV    
    if numel(a.s.ivs{curIv,a.s.ivsCols.joinVals}) > 0               
    
        % are there values in the requested sets that are not in the set 
        % of active individual values? if yes, activate these.
        curJoinVals = cell2mat(cellCollapse(a.s.ivs{curIv,a.s.ivsCols.joinVals},1,2));        
        curUsedCodes = a.s.ivs{curIv,a.s.ivsCols.values}(logical(a.s.ivs{curIv,a.s.ivsCols.useVal}));    
        tmpAddVals = setdiff(curJoinVals,curUsedCodes);                
        a.s.ivs{curIv,a.s.ivsCols.useVal}(arrayfun(@(x) any(x==tmpAddVals), a.s.ivs{curIv,a.s.ivsCols.values})) = 1;       
        
        % Store code values (referring to those in a.s.ivsCols.values) temporarily
        % activated, to be able to later remove the data from the computed
        % array. 
        a.s.ivs{curIv,a.s.ivsCols.tmpValsJoin} = tmpAddVals;
    
    end
    
end

clearvars -except a e tg aTmp