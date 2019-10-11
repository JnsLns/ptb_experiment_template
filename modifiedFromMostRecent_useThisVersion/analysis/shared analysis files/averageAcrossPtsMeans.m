% This script averages the contents of cells in a.trj and a.res
% along the particpants-dimension, in order to obtain an overall mean of
% mean trajectories for plotting.
%
% At the current stage of analysis, the participants-dimension is expected
% to be defined in the LAST ROW of cell array ivs (which is ensured to be the
% case by adding it in addPtsAsLastRowInIvs.m) and, correspondingly, to
% constitute the LAST DIMENSION in data cell arrays (such as those contained
% in the highest-level fields of a.trj and a.res).
%
% !!! IMPORTANT NOTE regarding standard deviations !!!
%
% Standard deviations computed here are afterwards found in struct fields
% ending with ".std", and are standard deviations between the means of the
% individual participants, that is, the between-subject standard deviation.
% This is the deviation that also matters for paired-sample t-tests BUT it
% does not say anything about trial-to-trial variability (in other words,
% the participants are regarded as the statistical ensemble).
% The field ".meanStd" is added here, holding the mean across the individual
% standard deviations of all the participants. This gives an idea of
% trial-to-trial variation but is not really a commonly used descriptive
% statistic (it may be useful though to plot it, depending on what aspect of
% the data one is interested in).

if a.s.averageAcrossParticipantMeans 

    disp('Averaging across participant means. (note: a.byPts.res & a.byPts.res hold non-averaged data for stat. test.)');
    
    doDeleteIvsPtsRow = 1;
    
% participant dimension of result and trajectory cell arrays (also row in
% ivs holding participant IV information; should usually be the last one)
if ~strcmp(a.s.ivs{a.s.ptsDim,1},'internalPtsDim')    
    waitfor(msgbox(['Averaging over participants is enabled, but the row of a.s.ivs that is set ' ...
        'to be the participant dimension (the last one, i.e. dim. ' num2str(a.s.ptsDim) ') is not ' ...
        'named "internalPtsDim" as expected. One explanation may be that this data set has ' ...
        'already been run through analysis ' ... 
        'before, in which case that row has already been deleted from ivs. I am still using that '...
        'dimension, as it is probably included in the newly computed data arrays ' ...
        '(i.e., I am averaging across data cells along that dimension). However, I am not going ' ...
        'to delete the last row of ivs afterwards as usual. Be sure to check whether this is correct. '...
        'In most cases when this occurs, something is wrong.']));     
    doDeleteIvsPtsRow = 0;
end

% Backup results and trajectory arrays with participants still listed
% separately -- use these for paired-sample/rmAnova testing
% last dimension is participants
a.byPts.res = a.res;
a.byPts.trj = a.trj;


% in case only the participant dimension remains (i.e., no other IVs have
% been defined) set a.s.ptsDim to 2, since participants correspond to
% columns in that special case.
if a.s.ptsDim == 1
    a.s.ptsDim = 2;
end

% Then aggregate across participants for plotting single mean curves

% ---.res 


if a.s.someFlippingHasOccurred
    a.res.flipped = cellCollapse(a.res.flipped,a.s.ptsDim,1);
end
a.res.ind = cellCollapse(a.res.ind,a.s.ptsDim,1); 
a.res.ncs = sum(a.res.ncs,a.s.ptsDim);
% note: needs to be done before .std is collapsed across pts!
a.res.meanStd = cellMean(a.res.std,a.s.ptsDim,0,0);
% note: needs to be done before .avg is collapsed across pts!
a.res.std = cellfun(@(collapsedData) std(collapsedData,0,1),cellCollapse(a.res.avg,a.s.ptsDim,1),'uniformoutput',0); 
% note: do this only after computing std between pts
a.res.avg = cellMean(a.res.avg,a.s.ptsDim,0,0);

% --- .trj

% - .ind

a.trj.raw.pos.ind = cellCollapse(a.trj.raw.pos.ind,a.s.ptsDim,1);
if a.s.doCompute_spdVelAcc
    a.trj.raw.spd.ind = cellCollapse(a.trj.raw.spd.ind,a.s.ptsDim,1);
    a.trj.raw.vel.ind = cellCollapse(a.trj.raw.vel.ind,a.s.ptsDim,1);
    a.trj.raw.acc.ind = cellCollapse(a.trj.raw.acc.ind,a.s.ptsDim,1);
