
% compute sets of trajectories and trial results based on the independent
% variables defined in a.s.ivs. The result is a multidimensional cell array a.s.rowSets
% with a logical matrix in each of its cells which indexes the rows/elements in
% a.rs/tr that correspond to the value of the IV combination that is associated
% with that cell of the array. The dimensions of the cell array correspond
% to the independent variables given in the rows of array a.s.ivs (e.g.,
% a.s.rowSets{4,2,1} is a vector indexing those elements in a.rs and tr that stem
% from trials where IV1 (row 1 of a.s.ivs) was 4, IV2 (row 2 of a.s.ivs) was 2,
% and IV3 (row 3 of a.s.ivs) was 1.). Note that some IVs contained in a.s.ivs 
% are not represented in a.s.rowSets, namely those whose useVal are all set to 0
% (these IVs are completely disregarded) or for which only one useVal is set
% to 1 (disregarded as IV, but all trials set to useVal 0 are 0 in a.s.rowSets).
% However, generateSets adjusts the IV definition array a.s.ivs in so far that
% it entirely removes the information of unused IVs from a.s.ivs (in other words:
% after genereateSets, the dimensions of a.s.rowSets in any case directly map
% to rows of a.s.ivs, no matter which or how many IVs are in- or excluded).
% The structure of a.s.rowSets and of all arrays derived from it (below) allows
% to address individual sets/cells by a linear index and still be able to
% derive the respective set's IV combination: Convert linear index to
% subscript indices (e.g., by ind2subAll) --> each value in the resulting row
% vector gives the value for the rowSet with respect to the IV that is given
% by the index of that value in the vector.
% Note that this script adds IV values to the sets and to a.s.ivs that were not
% explicitly specified in a.s.ivsCols.useVal but that are required to compute
% the desired diffs given in a.s.ivsCols.diffs. This information is removed at
% the end of computeDiffsBtwMeans.m. The same is true for information about
% desired joined set (a.s.ivsCols.joinVals) and this info is removed at the end
% of combineRowSets.
%

disp('Computing trial sets based on IVs...');


%% Exclude trials from unwanted conditions from the basis set of trials and
% delete respective info from a.s.ivs

ivs_backup = a.s.ivs;

% base rowSet by default includes all trials in a.rs
rowSet_base = ones(size(a.rs,1),1);

% first remove rows of a.s.ivs where there are no included values at all (which
% means that the variable should be disregarded entirely).
a.s.ivs = a.s.ivs(cellfun(@(x) any(x==1), a.s.ivs(:,a.s.ivsCols.useVal)),:);

% go through independent variables and successively exclude trials from
% rowSet_base that are from conditions that are set to zero in a.s.ivsCols.useVal
for curRow = 1:size(a.s.ivs,1)
   
    % get code-values of current iv that should be included 
    incVals_ind = logical(a.s.ivs{curRow,a.s.ivsCols.useVal});
    incVals = a.s.ivs{curRow,a.s.ivsCols.values};        
    incVals = incVals(incVals_ind,:);     
    
    % go to column of a.rs that holds info about current IV, find
    % to-be-included values, leave respective rows in rowSet_base at 1,
    % set other rows to 0.
    curRsCol = a.rs(:,a.s.ivs{curRow,a.s.ivsCols.rsCol});    
    rowSet_base = arrayfun(@(x) any(x==incVals),curRsCol) & rowSet_base;
    
    % remove data about excluded conditions from other columns of a.s.ivs as well    
    a.s.ivs{curRow,a.s.ivsCols.values} = a.s.ivs{curRow,a.s.ivsCols.values}(incVals_ind);
    a.s.ivs{curRow,a.s.ivsCols.valLabels} = a.s.ivs{curRow,a.s.ivsCols.valLabels}(incVals_ind);           
    
end

