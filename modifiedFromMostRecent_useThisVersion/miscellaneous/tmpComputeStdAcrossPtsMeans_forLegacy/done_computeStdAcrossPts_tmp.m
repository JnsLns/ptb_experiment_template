% This computes standard deviation across participants for existing
% analysis output files and saves the new info in a new file, same
% location with _btwPtsStd added; This is only needed for older analysis
% output stemming from a version of analysis where .std was not between-
% participants standard deviation by default (but instead mean std across pts).

% Just run and select one or multiple analysis output files

function TMPcomputeStdAcrossPts

[f,p] = uigetfile('multiselect','on');

if ~iscell(f); f = {f}; end

for curFile = f
        
    load([p,curFile{:}]);
    
    ptsDim = size(a.s.ivs,1)+1;
    
    % ---.res
    % note: needs to be done before .std is collapsed across pts!
    a.res.meanStd = cellfun(@(sumCell) sumCell/size(a.byPts.res.std,ptsDim),  cellSum(a.byPts.res.std,ptsDim,0,0), 'uniformoutput',0);
    % note: needs to be done before .avg is collapsed across pts!
    a.res.std = cellfun(@(collapsedData) std(collapsedData,0,1),cellCollapse(a.byPts.res.avg,ptsDim,1),'uniformoutput',0);
    % --- .trj
    % - .wrp
    a.trj.wrp.pos.meanStd = cellfun(@(sumCell) sumCell/size(a.byPts.trj.wrp.pos.std,ptsDim), cellSum(a.byPts.trj.wrp.pos.std,ptsDim,0,0), 'uniformoutput', 0);
    a.trj.wrp.pos.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.byPts.trj.wrp.pos.avg,ptsDim,3),'uniformoutput',0);
    a.trj.wrp.vel.meanStd = cellfun(@(sumCell) sumCell/size(a.byPts.trj.wrp.vel.std,ptsDim), cellSum(a.byPts.trj.wrp.vel.std,ptsDim,0,0), 'uniformoutput', 0);
    a.trj.wrp.vel.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.byPts.trj.wrp.vel.avg,ptsDim,3),'uniformoutput',0);
    a.trj.wrp.spd.meanStd = cellfun(@(sumCell) sumCell/size(a.byPts.trj.wrp.spd.std,ptsDim), cellSum(a.byPts.trj.wrp.spd.std,ptsDim,0,0), 'uniformoutput', 0);
    a.trj.wrp.spd.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.byPts.trj.wrp.spd.avg,ptsDim,3),'uniformoutput',0);
    a.trj.wrp.acc.meanStd = cellfun(@(sumCell) sumCell/size(a.byPts.trj.wrp.acc.std,ptsDim), cellSum(a.byPts.trj.wrp.acc.std,ptsDim,0,0), 'uniformoutput', 0);
    a.trj.wrp.acc.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.byPts.trj.wrp.acc.avg,ptsDim,3),'uniformoutput',0);
    a.trj.wrp.mDev.meanStd = sum(a.byPts.trj.wrp.mDev.std,ptsDim)./size(a.byPts.trj.wrp.mDev.std,ptsDim);
    a.trj.wrp.mDev.std = std(a.byPts.trj.wrp.mDev.avg,0,ptsDim);
    a.trj.wrp.auc.meanStd = sum(a.byPts.trj.wrp.auc.std,ptsDim)./size(a.byPts.trj.wrp.auc.std,ptsDim);
    a.trj.wrp.auc.std = std(a.byPts.trj.wrp.auc.avg,0,ptsDim);
    % - .alg
    a.trj.alg.pos.meanStd = cellfun(@(sumCell) sumCell/size(a.byPts.trj.alg.pos.std,ptsDim), cellSum(a.byPts.trj.alg.pos.std,ptsDim,0,0), 'uniformoutput', 0);
    a.trj.alg.pos.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.byPts.trj.alg.pos.avg,ptsDim,3),'uniformoutput',0);
    a.trj.alg.vel.meanStd = cellfun(@(sumCell) sumCell/size(a.byPts.trj.alg.vel.std,ptsDim), cellSum(a.byPts.trj.alg.vel.std,ptsDim,0,0), 'uniformoutput', 0);
    a.trj.alg.vel.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.byPts.trj.alg.vel.avg,ptsDim,3),'uniformoutput',0);
    a.trj.alg.spd.meanStd = cellfun(@(sumCell) sumCell/size(a.byPts.trj.alg.spd.std,ptsDim), cellSum(a.byPts.trj.alg.spd.std,ptsDim,0,0), 'uniformoutput', 0);
    a.trj.alg.spd.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.byPts.trj.alg.spd.avg,ptsDim,3),'uniformoutput',0);
    a.trj.alg.acc.meanStd = cellfun(@(sumCell) sumCell/size(a.byPts.trj.alg.acc.std,ptsDim), cellSum(a.byPts.trj.alg.acc.std,ptsDim,0,0), 'uniformoutput', 0);
    a.trj.alg.acc.std = cellfun(@(collapsedData) std(collapsedData,0,3), cellCollapse(a.byPts.trj.alg.acc.avg,ptsDim,3),'uniformoutput',0);
    
    %% Plot
    
    aTmp.plotWhat_tr_errors = a.trj.wrp.pos.std;
    TMPplotTrajData;
    
    useFileName = curFile{:};
    useFileName(strfind(useFileName,'.mat'):end) = [];
    save([p,useFileName,'_btwPtsStd','.mat'],'a','aTmp');
    
    clearvars -except 'p' 'f' 'curFile';
    
end


end



