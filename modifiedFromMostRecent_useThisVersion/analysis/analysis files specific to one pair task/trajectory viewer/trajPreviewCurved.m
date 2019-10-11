if aTmp.showIndivTrajPreviewCurved && isfield(aTmp,'discardedTrialsDueToCurvature') && sum(aTmp.discardedTrialsDueToCurvature) > 0
    
    disp('Showing CURVED (discarded) trajectories. Close figure to go on...');
    
    %view raw trajectories and cut/translated/rotated ones in comparison
    %(raw trajectories in top plot). Note that no trajectories are
    %excluded, except for those that were discarded due to high curvature.
    
    
    trajViewerComparison(...
        a.rawDatBAK.tr(aTmp.discardedTrialsDueToCurvature), ...
        a.rawDatBAK.rs(aTmp.discardedTrialsDueToCurvature,:), ...
        [0 a.s.presArea_mm(1)], ...
        [0 a.s.presArea_mm(2)], ...
        a.tr, ...
        a.rs, ...
        [-a.s.presArea_mm(1)/2 a.s.presArea_mm(1)/2], ....
        [0 a.s.presArea_mm(2)], ...
        a.s.resCols,a.s.trajCols,a.s.sptStrings,[0 0],2);
    
elseif aTmp.showIndivTrajPreviewCurved && ~isfield(aTmp,'discardedTrialsDueToCurvature') 
    
    disp('Curvature threshold disabled --> NOT showing curved trajectories.');
    
elseif aTmp.showIndivTrajPreviewCurved && sum(aTmp.discardedTrialsDueToCurvature) == 0
    
    disp('There are NONE curved trajectories, so I cannot show them...');
    
end

clearvars -except a e tg aTmp
   