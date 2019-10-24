% Compute statistics using the sets computed in generateSets.
% (This file operates only on the individual cells of the
% results/trajectory cell arrays; it does not join/remove/add cells; it adds
% new cell arrays holding the computed descriptive statistics);
%
%
% Note that this file is used at two points in the analysis pipeline:
% (1) being called from baseAnalyses and (2) being called from
% subtractIVAverage. Keep that in mind when modifying code here.

disp('Computing derivative trajectory properties and descr. statistics...');

%% Trajectories from trajectories in cell array a.tr

% delete all computed statistics from previous runs
removeFields = {'trj','res','byPts'};
for curRemField = removeFields
    if isfield(a,curRemField)
        a = rmfield(a,curRemField);
    end
end

% sets of the individual trajectories falling in each combination of IVs

%% Trajectories: prepare output cells:

% raw and warped trajectories, position data (always computed since some stuff below depends on it)
%
% individual trajectories
a.trj.raw.pos.ind = cell(size(a.s.rowSets)); % raw, non-interpolated
a.trj.wrp.pos.ind = cell(size(a.s.rowSets)); % time-warped to fixed number of steps
% descriptive stats
a.trj.wrp.pos.avg = cell(size(a.s.rowSets));
a.trj.wrp.pos.std = cell(size(a.s.rowSets));

% PROTOTYPE START
% momentary angular deviation from direction toward specific item (unsigned)
% individual
a.trj.wrp.ang.tgt.ind = cell(size(a.s.rowSets));
a.trj.wrp.ang.ref.ind = cell(size(a.s.rowSets));
a.trj.wrp.ang.dtr.ind = cell(size(a.s.rowSets));
% stats
a.trj.wrp.ang.tgt.avg = cell(size(a.s.rowSets));
a.trj.wrp.ang.tgt.std = cell(size(a.s.rowSets));
a.trj.wrp.ang.ref.avg = cell(size(a.s.rowSets));
a.trj.wrp.ang.ref.std = cell(size(a.s.rowSets));
a.trj.wrp.ang.dtr.avg = cell(size(a.s.rowSets));
a.trj.wrp.ang.dtr.std = cell(size(a.s.rowSets));
% PROTOTYPE END


if a.s.doCompute_spdVelAcc
    a.trj.raw.spd.ind = cell(size(a.s.rowSets)); % Total speed
    a.trj.raw.vel.ind = cell(size(a.s.rowSets)); % Velocity
    a.trj.raw.acc.ind =  cell(size(a.s.rowSets)); % Acceleration
    a.trj.wrp.vel.ind = cell(size(a.s.rowSets)); % Componential Velocity
    a.trj.wrp.spd.ind = cell(size(a.s.rowSets)); % Total speed
    a.trj.wrp.acc.ind = cell(size(a.s.rowSets)); % Componential Acceleration
    % descr. stats over time-warped trajs
    a.trj.wrp.spd.avg = cell(size(a.s.rowSets));
    a.trj.wrp.spd.std = cell(size(a.s.rowSets));
    a.trj.wrp.vel.avg = cell(size(a.s.rowSets));
    a.trj.wrp.vel.std = cell(size(a.s.rowSets));
    a.trj.wrp.acc.avg = cell(size(a.s.rowSets));
    a.trj.wrp.acc.std = cell(size(a.s.rowSets));
end

% aligned (interpolated to constant time interval)
if a.s.doCompute_aligned
    % individual aligned trajs
    a.trj.alg.pos.ind = cell(size(a.s.rowSets));
    % descr. stats over aligned trajs
    a.trj.alg.pos.avg = cell(size(a.s.rowSets));
    a.trj.alg.pos.std = cell(size(a.s.rowSets));
    if a.s.doCompute_spdVelAcc
        % individual aligned trajs
        a.trj.alg.acc.ind = cell(size(a.s.rowSets));
        a.trj.alg.spd.ind = cell(size(a.s.rowSets));
        a.trj.alg.vel.ind = cell(size(a.s.rowSets));
        % descr. stats over aligned trajs
        a.trj.alg.spd.avg = cell(size(a.s.rowSets));
        a.trj.alg.spd.std = cell(size(a.s.rowSets));
        a.trj.alg.vel.avg = cell(size(a.s.rowSets));
        a.trj.alg.vel.std = cell(size(a.s.rowSets));
        a.trj.alg.acc.avg = cell(size(a.s.rowSets));
        a.trj.alg.acc.std = cell(size(a.s.rowSets));
    end
