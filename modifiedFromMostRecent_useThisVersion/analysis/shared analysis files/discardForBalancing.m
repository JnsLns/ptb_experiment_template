% This balances trials in each cell of a.s.rowSets such that each unique number
% present in the results matrix' colum a.s.relevantBalancingColumn (defined in
% ivDefinition) occurs the same number of times afterwards (alternatively, 
% if zeroCasesImpactBalancing_tmp==1, it is not the unique numbers present in
% that column, but the set of numbers defined in a.s.expectedBalancingValues).
% This is achieved by randomly discarding trials from the rowSet that have an
% over-represented code, by setting those trials to zero in a.s.rowSets. The
% number of each type of trial is reduced to that of the least frequently
% occuring trial category in the set. Note: Balancing is achieved WITHIN
% each set of trials on the lowest level (i.e., within the group of trials
% addressed by the logical vector within a single cell of rowSets, that is, 
% within each combination of enabled IV-levels, seen in ivs; because parti-
% cipants normally also pose an IV--although later averaged over--balancing
% is not only separately done within each combination of IV-levels in the 
% strict sense, but also within each participant.
%
% Balancing is separately ensured for combination of enabled IV-levels and
% participants. For example if 
%
% IV 1 : distracter side
%           left
%           right
% IV 2 : word order
%           tsr
%           srt
% "IV3": participants
% 
% then balancing is done within each combination of these three IVs, for
% instance, it is done separately within the set of trials characterized by
% "IV1=left + IV2=tsr + IV3=participant3":
%
% Note that when any new scripts are newly included in the analysis pipeline
% that alter rowSet membership of trials or change the structure of rowSets
% itself (e.g., combineRowSets), then it may be necessary to re-balance after
% that script by running this script again (this is already the case for
% combineRowsSets.m).


% In case a.s.relevantBalancingColumn is not defined
if a.s.discardTrialsToBalance && (~isfield(a.s,'relevantBalancingColumn') || isempty(a.s.relevantBalancingColumn))
    a.s.discardTrialsToBalance = 0;
    warning('a.s.relevantBalancingColumn missing or empty. Skipping discardForBalancing.');
end


if a.s.discardTrialsToBalance
    
    disp(['Discarding trials from a.s.rowSets to achieve balancing with regard to column ', ...
        num2str(a.s.relevantBalancingColumn), ' of results matrix.']);
    
    totalRemoveNum = 0;
    
    % Go through cells of a.s.rowSets one by one and balance within each
    for crs = 1:numel(a.s.rowSets)
                
        if ~zeroCasesImpactBalancing_tmp
            % automatically determine code values expected in relevant column of results;
            uniqueValues = unique(a.rs(a.s.rowSets{crs},a.s.relevantBalancingColumn)); 
        elseif zeroCasesImpactBalancing_tmp
            % pre-define which values are expected in relevant column of
            % results; if any of these haev zero cases, all trials in that
            % cell of the set will be discarded!
            uniqueValues = a.s.expectedBalancingValues';
        end
        % Get occurrence number for each value
        nPerVal = hist(a.rs(a.s.rowSets{crs},a.s.relevantBalancingColumn),uniqueValues);
        nTotalCurCell = sum(nPerVal);
        % Of those, get the smallest = limiting factor
        minNum = min(nPerVal);
        
        % Cycle through code values and for each code discard trials from
        % a.s.rowSets such that there's the same number of trials for each code
        % value.
        curCellRemoved = 0;
        for curVal = uniqueValues'
            
            % linear indices of trials having current value in balancing column
            % and being included (set to 1) in current rowSet
            lndcsCurVals = find(a.rs(:,a.s.relevantBalancingColumn) == curVal & a.s.rowSets{crs});
            % determine how many should be discard to achieve balancing
            removeNum = numel(lndcsCurVals)-minNum;
            % Shuffle linear index vector
            lndcsCurVals = lndcsCurVals(randperm(numel(lndcsCurVals)));
            % then use first removeNum indices to discard these trials
            % from rowset
            lndcsCurVals = lndcsCurVals(1:removeNum);
            % apply to current row set
            a.s.rowSets{crs}(lndcsCurVals) = 0;
            
            totalRemoveNum = totalRemoveNum + removeNum;
            curCellRemoved = curCellRemoved + removeNum;            
            
        end
        
        disp([char(9) '-> a.s.rowSets{' num2str(crs) '} : ' num2str(curCellRemoved) ' of ' num2str(nTotalCurCell) ' cases removed.']);
        
    end
    
    disp(['Discarded a total of ', num2str(totalRemoveNum), ' trials for balancing.']);
    
end

clearvars -except a e tg aTmp