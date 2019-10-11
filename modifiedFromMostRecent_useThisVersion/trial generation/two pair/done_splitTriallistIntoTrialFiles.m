
% Note: Clear workspace first

% source file
sourceFile = ['S:\twoPairParadigm_allTrials_doubledAddItems.mat'];
load(sourceFile)

triallistOriginal = tg.triallist;

% loop over participants
curPts = 0;
while ~isempty(triallistOriginal)
    
    curPts = curPts+1;    
    curSet = [];    
    curSet = triallistOriginal(triallistOriginal(:,tg.triallistCols.temporaryPtsID) == curPts,:);    
    curSet = curSet(randperm(size(curSet,1)),:);
    tg.triallist = curSet;
    triallistOriginal(triallistOriginal(:,tg.triallistCols.temporaryPtsID) == curPts,:) = [];
       
    save(['\trials_' num2str(curPts)], '-regexp', '^(?!(curPts|curSet|triallistOriginal)$).')
end