end

% scalar descriptive values derived from trajectories
if a.s.doCompute_aucMaxDev
    % individual trajectories
    a.trj.wrp.mDev.ind = cell(size(a.s.rowSets));  % Maximum deviation orthogonal to direct path (negative = left of ideal path); based on x-values over time values.
    a.trj.wrp.auc.ind = cell(size(a.s.rowSets)); % Area under curve (deviation toward left of ideal path counts negatively, rightward counts positively) for x-values (deviation) over *time*.
    % descr. stats
    a.trj.wrp.mDev.avg = nan(size(a.s.rowSets));
    a.trj.wrp.mDev.std = nan(size(a.s.rowSets));
    a.trj.wrp.auc.avg = nan(size(a.s.rowSets));
    a.trj.wrp.auc.std = nan(size(a.s.rowSets));
end


%% compute

% interpolate individual trajectories and compute descriptive scalar values
% (loop through sets in a.s.rowSets)

for curNdx = 1:numel(a.s.rowSets)
    
    % Get trajectories from trajecotry matrix, and corresponding results rows
    curTrSet = a.tr(a.s.rowSets{curNdx});
    curRsSet = a.rs(a.s.rowSets{curNdx},:);
    
    % Non-interpolated trajectories, store in cell array  (same size and dimensionality as a.s.rowSets)
    a.trj.raw.pos.ind{curNdx} = curTrSet;
    
    % Compute speed, x- and y- velocity and acceleration based on raw trajectories
    if a.s.doCompute_spdVelAcc
        a.trj.raw.spd.ind{curNdx} = trajSpeed(a.trj.raw.pos.ind{curNdx},[a.s.trajCols.x,a.s.trajCols.y],a.s.trajCols.t,a.s.trajCols.x);
        a.trj.raw.vel.ind{curNdx} = trajVelocity(a.trj.raw.pos.ind{curNdx},[a.s.trajCols.x,a.s.trajCols.y],a.s.trajCols.t,'drop');
        a.trj.raw.acc.ind{curNdx} = trajVelocity(a.trj.raw.vel.ind{curNdx},[a.s.trajCols.x,a.s.trajCols.y],a.s.trajCols.t,'drop');
    end
                
    % Interpolate to fixed number of data points, then store in cell array  (same size and dimensionality as a.s.rowSets)
    if a.s.USE_TEMPORAL_NORMALIZATION_NOT_SPATIAL_PROTOTYPE
        a.trj.wrp.pos.ind{curNdx} =         trajInter(curTrSet,a.s.nQueryPointsForInterp,[a.s.trajCols.x,a.s.trajCols.y],a.s.trajCols.t,a.s.interpMethod);
        
    else
        % -------------------------------------------------------------
        % PROTOTYPE!!!! When disabling uncomment above code line
        % INTERPOLATE SPATIALLY OVER Y-AXIS (PERCENTUAL PROGRESSION TO TARGET PARALLEL TO DIRECT PATH)
        % note that trajectories are removed for this where there is movement
        % exactly orthogonal to direct path (and I think also overshoots beyond
        % tgt)
        %
        % NOTE: This works it seems, but I think the trajectories discarded below due
        % to overshooting beyond target are not taken into account for
        % computing case numbers for some reason (probably happens before or
        % based on another array); also check whether this should be done for
        % other arrays or whether it already impacts everything...
        %
        for i = 1:3
            warning('!!! Using PROTOTYPE spatial interpolation instead of time-normalization !!!');
        end
        % discard back-curved trajectories (i.e., where final y-data is not the highest one)
        curTrSet = curTrSet(cellfun(@(cts) cts(end,a.s.trajCols.y)==max(cts(:,a.s.trajCols.y)),curTrSet));
        % remove non-monotonically increasing sections along y-axis (direct path)
        if ~isempty(curTrSet)
            for trNum = 1:numel(curTrSet)
                %if ~all(diff(curTrSet{trNum}(:,a.s.trajCols.y))>0)
                while any(diff(curTrSet{trNum}(:,a.s.trajCols.y))<=0)
                    curTrSet{trNum} = curTrSet{trNum}(logical([1;diff(curTrSet{trNum}(:,a.s.trajCols.y))>0]),:);
                end
                %end
            end
        end
        %
        % discard trajectories with horizontal movement (directly successive identical y-data)
        %curTrSet = curTrSet(cellfun(@(cts) all(diff(cts(:,a.s.trajCols.y))>0),curTrSet));
        %
        % instead of discarding trials with purely horizontal portions, remove successive data
        % points with identical y-values keeping only the last one
        curTrSet = cellfun(@(cts)   cts(flipud([1;diff(flipud(cts(:,a.s.trajCols.y)))]~=0),:) ,curTrSet, 'uniformoutput',0);
        %
        % normalize y-data by highest y-value
        for ct = 1:numel(curTrSet)
            curTrSet{ct}(:,a.s.trajCols.y) = curTrSet{ct}(:,a.s.trajCols.y)/max(curTrSet{ct}(:,a.s.trajCols.y));
        end
        % interpolate
        curTrSet = trajInter(curTrSet,a.s.nQueryPointsForInterp,[a.s.trajCols.x,a.s.trajCols.t],a.s.trajCols.y,a.s.interpMethod);
        % Reorder columns NOTE THAT THE ORDER IS HARDCODED AND NOT SENSITIVE TO
        % WHAT IS SPECIFIC IN TRAJCOLS! THIS MUST BE GENERALIZED BEFORE USING
        % THAT CODE
        a.trj.wrp.pos.ind{curNdx} = cellfun(@(cts)  [cts(:,1),cts(:,3),cts(:,2)],curTrSet,'uniformoutput',0);
        %---------------------------------------------------------------
    end
    
    if a.s.doCompute_spdVelAcc
        a.trj.wrp.spd.ind{curNdx} =      trajInter(a.trj.raw.spd.ind{curNdx},a.s.nQueryPointsForInterp,[a.s.trajCols.x,a.s.trajCols.y],a.s.trajCols.t,a.s.interpMethod);
        a.trj.wrp.vel.ind{curNdx} =      trajInter(a.trj.raw.vel.ind{curNdx},a.s.nQueryPointsForInterp,[a.s.trajCols.x,a.s.trajCols.y],a.s.trajCols.t,a.s.interpMethod);
        a.trj.wrp.acc.ind{curNdx} =      trajInter(a.trj.raw.acc.ind{curNdx},a.s.nQueryPointsForInterp,[a.s.trajCols.x,a.s.trajCols.y],a.s.trajCols.t,a.s.interpMethod);
    end
    
    % Interpolate with constant sampling interval, then store in cell array  (same size and dimensionality as a.s.rowSets)
    if a.s.doCompute_aligned
        a.trj.alg.pos.ind{curNdx} =    trajInterMatch(curTrSet,             a.s.samplingPeriodForInterp,[a.s.trajCols.x,a.s.trajCols.y],a.s.trajCols.t,a.s.interpMethod);
        if a.s.doCompute_spdVelAcc
            a.trj.alg.spd.ind{curNdx} = trajInterMatch(a.trj.raw.spd.ind{curNdx},a.s.samplingPeriodForInterp,[a.s.trajCols.x,a.s.trajCols.y],a.s.trajCols.t,a.s.interpMethod);
            a.trj.alg.vel.ind{curNdx} = trajInterMatch(a.trj.raw.vel.ind{curNdx},a.s.samplingPeriodForInterp,[a.s.trajCols.x,a.s.trajCols.y],a.s.trajCols.t,a.s.interpMethod);
            a.trj.alg.acc.ind{curNdx} = trajInterMatch(a.trj.raw.acc.ind{curNdx},a.s.samplingPeriodForInterp,[a.s.trajCols.x,a.s.trajCols.y],a.s.trajCols.t,a.s.interpMethod);
        end
    end            
    
    % Compute max deviation and area under curve for each trajectory, based
    % on the warped interpolated version (the choice of the used
    % trajectories is arbitrary and should not affect the outcome)
    if a.s.doCompute_aucMaxDev
        % Area under curve (negative = more deviation toward left of ideal path)
        % IMPORTANT: THIS AUC IS OF TRAJS OVER WARPED TIME! (as integrating
        % requires monotonically increasing values in domain! if the need
        % should ever arise to do it over space, polyarea might be a
        % possibility; note: before subjecting trajs to trajAUC, the rotated traj
        % is "closed" by adding a last data point with x = 0, to prevent trajAUC
        % from rotating the trajectory onto the y-axis... which has already been
        % taken care of for all trajectories)
        tmpTrs = cellfun(@(tr) [tr(:,a.s.trajCols.x),tr(:,a.s.trajCols.t);0,tr(end,a.s.trajCols.t)],a.trj.wrp.pos.ind{curNdx},'uniformoutput',0);
        a.trj.wrp.auc.ind{curNdx} = trajAuc(tmpTrs,[1 2],0,0);
        % Max deviation (negative = left of ideal path); use tmp trajs from
        % above here as well.
        a.trj.wrp.mDev.ind{curNdx} = trajMaxDev(tmpTrs,[1 2]);
    end                                    
    
        
