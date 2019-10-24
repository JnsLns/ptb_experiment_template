
% Subtracts the grand mean across trials from all activated levels of one
% IV from the mean within each level/condition of that IV. The data in struct
% a is replaced by those differences. That is, what will be plotted and
% contained in the final struct a is differences from the overall mean
% along the chosen IV. In effect, this may remove any bias that affects
% both conditions in an equal manner (=main effect without interactions).
%
% The procedure is applied to all fields in structure a that end with ".avg"
% (trajectories, results row, and other data are each handled somewhat diffe-
% rently and identified based on typical data type and matrix size within).
%
% Note that the grand mean is computed from the pooled individual trials
% from all active levels of the respective IV (i.e., it is not a mean of means).
% However, this differs from a mean of means only if the number of cases in
% the different levels/conditions of the IV is different (and only in this
% case might the final differences be non-symmetric across zero).
%
% Note that, at this point, averaging over participants has not taken place
% yet, which means that the entire thing is done separately for each
% participant.
%
% The IV for which this script is applied is marked by 1 (otherwise 0)
% in column a.s.ivsCols.subtractOverallMean of cell array ivs.
% Only one IV may be activated in this manner.
%

if a.s.subtractMeanOfMeansNotGM == 0
    
    % Find dimension/IV across the levels of which an overall trajectory is desired
    a.s.overallDim = find(cell2mat(a.s.ivs(:,a.s.ivsCols.subtractOverallMean))==1);
    
    if numel(a.s.overallDim) == 1
        
        disp(['Computing overall means for IV "' a.s.ivs{a.s.overallDim,a.s.ivsCols.name} '" & subtracting from condition means.']);
        
        % Call function below with vars existing in workspace as arguments
        % (using a function allows to reuse computeStatistics.m more conveniently
        % without overwriting existing structure 'a').
        a = computeMeanTrajAlongIVAndSubtract(a,a.s.overallDim);
        
    elseif numel(a.s.overallDim) > 1
        
        error('Overall mean subtraction activated for more than one IV.')
        
    else
        
        disp('(No overall mean subtraction specified.)');
        
    end
    
    clearvars -except a e tg aTmp
    
end


%%
function a = computeMeanTrajAlongIVAndSubtract(a,overallDim)

skipVariableDeletionInComputeStatistics = 1;

a_original = a;

% Collapse rowSets along dimension along which average is desired,
% combining the data in the joined cells via logical or, resulting in new
% rowSets
a.s.rowSets = cellLogicalOr(a.s.rowSets,overallDim,1:size(a.s.rowSets,overallDim));
% Compute statistics using the new rowSets. Output is struct a with data
% across the activated level of overallDim in a.trj and a.res
computeStatistics;
a_overall = a;

% Get highest layer field "addresses" in struct a
a_dataFieldNames = findStructBranchEnds(a_overall);
% among these, find fields holding averages (get logical indices in
% a_dataFieldNames; based on the field names)
a_avgLogicalNdcs = endsWith(a_dataFieldNames,'.avg');
% get the actual field names in struct
a_dataFieldNames_avg = a_dataFieldNames(a_avgLogicalNdcs);
% remove 'a_overall' from beginning of each string
a_dataFieldNames_avg = strrep(a_dataFieldNames_avg,'a_overall','');

% iterate over all the fields, computing and subtracting across-level mean from each
for curField = a_dataFieldNames_avg'
    
    curOverallData = eval(['a_overall',curField{:},';']);
    curOriginalData = eval(['a_original',curField{:},';']);
    overallDim_pages = size(curOriginalData,overallDim);    % number of active IV-levels
    
    % replicate overallData along overallDim to conform to page number of
    % original data and thus enable subtracting
    repVector = ones(1,ndims(curOverallData));
    repVector(overallDim) = overallDim_pages;
    curOverallData = repmat(curOverallData,repVector);
    
    % subtract overall data from original data, exact way depends on data
    % type (which is detected based on size & type of arrays):
    
    % results or trajectory
    if iscell(curOverallData) % results or trajectory
        
        % trajectory
        if size(curOverallData{1},2) == 3
            % set trajectory time column to zero in overall data to retain it in output data
            for coadNum = 1:numel(curOverallData)
                curOverallData{coadNum}(:,a.s.trajCols.t) = 0;
            end
        elseif ~(size(curOverallData{1},1) == 1 && size(curOverallData{1},2) > 3)
            error('Unexpected data format: neither results (1 row) nor trajectory (3 columns)');
        end
        
        % do subtraction
        curDiff = cellfun(@(ovrl,orig)  orig-ovrl,curOverallData,curOriginalData,'uniformoutput',0);
        
        % things with one scalar value per condition in a double matrix (e.g. mDev)
    elseif isa(curOverallData,'double')
        
        % do subtraction
        curDiff = curOriginalData-curOverallData;
        
    else
        error('Unexpected data format: neither double nor cell.');
    end
    
    % overwrite data in a_original with difference from overall mean
    eval(['a_original',curField{:},'= curDiff;']);
    
end

% put back to a (= function output)
a = a_original;

end
