% This script flips some trajectories across their main axis, that is, if
% a.s.chosenItemDefinesRefDir==1, the axis between their first data point
% and the center of the item chosen for response in that trial, or, if
% a.s.chosenItemDefinesRefDir==0, between their first point and last point.
%
% Trajectories from which conditions should be flipped is defined in ivs.
% The script operates on (and changes) the basic arrays a.rs and a.tr
% (before anything is sorted into conditions), so flipped trajectories will
% be used in all the following steps. If a trajectory falls into multiple
% categories that are all set to be flipped, then this trajectory is only
% flipped once (not back and forth).
%
% Flipping is applied to trajectories. Some results data is as well
% adjusted to the flipped trajectories. This includes:
%
% - Trajectories
%       - a.tr
% - Stimulus item positions in results matrix
%       - a.rs(:,a.s.resCols.horzPosStart:a.s.resCols.horzPosEnd)
%       - a.rs(:,a.s.resCols.vertPosStart:a.s.resCols.vertPosEnd)
% - Start position in results matrix
%       - a.rs(:,[a.s.resCols.startPosX,a.s.resCols.startPosY])
% - Other values in results
%       - a.s.resCols.distNonChosenToDirPath 
%
% (note that spatial results data being flipped is the same as the data
% being rotated/transformed in prepareTrajs).
%
%
%        !!! DATA THAT IS NOT ADJUSTED TO FLIPPING: !!!
%
% The following values in the results matrix are deliberately
% NOT adjusted (recoded) when the corresponding trajectories are flipped:
%
% a.s.resCols.sideNonChosenToDirPath
% a.s.resCols.refSide
% a.s.resCols.comSide
%
% This is because these are used as independent variables, that is, to
% determine assignment of trials to different rowSets, which is done in
% scripts only following the current one. Not recoding these values ensures
% that trials will be assigned to rowSets based on their original
% properties, allowing to still distinguish between different trial groups
% based on these properties and to ensure balancing within these distinct
% groups.
%
%
% Note: Re-running analysis with no flipping enabled in ivs will still work, 
% using stored unflipped versions of a.tr and a.rs.



% Use clean, unflipped versions of results arrays for each run of analysis
% (clean versions are stored below if any mirroring is desired)
if isfield(aTmp,'rs_beforeMirroring')
    a.rs = aTmp.rs_beforeMirroring;
    a.tr = aTmp.tr_beforeMirroring;
end