% remove rows in a.s.ivs where only one included value remains (i.e., this is
% not treated as IV anymore for all subsequent computations). Spare one row
% if there are no a.s.ivs with multiple values.
ivsMultiValRows = cellfun(@(x) numel(x)>1,a.s.ivs(:,a.s.ivsCols.values));
if any(ivsMultiValRows)
    a.s.ivs = a.s.ivs(ivsMultiValRows,:);
else
    a.s.ivs = a.s.ivs(1,:);
end

%% Split up the basis set of all included trials into condition combinations
% and distribute these to the cells of a multidimensional cell array. This
% cell array has one dimension per IV (=rows in current version of a.s.ivs) and
% each of its cells holds the set of trials from the combination of conditions
% given by the subscript index of that cell
%
% E.g., the set of trials in cell [2 3 6] corresponds to values
% a.s.ivs{1,a.s.ivsCols.values}(2), a.s.ivs{2,a.s.ivsCols.values}(3) and a.s.ivs{3,a.s.ivsCols.values}(6).
%
% The "sets of trials" in each cell are logical matrices indexing into arrays
% a.tr and a.rs so that they can be used in the form a.tr(a.s.rowSets{x}) or
% a.rs(a.s.rowSets{x},:) to retrieve all cells/rows belonging to the set.

% prepare empty cell array of the correct size:
numDim = size(a.s.ivs,1); 
% IV is rows of the cell array (as many as there are values in IV 1)
a.s.rowSets = cell(sum(a.s.ivs{1,a.s.ivsCols.useVal}),1); 
% add another dimension for each IV beyond the first, each dim as large as
% the number of values in the corresponding IV.
for d = 2:numDim    
    dims = find(size(a.s.rowSets)>=2,1,'last'); % determine current number of dims    
    rminp = ones(1,dims+1);
    rminp(end) = numel(a.s.ivs{d,a.s.ivsCols.values}); % add as many in this dmension as there are values in that IV
    a.s.rowSets = repmat(a.s.rowSets,rminp);                               
end

% then go through that array by linear index (curNdx) and fill each cell with a
% logical matrix denoting the rows in a.rs/a.tr that correspond to the value of
% the IV that is associated with that cell.
for curNdx = 1:numel(a.s.rowSets)

    % The numbers in subNdcs correspond to both rows/cols/pages/etc in the
    % different dimensions of a.s.rowSets, as well as to value vector in the
    % respective row of a.s.ivs.
    % E.g. subNdcs = [4 6] denotes a.s.ivs{1,a.s.ivsCols.values}(4) and a.s.ivs{2,a.s.ivsCols.values}(6)
    subNdcs = ind2subAll(size(a.s.rowSets),curNdx);
    
    % Prepare logical matrix in a.s.rowSets
    a.s.rowSets{curNdx} = rowSet_base;
    
    % Go through IVs and one value for each, check against results     
    for curIv = 1:numDim
        
        % row of that IV from a.s.ivs
        ivsRow_tmp = a.s.ivs(curIv,:);
        % entire column from a.rs for that IV
        rsCol_tmp = a.rs(:,ivsRow_tmp{a.s.ivsCols.rsCol});
                
        % Make row set from rows in a.rs that (a) hold a value equal to the
        % current IV value and (b) are not already 0 in the final cell in
        % a.s.rowSets
        a.s.rowSets{curNdx} =  rsCol_tmp == ivsRow_tmp{a.s.ivsCols.values}(subNdcs(curIv)) & a.s.rowSets{curNdx};
                        
    end        
    
end


%% Update number of a.s.ptsDim in case rows from ivs have been deleted above
if a.s.averageAcrossParticipantMeans      
    newPtsDim = find(strcmp('internalPtsDim',a.s.ivs(:,a.s.ivsCols.name)));    
    if newPtsDim ~= a.s.ptsDim         
        disp([char(9), 'Updating a.s.ptsDim from ' num2str(a.s.ptsDim) ' to ' num2str(newPtsDim) ' (since some IVs were removed in generateSets.m).'])
        a.s.ptsDim = newPtsDim;        
    end        
end



clearvars -except a e tg aTmp
