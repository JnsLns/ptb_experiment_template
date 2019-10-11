% Collapses data arrays (res and trj) along the dimension representing
% balancing categories. The different levels/pages are combined using simple
% mean of means (this is true for both mean trajectories and standard
% deviation, which means that standard deviations computed here are MEAN
% STANDARD DEVIATIONS across the different balancing categories, unweighted
% by case numbers included in each input mean trajectory).
% Individual trajectory/results data in fields of struct a labeled ".ind"
% are merged.
%
% In the end, the balancing category IV is removed from a.s.ivs (updating
% a.s.ptsDim)

if a.s.balancingByMeanOfMeans
    
    warning('off','cellMeanFun:EmptyCells');
    
    % Determine IV/dimension number for balancing categories
    balIvDim = find(strcmp(a.s.ivs(:,a.s.ivsCols.name), 'internalBalancingCategoryIV'));
    
    disp(['Collapsing over balancing categories (IV/dimension ', num2str(balIvDim),  ') by computing mean of means.']);
    
    % for each condition (&pts) combination get the number of balancing categories that actually include more
    % than zero cases (this is the number that the sum along that dimension
    % needs to be divided by to get a valid mean of means even when not all
    % balancing categories include trials)
    nNonZeroBalCats = sum(a.res.ncs~=0,balIvDim);
    % display warning if any balancing categories are zero
    if min(nNonZeroBalCats(:)) < numel(a.s.ivs{balIvDim,a.s.ivsCols.values})
        fprintf(['\tNote: It seems that within some IV-levels there are zero trials\n\tfor some balancing categories. This need not be a problem if\n\tbalancing is ensured ' ...
            'in the following by combining IV-levels\n\t(proper balancing will then be re-checked in the course of\n\tcombining levels).\n']);
    end
    
    % ---.res
    
    if a.s.someFlippingHasOccurred
        a.res.flipped = cellCollapse(a.res.flipped,balIvDim,1);
    end
    a.res.ind = cellCollapse(a.res.ind,balIvDim,1);    
    a.res.std = cellMean(a.res.std,balIvDim);
    a.res.avg = cellMean(a.res.avg,balIvDim);            
    aTmp.ncs_ind = cellCollapse(num2cell(a.res.ncs),balIvDim,1); % This stores the number of cases coming from each balancing category into the mean 
    a.res.ncs = sum(a.res.ncs,balIvDim);                          
    
    % --- .trj
    
    % - .ind
    
    a.trj.raw.pos.ind = cellCollapse(a.trj.raw.pos.ind,balIvDim,1);
    if a.s.doCompute_spdVelAcc
        a.trj.raw.spd.ind = cellCollapse(a.trj.raw.spd.ind,balIvDim,1);
        a.trj.raw.vel.ind = cellCollapse(a.trj.raw.vel.ind,balIvDim,1);
        a.trj.raw.acc.ind = cellCollapse(a.trj.raw.acc.ind,balIvDim,1);
    end
            
    % - .wrp
    
    a.trj.wrp.pos.ind = cellCollapse(a.trj.wrp.pos.ind,balIvDim,1);
    a.trj.wrp.pos.std = cellMean(a.trj.wrp.pos.std,balIvDim);            
    a.trj.wrp.pos.avg = cellMean(a.trj.wrp.pos.avg,balIvDim);
    
    if a.s.doCompute_spdVelAcc
        a.trj.wrp.vel.ind = cellCollapse(a.trj.wrp.vel.ind,balIvDim,1);
        a.trj.wrp.vel.std = cellMean(a.trj.wrp.vel.std,balIvDim);
        a.trj.wrp.vel.avg = cellMean(a.trj.wrp.vel.avg,balIvDim);
        
        a.trj.wrp.spd.ind = cellCollapse(a.trj.wrp.spd.ind,balIvDim,1);
        a.trj.wrp.spd.std = cellMean(a.trj.wrp.spd.std,balIvDim);
        a.trj.wrp.spd.avg = cellMean(a.trj.wrp.spd.avg,balIvDim);
        
        a.trj.wrp.acc.ind = cellCollapse(a.trj.wrp.acc.ind,balIvDim,1);
        a.trj.wrp.acc.std = cellMean(a.trj.wrp.acc.std,balIvDim);
        a.trj.wrp.acc.avg = cellMean(a.trj.wrp.acc.avg,balIvDim);                
    end
               
    if a.s.doCompute_aucMaxDev
        a.trj.wrp.mDev.ind = cellCollapse(a.trj.wrp.mDev.ind,balIvDim,1);        
        a.trj.wrp.mDev.std = cell2mat(cellMean(num2cell(a.trj.wrp.mDev.std),balIvDim));                 
        a.trj.wrp.mDev.avg = cell2mat(cellMean(num2cell(a.trj.wrp.mDev.avg),balIvDim));                                                
        
        a.trj.wrp.auc.ind = cellCollapse(a.trj.wrp.auc.ind,balIvDim,1);                
        a.trj.wrp.auc.std = cell2mat(cellMean(num2cell(a.trj.wrp.auc.std),balIvDim));                 
        a.trj.wrp.auc.avg = cell2mat(cellMean(num2cell(a.trj.wrp.auc.avg),balIvDim));                 
    end
    
       
    % PROTOTYPE START 
    a.trj.wrp.ang.tgt.ind = cellCollapse(a.trj.wrp.ang.tgt.ind,balIvDim,1);
    a.trj.wrp.ang.tgt.std = cellMean(a.trj.wrp.ang.tgt.std,balIvDim);       
    a.trj.wrp.ang.tgt.avg = cellMean(a.trj.wrp.ang.tgt.avg,balIvDim);   
    
    a.trj.wrp.ang.ref.ind = cellCollapse(a.trj.wrp.ang.ref.ind,balIvDim,1);
    a.trj.wrp.ang.ref.std = cellMean(a.trj.wrp.ang.ref.std,balIvDim);       
    a.trj.wrp.ang.ref.avg = cellMean(a.trj.wrp.ang.ref.avg,balIvDim);   
    
    a.trj.wrp.ang.dtr.ind = cellCollapse(a.trj.wrp.ang.dtr.ind,balIvDim,1);
    a.trj.wrp.ang.dtr.std = cellMean(a.trj.wrp.ang.dtr.std,balIvDim);       
    a.trj.wrp.ang.dtr.avg = cellMean(a.trj.wrp.ang.dtr.avg,balIvDim);   
    % PROTOTYPE END 
    
    % - .alg
    
    if a.s.doCompute_aligned
     
        a.trj.alg.pos.ind = cellCollapse(a.trj.alg.pos.ind,balIvDim,1);
        a.trj.alg.pos.std = cellMean(a.trj.alg.pos.std,balIvDim);
        a.trj.alg.pos.avg = cellMean(a.trj.alg.pos.avg,balIvDim);
        
        if a.s.doCompute_spdVelAcc
            a.trj.alg.vel.ind = cellCollapse(a.trj.alg.vel.ind,balIvDim,1);
            a.trj.alg.vel.std = cellMean(a.trj.alg.vel.std,balIvDim);
            a.trj.alg.vel.avg = cellMean(a.trj.alg.vel.avg,balIvDim);
            
            a.trj.alg.spd.ind = cellCollapse(a.trj.alg.spd.ind,balIvDim,1);
            a.trj.alg.spd.std = cellMean(a.trj.alg.spd.std,balIvDim);
            a.trj.alg.spd.avg = cellMean(a.trj.alg.spd.avg,balIvDim);
            
            a.trj.alg.acc.ind = cellCollapse(a.trj.alg.acc.ind,balIvDim,1);
            a.trj.alg.acc.std = cellMean(a.trj.alg.acc.std,balIvDim);
            a.trj.alg.acc.avg = cellMean(a.trj.alg.acc.avg,balIvDim);
        end
        
    end
    
    % Remove balancing category row in ivs
    a.s.ivs(balIvDim,:) = [];        
    
    % Check whether ncs array has more than one (i.e., balIvDim) singleton
    % dimension; this should not be the case, as all of these are squeezed
    % out here, and there is no good reason why there should be more...
    if sum(size(a.res.ncs)==1)>1
        error(['There are multiple singleton dimensions in the data arrays (tested for a.res.ncs). This ', ...
            'should not be the case at this point of the analysis pipeline, because (a) all singleton ', ...
            'dimensions are squeezed out next, which will wreak hazard if there are erroneous ones, ', ...
            'and (b) there is no good reason why there should be a singleton dimension at this point ', ...
            '(except for the former balancing category dimension, which the squeezing out is meant for).']);
    end
        
    % Squeeze out now-singleton dimension of balancing categories from all data arrays:    
    % Get highest layer field "addresses" in struct a
    a_dataFieldNames = findStructBranchEnds(a);
    % among these, find all res and trj branch ends 
    a_avgLogicalNdcs = contains(a_dataFieldNames,'.trj.') | contains(a_dataFieldNames,'.res.');    
    % get the actual field names in struct
    a_dataFieldNames_trjRes = a_dataFieldNames(a_avgLogicalNdcs);
    % iterate over these, squeezing out the (now singleton) balancing category dimension
    for curField = a_dataFieldNames_trjRes'       
        eval([curField{:},'=squeeze(',curField{:},');']);        
    end
    aTmp.ncs_ind =  squeeze(aTmp.ncs_ind);
    
    % Update number of participant dimension
    if a.s.averageAcrossParticipantMeans
        newPtsDim = find(strcmp('internalPtsDim',a.s.ivs(:,a.s.ivsCols.name)));                        
        if newPtsDim ~= a.s.ptsDim 
            disp([char(9), 'Updating a.s.ptsDim from ' num2str(a.s.ptsDim) ' to ' num2str(newPtsDim) ' (since balancing cat. IV was removed).'])
            a.s.ptsDim = newPtsDim;
        end
    end
    
    warning('on','cellMeanFun:EmptyCells');
    
    clearvars -except a e tg aTmp    
    
end