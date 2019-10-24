
% Subtracts the mean of means across all mean trajectories of the activated
% levels of one IV from the mean within each level/condition of that IV.
% The data in struct a is replaced by those differences. That is, what will
% be plotted and contained in the final struct a is differences from the
% overall mean of means along the chosen IV. In effect, this may remove any
% bias that affects both conditions in an equal manner (=main effect without interactions).
%
% The procedure is applied to all fields in structure a that end with ".avg"
% (trajectories, results row, and other data are each handled somewhat diffe-
% rently and identified based on typical data type and matrix size within).
%
% Note that the subtracted mean is computed as an average over the means
% from all active level (i.e., NOT averaging across all included trials,
% nor using weighted means based on trial number in each mean traj; the
% former can be done using subtractIVAverage_grandMean,  but will bias the
% overall mean toward the mean of the condition that includes more trials).
%
% Note that, at this point, averaging over participants has not taken place
% yet, which means that the entire thing is done separately for each
% participant.
%
% The IV for which this script is applied is marked by 1 (otherwise 0)
% in column a.s.ivsCols.subtractOverallMean of cell array ivs.
% Only one IV may be activated in this manner.
%

if a.s.subtractMeanOfMeansNotGM == 1
    
    % Find dimension/IV across the levels of which an overall trajectory is desired
    a.s.overallDim = find(cell2mat(a.s.ivs(:,a.s.ivsCols.subtractOverallMean))==1);
    
    if numel(a.s.overallDim) == 1
        
        disp(['Computing overall MEAN OF MEANS for IV "' a.s.ivs{a.s.overallDim,a.s.ivsCols.name} '" & subtracting from condition means.']);
        
        % Get highest layer field "addresses" in struct a
        a_dataFieldNames = findStructBranchEnds(a);
        % among these, find fields holding averages (get logical indices in
        % a_dataFieldNames; based on the field names)
        a_avgLogicalNdcs = endsWith(a_dataFieldNames,'.avg');
        % get the actual field names in struct
        a_dataFieldNames_avg = a_dataFieldNames(a_avgLogicalNdcs);
        
        % iterate over all the fields, computing and subtracting across-level mean from each
        for curField = a_dataFieldNames_avg'
            
            curOriginalData = eval([curField{:},';']);
            overallDim_pages = size(curOriginalData,a.s.overallDim);    % number of active IV-levels
            
            % Compute overall
            if iscell(curOriginalData)
                curOverallData = cellSum(curOriginalData,a.s.overallDim);
                curOverallData = cellfun(@(cod)  cod./overallDim_pages,curOverallData,'uniformoutput',0);
            elseif isa(curOriginalData,'double')
                curOverallData = mean(curOriginalData,a.s.overallDim);
            else
                error(['Data in a', curField{:}, ' seems to be neither cell nor double array.']);
            end
            
            % replicate overallData along a.s.overallDim to conform to page number of
            % original data and thus enable subtracting
            repVector = ones(1,ndims(curOverallData));
            repVector(a.s.overallDim) = overallDim_pages;
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
            
            % overwrite data in a with difference from overall mean of means
            eval([curField{:},'= curDiff;']);
            
        end
        
    elseif numel(a.s.overallDim) > 1
        
        error('Overall mean subtraction activated for more than one IV.')
        
    else
        
        disp('(No overall mean subtraction specified.)');
        
    end
    
    clearvars -except a e tg aTmp
    
end