end

% - .wrp

a.trj.wrp.pos.ind = cellCollapse(a.trj.wrp.pos.ind,a.s.ptsDim,1);
a.trj.wrp.pos.meanStd = cellMean(a.trj.wrp.pos.std,a.s.ptsDim,0,0);
a.trj.wrp.pos.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.trj.wrp.pos.avg,a.s.ptsDim,3),'uniformoutput',0); 
a.trj.wrp.pos.avg = cellMean(a.trj.wrp.pos.avg,a.s.ptsDim,0,0);


if a.s.doCompute_spdVelAcc
    a.trj.wrp.vel.ind = cellCollapse(a.trj.wrp.vel.ind,a.s.ptsDim,1);    
    a.trj.wrp.vel.meanStd = cellMean(a.trj.wrp.vel.std,a.s.ptsDim,0,0);    
    a.trj.wrp.vel.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.trj.wrp.vel.avg,a.s.ptsDim,3),'uniformoutput',0);    
    a.trj.wrp.vel.avg = cellMean(a.trj.wrp.vel.avg,a.s.ptsDim,0,0);
    
    a.trj.wrp.spd.ind = cellCollapse(a.trj.wrp.spd.ind,a.s.ptsDim,1);    
    a.trj.wrp.spd.meanStd = cellMean(a.trj.wrp.spd.std,a.s.ptsDim,0,0);
    a.trj.wrp.spd.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.trj.wrp.spd.avg,a.s.ptsDim,3),'uniformoutput',0);    
    a.trj.wrp.spd.avg = cellMean(a.trj.wrp.spd.avg,a.s.ptsDim,0,0);
    
    a.trj.wrp.acc.ind = cellCollapse(a.trj.wrp.acc.ind,a.s.ptsDim,1);    
    a.trj.wrp.acc.meanStd = cellMean(a.trj.wrp.acc.std,a.s.ptsDim,0,0);
    a.trj.wrp.acc.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.trj.wrp.acc.avg,a.s.ptsDim,3),'uniformoutput',0);    
    a.trj.wrp.acc.avg = cellMean(a.trj.wrp.acc.avg,a.s.ptsDim,0,0);
end

if a.s.doCompute_aucMaxDev
    a.trj.wrp.mDev.ind = cellCollapse(a.trj.wrp.mDev.ind,a.s.ptsDim,1);
    a.trj.wrp.mDev.meanStd = mean(a.trj.wrp.mDev.std,a.s.ptsDim);
    a.trj.wrp.mDev.std = std(a.trj.wrp.mDev.avg,0,a.s.ptsDim);
    a.trj.wrp.mDev.avg = mean(a.trj.wrp.mDev.avg,a.s.ptsDim);
    
    a.trj.wrp.auc.ind = cellCollapse(a.trj.wrp.auc.ind,a.s.ptsDim,1);
    a.trj.wrp.auc.meanStd = mean(a.trj.wrp.auc.std,a.s.ptsDim);
    a.trj.wrp.auc.std = std(a.trj.wrp.auc.avg,0,a.s.ptsDim);
    a.trj.wrp.auc.avg = mean(a.trj.wrp.auc.avg,a.s.ptsDim);
end

% PROTOTYPE START
a.trj.wrp.ang.tgt.ind = cellCollapse(a.trj.wrp.ang.tgt.ind,a.s.ptsDim,1);
a.trj.wrp.ang.tgt.meanStd = cellMean(a.trj.wrp.ang.tgt.std,a.s.ptsDim,0,0);
a.trj.wrp.ang.tgt.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.trj.wrp.ang.tgt.avg,a.s.ptsDim,3),'uniformoutput',0); 
a.trj.wrp.ang.tgt.avg = cellMean(a.trj.wrp.ang.tgt.avg,a.s.ptsDim,0,0);