end

%% Compute things based on already interpolated trajectories (has been done in above loop)
% PROTOTYPE START
for curNdx = 1:numel(a.s.rowSets)

    curRsSet = a.rs(a.s.rowSets{curNdx},:);
    curIndTrjs = a.trj.wrp.pos.ind{curNdx};
                
    % momentary angular deviation from direction toward specific item (unsigned)
    
    % get position of items of interest for each trial from results matrix
    tgt_xy =  [curRsSet( sub2ind(size(curRsSet), (1:size(curRsSet,1))' ,  a.s.resCols.horzPosStart-1  + curRsSet(:,a.s.resCols.tgt)) ), ...
        curRsSet( sub2ind(size(curRsSet), (1:size(curRsSet,1))' ,  a.s.resCols.vertPosStart-1  + curRsSet(:,a.s.resCols.tgt)) )];
    ref_xy =  [curRsSet( sub2ind(size(curRsSet), (1:size(curRsSet,1))' ,  a.s.resCols.horzPosStart-1  + curRsSet(:,a.s.resCols.ref)) ), ...
        curRsSet( sub2ind(size(curRsSet), (1:size(curRsSet,1))' ,  a.s.resCols.vertPosStart-1  + curRsSet(:,a.s.resCols.ref)) )];
    dtr_xy =  [curRsSet( sub2ind(size(curRsSet), (1:size(curRsSet,1))' ,  a.s.resCols.horzPosStart-1  + curRsSet(:,a.s.resCols.dtr)) ), ...
        curRsSet( sub2ind(size(curRsSet), (1:size(curRsSet,1))' ,  a.s.resCols.vertPosStart-1  + curRsSet(:,a.s.resCols.dtr)) )];        
    
    % TEST: make trajectories straightly going to target
    %np = a.s.nQueryPointsForInterp;    
    %curIndTrjs = cellfun(@(tr,tgt_y)  [zeros(np,1),linspace(0,tgt_y,np)',tr(:,3)] ,curIndTrjs,num2cell(tgt_xy(:,2)),'uniformoutput',0);
    % TEST END
    
    % get angle (yields a single column in each cell)
    
    a.trj.wrp.ang.tgt.ind{curNdx} = trajAngleToPoint_WIP(curIndTrjs,tgt_xy,[a.s.trajCols.x,a.s.trajCols.y],'single');
    a.trj.wrp.ang.ref.ind{curNdx} = trajAngleToPoint_WIP(curIndTrjs,ref_xy,[a.s.trajCols.x,a.s.trajCols.y],'single');
    a.trj.wrp.ang.dtr.ind{curNdx} = trajAngleToPoint_WIP(curIndTrjs,dtr_xy,[a.s.trajCols.x,a.s.trajCols.y],'single');             
    
    % a.trj.wrp.ang.tgt.ind{curNdx} = trajAngleToPointVersusTgt_WIP(curIndTrjs,tgt_xy,ref_xy,[a.s.trajCols.x,a.s.trajCols.y],'single');
    % a.trj.wrp.ang.ref.ind{curNdx} = trajAngleToPointVersusTgt_WIP(curIndTrjs,ref_xy,dtr_xy,[a.s.trajCols.x,a.s.trajCols.y],'single');
    % a.trj.wrp.ang.dtr.ind{curNdx} = trajAngleToPointVersusTgt_WIP(curIndTrjs,dtr_xy,ref_xy,[a.s.trajCols.x,a.s.trajCols.y],'single');          
    
    % a.trj.wrp.ang.tgt.ind{curNdx} = trajAngleToIorMinTgtMinConfound_WIP(curIndTrjs,ref_xy,dtr_xy,tgt_xy,[a.s.trajCols.x,a.s.trajCols.y],'single');
    
end  
% PROTOTYPE END

    
%% Descriptive stats over trajs
% (loop through cells of array holding individual trajectories)
for curNdx = 1:numel(a.trj.wrp.pos.ind)
    
    % trajs from current cell
    curTrsWarped =  a.trj.wrp.pos.ind{curNdx};
    if a.s.doCompute_aligned
        curTrsAligned =  a.trj.alg.pos.ind{curNdx};
        if a.s.doCompute_spdVelAcc
            curTrsAlignedSpd =  a.trj.alg.spd.ind{curNdx};
            curTrsAlignedVel =  a.trj.alg.vel.ind{curNdx};
            curTrsAlignedAcc =  a.trj.alg.acc.ind{curNdx};
        end
    end
    if a.s.doCompute_spdVelAcc
        curTrsWarpedSpd =  a.trj.wrp.spd.ind{curNdx};
        curTrsWarpedVel =  a.trj.wrp.vel.ind{curNdx};
        curTrsWarpedAcc =  a.trj.wrp.acc.ind{curNdx};
    end
    if a.s.doCompute_aucMaxDev
        curTrsMD =  a.trj.wrp.mDev.ind{curNdx};
        curTrsAUC =  a.trj.wrp.auc.ind{curNdx};
    end    
    % PROTOTYPE START
    curTrsWarpedAngTgt = a.trj.wrp.ang.tgt.ind{curNdx};
    curTrsWarpedAngRef = a.trj.wrp.ang.ref.ind{curNdx};
    curTrsWarpedAngDtr = a.trj.wrp.ang.dtr.ind{curNdx};
    % PROTOTYPE END
    
    % Compute means / stds and put into respective arrays
    if ~isempty(curTrsWarped)
        
        if numel(curTrsWarped) >= 2
            
            a.trj.wrp.pos.avg{curNdx} = alignedMean(curTrsWarped);
            a.trj.wrp.pos.std{curNdx} = alignedStd(curTrsWarped);
            if a.s.doCompute_spdVelAcc
                a.trj.wrp.spd.avg{curNdx} = alignedMean(curTrsWarpedSpd);
                a.trj.wrp.spd.std{curNdx} = alignedStd(curTrsWarpedSpd);
                a.trj.wrp.vel.avg{curNdx} = alignedMean(curTrsWarpedVel);
                a.trj.wrp.vel.std{curNdx} = alignedStd(curTrsWarpedVel);
                a.trj.wrp.acc.avg{curNdx} = alignedMean(curTrsWarpedAcc);
                a.trj.wrp.acc.std{curNdx} = alignedStd(curTrsWarpedAcc);
            end
            
            if a.s.doCompute_aligned
                a.trj.alg.pos.avg{curNdx} = alignedMean(curTrsAligned,0,1,a.s.padAlignedToLength);
                a.trj.alg.pos.std{curNdx} = alignedStd(curTrsAligned,0,1,1,a.s.padAlignedToLength);
                if a.s.doCompute_spdVelAcc
                    a.trj.alg.spd.avg{curNdx} = alignedMean(curTrsWarpedSpd,0,1,a.s.padAlignedToLength);
                    a.trj.alg.spd.std{curNdx} = alignedStd(curTrsAlignedSpd,0,1,1,a.s.padAlignedToLength);
                    a.trj.alg.vel.avg{curNdx} = alignedMean(curTrsWarpedVel,0,1,a.s.padAlignedToLength);
                    a.trj.alg.vel.std{curNdx} = alignedStd(curTrsAlignedVel,0,1,1,a.s.padAlignedToLength);
                    a.trj.alg.acc.avg{curNdx} = alignedMean(curTrsAlignedAcc,0,1,a.s.padAlignedToLength);
                    a.trj.alg.acc.std{curNdx} = alignedStd(curTrsAlignedAcc,0,1,1,a.s.padAlignedToLength);
                end
            end
            
            if a.s.doCompute_aucMaxDev
                a.trj.wrp.mDev.avg(curNdx)= mean(curTrsMD);
                a.trj.wrp.mDev.std(curNdx)= std(curTrsMD);
                a.trj.wrp.auc.avg(curNdx)= mean(curTrsAUC);
                a.trj.wrp.auc.std(curNdx)= std(curTrsAUC);
            end
            
            % PROTOTYPE START
            a.trj.wrp.ang.tgt.avg{curNdx} = alignedMean(curTrsWarpedAngTgt);
            a.trj.wrp.ang.tgt.std{curNdx} = alignedStd(curTrsWarpedAngTgt);
            a.trj.wrp.ang.ref.avg{curNdx} = alignedMean(curTrsWarpedAngRef);
            a.trj.wrp.ang.ref.std{curNdx} = alignedStd(curTrsWarpedAngRef);
            a.trj.wrp.ang.dtr.avg{curNdx} = alignedMean(curTrsWarpedAngDtr);
            a.trj.wrp.ang.dtr.std{curNdx} = alignedStd(curTrsWarpedAngDtr);
            % PROTOTYPE END
            
        else
            
            a.trj.wrp.pos.avg{curNdx} = curTrsWarped{1};
            a.trj.wrp.pos.std{curNdx} = zeros(size(curTrsWarped{1}));
            
            if a.s.doCompute_spdVelAcc
                a.trj.wrp.spd.avg{curNdx} = curTrsWarpedSpd{1};
                a.trj.wrp.spd.std{curNdx} = zeros(size(curTrsWarpedSpd{1}));
                a.trj.wrp.vel.avg{curNdx} = curTrsWarpedVel{1};
                a.trj.wrp.vel.std{curNdx} = zeros(size(curTrsWarpedVel{1}));
                a.trj.wrp.acc.avg{curNdx} = curTrsWarpedAcc{1};
                a.trj.wrp.acc.std{curNdx} = zeros(size(curTrsWarpedAcc{1}));
            end
            
            if a.s.doCompute_aligned
                a.trj.alg.pos.avg{curNdx} = [curTrsAligned{1};NaN(a.s.padAlignedToLength-size(curTrsAligned{1},1),size(curTrsAligned{1},2))];
                a.trj.alg.pos.std{curNdx} = zeros(a.s.padAlignedToLength,size(curTrsAligned{1},2));
                if a.s.doCompute_spdVelAcc
                    a.trj.alg.spd.avg{curNdx} = [curTrsAlignedSpd{1};NaN(a.s.padAlignedToLength-size(curTrsAlignedSpd{1},1),size(curTrsAlignedSpd{1},2))];
                    a.trj.alg.spd.std{curNdx} = zeros(a.s.padAlignedToLength,size(curTrsAlignedSpd{1},2));
                    a.trj.alg.vel.avg{curNdx} = [curTrsAlignedVel{1};NaN(a.s.padAlignedToLength-size(curTrsAlignedVel{1},1),size(curTrsAlignedVel{1},2))];
                    a.trj.alg.vel.std{curNdx} = zeros(a.s.padAlignedToLength,size(curTrsAlignedVel{1},2));
                    a.trj.alg.acc.avg{curNdx} = [curTrsAlignedAcc{1};NaN(a.s.padAlignedToLength-size(curTrsAlignedAcc{1},1),size(curTrsAlignedAcc{1},2))];
                    a.trj.alg.acc.std{curNdx} = zeros(a.s.padAlignedToLength,size(curTrsAlignedAcc{1},2));
                end
            end
            
            if a.s.doCompute_aucMaxDev
                a.trj.wrp.mDev.avg(curNdx)= curTrsMD;
                a.trj.wrp.mDev.std(curNdx)= 0;
                a.trj.wrp.auc.avg(curNdx)= curTrsAUC;
                a.trj.wrp.auc.std(curNdx)= 0;
            end
            
            % PROTOTYPE START
            a.trj.wrp.ang.tgt.avg{curNdx} = curTrsWarpedAngTgt{1};
            a.trj.wrp.ang.tgt.std{curNdx} = zeros(size(curTrsWarpedAngTgt{1}));
            a.trj.wrp.ang.ref.avg{curNdx} = curTrsWarpedAngRef{1};
            a.trj.wrp.ang.ref.std{curNdx} = zeros(size(curTrsWarpedAngRef{1}));
            a.trj.wrp.ang.dtr.avg{curNdx} = curTrsWarpedAngDtr{1};
            a.trj.wrp.ang.dtr.std{curNdx} = zeros(size(curTrsWarpedAngDtr{1}));
            % PROTOTYPE END
            
        end
        
    end
    
end


%% Descriptive statistics from matrix a.rs (results)

% get sets of results rows for each combination of IVs as basis
a.res.ind = cell(size(a.s.rowSets));
for curNdx = 1:numel(a.s.rowSets)
    % Get rsults rows from rsults matrix
    curRsSet = a.rs(a.s.rowSets{curNdx},:);
    % store in cell array (same size and dimensionality as a.s.rowSets)
    a.res.ind{curNdx} = curRsSet;
end

% do that also for logical list of which trajectories were flipped in
% mirrorSomeTrajectories.m
if a.s.someFlippingHasOccurred
    a.res.flipped = cell(size(a.s.rowSets));
    for curNdx = 1:numel(a.s.rowSets)
        curRsSet = a.s.flipDone(a.s.rowSets{curNdx},:);
        a.res.flipped{curNdx} = curRsSet;
    end
end

% compute descriptive statistics for each set of results rows (these are
% computed for all columns just because it's simpler; most of these values
% make little sense)
a.res.avg = cellfun(@(x) mean(x,1), a.res.ind,'uniformoutput',0);
a.res.std = cellfun(@(x) std(x,1,1), a.res.ind,'uniformoutput',0);
a.res.ncs = cellfun(@(x) size(x,1), a.res.ind);




%% Delete temp variables
% this is skipped when script file is called from subtractIVAverage
% (because some variables beyond the ones here need to be retained in that case)
if ~exist('skipVariableDeletionInComputeStatistics','var') || skipVariableDeletionInComputeStatistics==0
    clearvars -except a e tg aTmp
end