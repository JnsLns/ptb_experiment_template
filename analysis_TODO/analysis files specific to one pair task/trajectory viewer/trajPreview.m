if aTmp.showIndivTrajPreview 
    
    disp('Showing trajectory preview. Close figure to go on...');
    
    if isfield(aTmp,'discardedTrialsDueToCurvature')
        nonDiscardedTrials = ~aTmp.discardedTrialsDueToCurvature;
    else
        nonDiscardedTrials = ones(numel(a.rawDatBAK.tr),1);
    end
    
    %view raw trajectories and cut/translated/rotated ones in comparison
    %(raw trajectories in top plot). Note that no trajectories are
    %excluded, except for those that were discarded due to high curvature.
    
    
    trajViewerComparison(...
        a.rawDatBAK.tr, ...
        a.rawDatBAK.rs, ...
        [0 a.s.presArea_mm(1)], ...
        [0 a.s.presArea_mm(2)], ...
        a.tr, ...
        a.rs, ...
        [-a.s.presArea_mm(1)/2 a.s.presArea_mm(1)/2], ....
        [0 a.s.presArea_mm(2)], ...
        a.s.resCols,a.s.trajCols,a.s.sptStrings,[0 0],0);
    
    
end

clearvars -except a e tg aTmp
   
    