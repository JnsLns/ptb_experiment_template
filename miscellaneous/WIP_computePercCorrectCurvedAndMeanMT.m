
% For 2 pair paradigms (but not for the others) run the first section below
% first (after loading preprocessed data into the workspace, and only
% then do the following.

% !!! IMPORTANT: Do not save or use the traj/res data resulting from the procedure 
% here...

% Compute results (baseAnalysis)
% - comment out the IV correctness
% - comment out curvature IV
% - have NO further IVs active in ivDefinition
% - disable averaging over particiapnts
% - set a.s.balancingByMeanOfMeans = 0 

% then run the second section below

% Note1: These computations are based on individual trials (from a.res.ind)
% and are therefore not affected by balancing (i.e., balancing categories
% and other conditions are not represented in these means to equal degrees).

%% FOR 2 pair paradigms run this section BEFORE RUNNING base analysis 

% Find trial IDs that are in the list two times (due to first repsonding
% incorrectly and then correctly or incorrectly both times)
dblIDs = [];
for curID = unique(a.rs(:,a.s.resCols.trialID))'
    nOccurrence = sum(a.rs(:,a.s.resCols.trialID)==curID);
    if nOccurrence>1
        dblIDs(1,end+1) = curID;
    end    
    % just to check again
    if ~any(nOccurrence==[1,2]); warning('zero or more than double trial'); end                
end

% Find how many double trials ocurred for each pts
ptsDblCases = [];
for curID = dblIDs
    dblRows = find(a.rs(:,a.s.resCols.trialID)==curID);
    ptsDblCases(end+1) = a.rs(dblRows(1),a.s.resCols.pts);
end
pts = unique(ptsDblCases)';
dblCasesPerPts = zeros(numel(pts),2);
for j = 1:numel(pts)
    curPts = pts(j);
    dblCasesPerPts(j,:) = [curPts,sum(ptsDblCases == curPts)];
end

% Go through trial IDs of those trial occurring two times in a.rs and
% remove first one in list (check that either both are incorrect or the
% second one is correct for safety)
for curID = dblIDs
    dblRows = find(a.rs(:,a.s.resCols.trialID)==curID);    
    if a.rs(dblRows(1),a.s.resCols.correct)==1; warning('first trial in double is correct'); end                    
    a.rs(dblRows(1),:) = [];
    a.rawDatBAK.rs(dblRows(1),:) = [];    
    aTmp.rsTransformed(dblRows(1),:) = [];          
    a.tr(dblRows(1)) = [];
    a.rawDatBAK.tr(dblRows(1)) = [];
end

a.trj = []; a.byPts = []; a.res = []; a.s.rowSets = [];

 

%% 
nCorrectNonCurved = cell2mat(cellfun(@(res)  sum(res(:,a.s.resCols.exceedsCurveThresh)==0 & res(:,a.s.resCols.correct)==1),a.res.ind, 'uniformoutput',0));
nCorrectCurved = cell2mat(cellfun(@(res)  sum(res(:,a.s.resCols.exceedsCurveThresh)==1 & res(:,a.s.resCols.correct)==1),a.res.ind, 'uniformoutput',0));
nCorrectTotal = cell2mat(cellfun(@(res)  sum(res(:,a.s.resCols.correct)==1),a.res.ind, 'uniformoutput',0));
nIncorrectNonCurved = cell2mat(cellfun(@(res)  sum(res(:,a.s.resCols.exceedsCurveThresh)==0 & res(:,a.s.resCols.correct)==0),a.res.ind, 'uniformoutput',0));
nIncorrectCurved = cell2mat(cellfun(@(res)  sum(res(:,a.s.resCols.exceedsCurveThresh)==1 & res(:,a.s.resCols.correct)==0),a.res.ind, 'uniformoutput',0));
nIncorrectTotal = cell2mat(cellfun(@(res)  sum(res(:,a.s.resCols.correct)==0),a.res.ind, 'uniformoutput',0));
nNonCurved = cell2mat(cellfun(@(res) sum(res(:,a.s.resCols.exceedsCurveThresh)==0),a.res.ind, 'uniformoutput',0));
nCurved = cell2mat(cellfun(@(res) sum(res(:,a.s.resCols.exceedsCurveThresh)==1),a.res.ind, 'uniformoutput',0));
nTotal = cell2mat(cellfun(@(res) size(res,1),a.res.ind, 'uniformoutput',0));
        
meanMTCorrectNonCurved = cell2mat(cellfun(@(res)  mean(res(res(:,a.s.resCols.exceedsCurveThresh)==0 & res(:,a.s.resCols.correct)==1,a.s.resCols.movementTime_pc)),a.res.ind, 'uniformoutput',0));
meanMTCorrectCurved = cell2mat(cellfun(@(res)  mean(res(res(:,a.s.resCols.exceedsCurveThresh)==1 & res(:,a.s.resCols.correct)==1,a.s.resCols.movementTime_pc)),a.res.ind, 'uniformoutput',0));
meanMTCorrectAll = cell2mat(cellfun(@(res)  mean(res(res(:,a.s.resCols.correct)==1,a.s.resCols.movementTime_pc)),a.res.ind, 'uniformoutput',0));
meanMTIncorrectNonCurved = cell2mat(cellfun(@(res)  mean(res(res(:,a.s.resCols.exceedsCurveThresh)==0 & res(:,a.s.resCols.correct)==0,a.s.resCols.movementTime_pc)),a.res.ind, 'uniformoutput',0));
meanMTIncorrectCurved = cell2mat(cellfun(@(res)  mean(res(res(:,a.s.resCols.exceedsCurveThresh)==1 & res(:,a.s.resCols.correct)==0,a.s.resCols.movementTime_pc)),a.res.ind, 'uniformoutput',0));
meanMTIncorrectAll = cell2mat(cellfun(@(res)  mean(res(res(:,a.s.resCols.correct)==0,a.s.resCols.movementTime_pc)),a.res.ind, 'uniformoutput',0));
meanMTNonCurved = cell2mat(cellfun(@(res) mean(res(res(:,a.s.resCols.exceedsCurveThresh)==0,a.s.resCols.movementTime_pc)),a.res.ind, 'uniformoutput',0));
meanMTCurved = cell2mat(cellfun(@(res) mean(res(res(:,a.s.resCols.exceedsCurveThresh)==1,a.s.resCols.movementTime_pc)),a.res.ind, 'uniformoutput',0));
meanMTAll = cell2mat(cellfun(@(res) mean(res(:,a.s.resCols.movementTime_pc)),a.res.ind, 'uniformoutput',0));

nAcrossPtsTotal = sum(nTotal); % A total of XX trajectories was obtained
nAcrossPtsNonCurved = sum(nNonCurved); % XX of which did not exceed curvature threshold
meanNNonCurved = mean(nNonCurved); % (XX +-
stdNNonCurved = std(nNonCurved); % XX s.d. on average per participant, or
percAcrossPtsNonCurved = nAcrossPtsNonCurved./nAcrossPtsTotal*100; % XX percent; 
meanPercentNonCurved = mean(nNonCurved./nTotal*100); % mean XX percent +-
stdPercentNonCurved = std(nNonCurved./nTotal*100); % XX s.d.).

percAcrossPtsNonCurvedCorrect = (sum(nCorrectNonCurved)./nAcrossPtsNonCurved*100);  % Of the non-curved trajectories, XX percent were responded to correctly
percNonCurvedCorrect = mean(nCorrectNonCurved./nNonCurved*100); % (mean XX percent +-  
stdNonCurvedCorrect = std(nCorrectNonCurved./nNonCurved*100); % XX s.d).

meanMeanMTCorrectNonCurved = mean(meanMTCorrectNonCurved);  % For these correct and non-curved trials, participants mean movement time was on average XX ms 
stdMeanMTCorrectNonCurved = std(meanMTCorrectNonCurved);  % +- XX sd on average.

% only for 2 pair paradigms (where trials were repeated if incorrect)
% to be able to compute this, do everything that is described at the start of this
% script, then (re-)load the preprocessed results data into workspace without clearing first,
% then run the first cell again, then run this block here.
% try
%     percDoubleOfAllDoneTrials = dblCasesPerPts(:,2)./(nTotal+dblCasesPerPts(:,2))*100;
%     meanNumDoubleOfAllDoneTrials = mean(dblCasesPerPts(:,2));
%     stdNumDoubleOfAllDoneTrials = std(dblCasesPerPts(:,2));
%     meanPercDoubleOfAllDoneTrials = mean(percDoubleOfAllDoneTrials);
%     stdPercDoubleOfAllDoneTrials = std(percDoubleOfAllDoneTrials);    
%     repeatedString = ['Over participants, an average ' num2str(round(meanNumDoubleOfAllDoneTrials,2)) ' $\pm$ ' num2str(round(stdNumDoubleOfAllDoneTrials,2)) ' \sd trials were presented twice' ...
%           ' due to incorrect responses in the first presentation ('  num2str(round(meanPercDoubleOfAllDoneTrials,2)) ' percent of all completed trials $\pm$ '  num2str(round(stdPercDoubleOfAllDoneTrials,2))  ' \sd).']    
% end

resultsString = ...
['A total of ' num2str(nAcrossPtsTotal) ' trajectories was obtained, ' num2str(nAcrossPtsNonCurved) ' of which were below curvature threshold (' ...
num2str(round(percAcrossPtsNonCurved,2)) ' percent; participant mean '...
num2str(round(meanNNonCurved,2)) ' $\pm$ ' num2str(round(stdNNonCurved,2)) ' s.d., equaling '...
num2str(round(meanPercentNonCurved,2)) ' percent $\pm$ ' num2str(round(stdPercentNonCurved,2)) ' s.d.).' ...
' Of the non-curved trajectories, ' num2str(round(percAcrossPtsNonCurvedCorrect,2)) ' percent (' num2str(sum(nCorrectNonCurved)) ') were correct responses and thus entered further analysis (' num2str(round(sum(nCorrectNonCurved)/nAcrossPtsTotal*100,2)) ' percent of all obtained trajectories). '...
' Participants achieved a mean accuracy of ' num2str(round(percNonCurvedCorrect,2)) ' percent $\pm$ ' num2str(round(stdNonCurvedCorrect,2)) ' s.d. and their mean movement time across conditions was ' ...
num2str(round(meanMeanMTCorrectNonCurved*1000,2)) ' ms $\pm$ ' num2str(round(stdMeanMTCorrectNonCurved*1000,2)) ' s.d.. Note that these numbers were not affected by balancing.']
 



 
 
 
 
 
 
 