% check whether mirroring is enabled for any IV-level
if  any(cell2mat(cellCollapse(a.s.ivs(:,a.s.ivsCols.doMirror),1,1)))
 
    % Flag for the other scripts that some flipping has occurred and
    % associated arrays/struct fields will exist
    a.s.someFlippingHasOccured = 1;
    
    % In first run of analysis with newly loaded data, save unflipped version
    % of a.rs and a.tr as fresh basis for subsequent runs of analysis. In later runs
    % use these clean versions to replace a.rs and a.tr before flipping (see above).
    if ~isfield(aTmp,'rs_beforeMirroring')
        aTmp.rs_beforeMirroring = a.rs;
        aTmp.tr_beforeMirroring = a.tr;
    end
    
    % array to keep track of which trajs have already been flipped (in current
    % run of analysis script), to avoid flipping back and forth in case of
    % a trial being member of multiple conditions for which mirroring is enabled.
    a.s.flipDone = zeros(size(a.rs,1),1);        
    
    % Go though IVS
    for curIv = 1:size(a.s.ivs,1)
        
        % any flipping desired for that IV?
        if any(a.s.ivs{curIv,a.s.ivsCols.doMirror})                        
            
            % get linear indices of those code values (= different IV-levels)
            % that should be mirrored, for indexing into contents of a.s.ivs' cells
            flip_lndcs = find(a.s.ivs{curIv,a.s.ivsCols.doMirror});
            
            % for which code values (levels of IV)?
            flipVals = a.s.ivs{curIv,a.s.ivsCols.values}(flip_lndcs)';
            
            % add mirrored-tag to the plotting labels of the mirrored IV levels
            % (and print message to prompt for each)
            for i = 1:numel(flip_lndcs)
                disp(['Flipping trajs (IV/lvl.): ' a.s.ivs{curIv,a.s.ivsCols.name} ' / ' a.s.ivs{curIv,a.s.ivsCols.valLabels}{flip_lndcs(i)}]);                
                a.s.ivs{curIv,a.s.ivsCols.valLabels}{flip_lndcs(i)} = [a.s.ivs{curIv,a.s.ivsCols.valLabels}{flip_lndcs(i)}, ' (m)'];                                
            end
                                    
            % Find LOGICAL indices of any rows in matrix a.rs that satisfy one of the above
            % values (i.e., which belong to the IV levels whose trials will be mirrored)
            flipNdcs = any(repmat(a.rs(:,a.s.ivs{curIv,a.s.ivsCols.rsCol}),1,numel(flipVals)) == repmat(flipVals,size(a.rs,1),1),2);
            % Exclude trials for which trajectory was already flipped (due to
            % belonging to another IV's mirrored level)
            flipNdcs = logical(flipNdcs & ~a.s.flipDone);
            % Add new set to already flipped trajs
            a.s.flipDone = a.s.flipDone | flipNdcs;
            
            if ~all(flipNdcs == 0)
                
                % Get subset of trajs and results rows that should be flipped
                trTmp = a.tr(flipNdcs);
                rsTmp = a.rs(flipNdcs,:);
                
                % For each trial in flip-subset get coordinates of first and
                % last data point defining flip-axis
                fstPoints_xy = []; lstPoints_xy = [];
                for curInd = 1:numel(trTmp)
                    fstPoints_xy(curInd,:) = trTmp{curInd}(1,[a.s.trajCols.x,a.s.trajCols.y]);
                    % last points of flip axis are either chosen item center or
                    % last point of trajectory
                    if a.s.chosenItemDefinesRefDir
                        lstPoints_xy(curInd,1) = rsTmp(curInd,a.s.resCols.horzPosStart-1+rsTmp(curInd,a.s.resCols.chosen));
                        lstPoints_xy(curInd,2) = rsTmp(curInd,a.s.resCols.vertPosStart-1+rsTmp(curInd,a.s.resCols.chosen));
                    elseif ~a.s.chosenItemDefinesRefDir
                        lstPoints_xy(curInd,:) = trTmp{curInd}(end,[a.s.trajCols.x,a.s.trajCols.y]);
                    end
                end
                
                % -- Flip trajectories
                
                % Add last point to trajectories (only different from original
                % last point if a.s.chosenItemDefinesRefDir==1)
                for curInd = 1:numel(trTmp)
                    trTmp{curInd}(end+1,[a.s.trajCols.x,a.s.trajCols.y]) = lstPoints_xy(curInd,:);
                end
                % Flip trajectories
                trTmp = trajMirror(trTmp,[a.s.trajCols.x,a.s.trajCols.y]);
                % Remove last point from each trajectory
                for curInd = 1:numel(trTmp)
                    trTmp{curInd}(end,:) = [];
                end
                % Put flipped subset back to original trajectory array
                a.tr(flipNdcs) = trTmp;
                
                % -- Flip corresponding data in results matrix
                
                % Get all relevant data from results matrix, shape into trajectory-
                % like matrix with trajectories first point as first point and
                % chosen item pos (or trajectories last point) as last point,
                % then flip that thing, remove first and last point, then put
                % back into original results row.
                
                linFlipNdcs = find(flipNdcs);
                for curInd = 1:numel(linFlipNdcs)
                    
                    % corresponding rows in rsTmp, lstPoints_xy, and fstPoints_xy
                    % are addressed by curInd directly.
                    curFst_xy = fstPoints_xy(curInd,:);
                    curLst_xy = lstPoints_xy(curInd,:);
                    curRsRow = rsTmp(curInd,:);
                    
                    % Construct trajectory-like matrix out of values that need to be
                    % transformed, insert first and last data point of respective traj
                    % as first and last point
                    rsPosData_tmp = ...
                        [curFst_xy; ...
                        [curRsRow(1,a.s.resCols.horzPosStart:a.s.resCols.horzPosEnd)',...
                        curRsRow(1,a.s.resCols.vertPosStart:a.s.resCols.vertPosEnd)'];...
                        curRsRow(1,[a.s.resCols.startPosX,a.s.resCols.startPosY]);...
                        curLst_xy];
                    
                    % then flip that grotesque thing
                    rsPosData_tmp = cell2mat(trajMirror(rsPosData_tmp,[1 2]));
                    
                    % remove first and last points
                    rsPosData_tmp = rsPosData_tmp(2:end-1,:);
                    
                    % then put the whole stuff back into row of original results matrix
                    arsRow = linFlipNdcs(curInd); % row in a.rs that corresponds to current (flipped) row from rsTmp
                    a.rs(arsRow, ...
                        [a.s.resCols.horzPosStart:a.s.resCols.horzPosEnd, ...
                        a.s.resCols.startPosX, ...
                        a.s.resCols.vertPosStart:a.s.resCols.vertPosEnd, ...
                        a.s.resCols.startPosY]) ...
                        = rsPosData_tmp(1:end);
                    
                    % Change sign of a.s.resCols.distNonChosenToDirPath
                    a.rs(arsRow, a.s.resCols.distNonChosenToDirPath) = -(a.rs(arsRow, a.s.resCols.distNonChosenToDirPath));                                                                                   
                    
                end
                
            end
            
        end
        
    end
    
else
    
    % Flag for the other scripts that NO flipping has occurred and
    % associated arrays/struct fields will NOT exist
    a.s.someFlippingHasOccurred = 0;
    
end

clearvars -except a e tg aTmp