a.trj.wrp.ang.ref.ind = cellCollapse(a.trj.wrp.ang.ref.ind,a.s.ptsDim,1);
a.trj.wrp.ang.ref.meanStd = cellMean(a.trj.wrp.ang.ref.std,a.s.ptsDim,0,0);
a.trj.wrp.ang.ref.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.trj.wrp.ang.ref.avg,a.s.ptsDim,3),'uniformoutput',0); 
a.trj.wrp.ang.ref.avg = cellMean(a.trj.wrp.ang.ref.avg,a.s.ptsDim,0,0);

a.trj.wrp.ang.dtr.ind = cellCollapse(a.trj.wrp.ang.dtr.ind,a.s.ptsDim,1);
a.trj.wrp.ang.dtr.meanStd = cellMean(a.trj.wrp.ang.dtr.std,a.s.ptsDim,0,0);
a.trj.wrp.ang.dtr.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.trj.wrp.ang.dtr.avg,a.s.ptsDim,3),'uniformoutput',0); 
a.trj.wrp.ang.dtr.avg = cellMean(a.trj.wrp.ang.dtr.avg,a.s.ptsDim,0,0);
% PROTOTYPE END

% - .alg

if a.s.doCompute_aligned
    a.trj.alg.pos.ind = cellCollapse(a.trj.alg.pos.ind,a.s.ptsDim,1);   
    a.trj.alg.pos.meanStd = cellMean(a.trj.alg.pos.std,a.s.ptsDim,0,0);
    a.trj.alg.pos.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.trj.alg.pos.avg,a.s.ptsDim,3),'uniformoutput',0);    
    a.trj.alg.pos.avg = cellMean(a.trj.alg.pos.avg,a.s.ptsDim,0,0);
    
    if a.s.doCompute_spdVelAcc
        a.trj.alg.vel.ind = cellCollapse(a.trj.alg.vel.ind,a.s.ptsDim,1);        
        a.trj.alg.vel.meanStd = cellMean(a.trj.alg.vel.std,a.s.ptsDim,0,0);
        a.trj.alg.vel.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.trj.alg.vel.avg,a.s.ptsDim,3),'uniformoutput',0);        
        a.trj.alg.vel.avg = cellMean(a.trj.alg.vel.avg,a.s.ptsDim,0,0);
        
        a.trj.alg.spd.ind = cellCollapse(a.trj.alg.spd.ind,a.s.ptsDim,1);        
        a.trj.alg.spd.meanStd = cellMean(a.trj.alg.spd.std,a.s.ptsDim,0,0);
        a.trj.alg.spd.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.trj.alg.spd.avg,a.s.ptsDim,3),'uniformoutput',0);        
        a.trj.alg.spd.avg = cellMean(a.trj.alg.spd.avg,a.s.ptsDim,0,0);
        
        a.trj.alg.acc.ind = cellCollapse(a.trj.alg.acc.ind,a.s.ptsDim,1);        
        a.trj.alg.acc.meanStd = cellMean(a.trj.alg.acc.std,a.s.ptsDim,0,0);
        a.trj.alg.acc.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.trj.alg.acc.avg,a.s.ptsDim,3),'uniformoutput',0);        
        a.trj.alg.acc.avg = cellMean(a.trj.alg.acc.avg,a.s.ptsDim,0,0);
    end    
end


% - fit coefficients
if a.s.doGaussFit
    tmp = a.trj.fit.gAmpl;
    a.trj.fit = rmfield(a.trj.fit,'gAmpl');
    a.trj.fit.gAmpl.avg = mean(tmp,a.s.ptsDim);
    a.trj.fit.gAmpl.std = std(tmp,0,a.s.ptsDim);
    tmp = a.trj.fit.gMean;
    a.trj.fit = rmfield(a.trj.fit,'gMean');
    a.trj.fit.gMean.avg = mean(tmp,a.s.ptsDim);
    a.trj.fit.gMean.std = std(tmp,0,a.s.ptsDim);
    tmp = a.trj.fit.gSigm;
    a.trj.fit = rmfield(a.trj.fit,'gSigm');
    a.trj.fit.gSigm.avg = mean(tmp,a.s.ptsDim);
    a.trj.fit.gSigm.std = std(tmp,0,a.s.ptsDim);
end


% Remove pts row in ivs
if doDeleteIvsPtsRow
    a.s.ivs = a.s.ivs(1:end-1,:);
end

else
    
    disp('NOT averaging across participant means.');
    
end

