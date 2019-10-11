% ANOVA for movement times in two-pair paradigm (used for APP paper)


% Before running the ANOVA (first section of this code, second is visualization)
% run the usual analysis script for two pair paradigms using the iv
% definition below (i.e., balance by pair B side, across pairBside).
% Then run the code 

anovaAlpha = 0.04;

useEsType = 'pe2'; % use partial eta squared
%useEsType = 'dz'; % use Cohen's d_z

% % for computing overall movement time (i.e., across pair B side, as reported in 2019 paper)
% % Also used for movement time 2x2 RM ANOVA
% % mean movement time over pair B left/right
% if 1
% % second pair side (i.e., ref2 side) by addItem condition
% aTmp.superSubplotTitle = 'Pair2 side by addItemCondition ("correct" trials)';
% a.s.relevantBalancingColumn = a.s.resCols.pair2VsRef1VsComSide_ana;
% a.s.expectedBalancingValues = 1:4;
% a.s.balancingLegendEntries = {'r1s/cs','r1s/co','r1o/cs','r1o/co'};
%
% % a.s.ivs{end+1,a.s.ivsCols.name } = 'pair2 side rel. to dir.path';
% % a.s.ivs{end,a.s.ivsCols.style } = 'lineColor';
% % a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.ref2Side;
% % a.s.ivs{end,a.s.ivsCols.values} = [1;2];
% % a.s.ivs{end,a.s.ivsCols.valLabels} = {'Pair2 left of dir. path'; 'Pair2 right of dir. path'};
% % a.s.ivs{end,a.s.ivsCols.useVal} = [0;0];
% % a.s.ivs{end,a.s.ivsCols.diffs} = [];
% % a.s.ivs{end,a.s.ivsCols.diffs} = [];
% % a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
% % %a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2]};
% % a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2]};
% % a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
%
% a.s.ivs{end+1,a.s.ivsCols.name} = 'add. item condition';
% a.s.ivs{end,a.s.ivsCols.style} = 'subplotColumns';
% a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.additionalItemCondition;
% a.s.ivs{end,a.s.ivsCols.values} = [1;2;3;4];
% a.s.ivs{end,a.s.ivsCols.valLabels} = {'fullPair2','onlyRef2','onlyDtr','onlyPair1'};
% a.s.ivs{end,a.s.ivsCols.useVal} = [1;1;1;1];
% a.s.ivs{end,a.s.ivsCols.diffs} = [];
% %a.s.ivs{end,a.s.ivsCols.diffs} = [1,3;2,4]; % interaction ref*dtr presence (effect of ref for dtr pres and abs)
% %a.s.ivs{end,a.s.ivsCols.diffs} = [1,2;3,4]; % interaction ref*dtr presence (effect of dtr for ref pres and abs)
% a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0;0;0];
% a.s.ivs{end,a.s.ivsCols.joinVals} = {};
% %a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;3];[2;4]}; % distractor main effect
% %a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2];[3;4]}; % reference main effect
% a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
%
% end


% make columns denoting conditions and participants
nPts = 20;
f1Levels = 2; % factor 1 levels (dtr)
f2Levels = 2; % factor 2 levels (ref)

group = [];
for curPts = 1:nPts
    for curF1Lev = 1:f1Levels
        for curF2Lev = 1:f2Levels
            group(end+1,1) = curPts; % first group variable is participants
            group(end,2) = curF1Lev;
            group(end,3) = curF2Lev;
        end
    end
end

group = sortrows(group,[3,2,1]);
% this order allows to go through the four conditions and get all
% participants from the respective condition and concatenate them
group = {group(:,1),group(:,2),group(:,3)};

% input data
%useDat = a.byPts.trj.wrp.pos.avg;
useDat = a.byPts.res.avg;
%useCol = a.s.trajCols.x;
useCol = a.s.resCols.movementTime_pc;

% Prepare output cells/mats
ps = cell(size(useDat{1},1),1);
tbls = ps;
hLineFig = figure;
alternativeStats = cell(size(useDat{1},1),1);
isNormal = [];
d_z = [];
pe2 = [];
alternativeES = [];
esStats = [];
curStep = 1;

% get one value from each participant (1 per condition)
curStepDat = cellfun(@(tr) tr(curStep,useCol),useDat,'uniformoutput',0);
% collapse cell along pts dim, so that the new cell has one cell for each
% condition and in each of these cells a row vector holding participants'
% effect values
curStepDat = cellCollapse(curStepDat,a.s.ptsDim,1);

% For later use (not required for anova itself)
fullPair2 = curStepDat{1}; % ref2 present, dtr present
ref2Only = curStepDat{2};  % ref2 present, dtr absent
dtrOnly = curStepDat{3};   % ref2 absent, dtr present
pair1Only = curStepDat{4}; % ref2 absent, dtr absent

%make line plot of current step
%if curStep == 129
try
    delete([hEb1,hEb2]);
end
% line ref 2 present
hEb1 = errorbar([mean(fullPair2),mean(ref2Only)],[std(fullPair2),std(ref2Only)],'displayName','ref2 present','color','r','marker','x');
hold on;
% line ref 2 absent
hEb2 = errorbar([mean(dtrOnly),mean(pair1Only)],[std(pair1Only),std(pair1Only)],'displayName','ref2 absent','color','b','marker','o');
hTmp = gca;
hTmp.XTick = [1 2];
hTmp.XLim = [.75 2.25];
hTmp.XTickLabels
hTmp.XTickLabels = {'dtr present','dtr absent'};
hTmp.YDir = 'normal';
hTmp.YLim = [0.8 1.5];
drawnow
pause(0.1)
%end

% collapse across conditions
curStepDat = cellCollapse(curStepDat,2,1);
curStepDat = cell2mat(curStepDat);
% do the ANOVA
try
    [ps{curStep} tbls{curStep}] = anovan(curStepDat,group,'random',[1],'model','interaction','varnames',{'pts','dtr','ref'},'display','off');        
end

% alternative anova script by Aaron Schurger (results are identical to anovan)
%alternativeStats{curStep} = rm_anova2(curStepDat,group{1},group{2},group{3},{'dtr_pres','ref_ pres'});

% Cohen's d_z for main effects
d_z.ref(curStep) = mean(mean([fullPair2,ref2Only],2)-mean([dtrOnly,pair1Only],2)) / std(mean([fullPair2,ref2Only],2)-mean([dtrOnly,pair1Only],2));
d_z.dtr(curStep) = mean(mean([fullPair2,dtrOnly],2)-mean([ref2Only,pair1Only],2)) / std(mean([fullPair2,dtrOnly],2)-mean([ref2Only,pair1Only],2));
% Interaction effect size (d_z applied to differences between conditions)
d_z.refDtr(curStep) = mean((fullPair2 - dtrOnly)-(ref2Only - pair1Only))/std((fullPair2 - dtrOnly)-(ref2Only - pair1Only));
% versus denominator = square root of the MSE from the ANOVA (careful,
% indices are specific to anova table structure)... this is somewhat
% higher than d_z, presumably because some variance is removed by the
% main effects.
% alternativeES.interaction(curStep) = mean((fullPair2 - dtrOnly)-(ref2Only - pair1Only))/sqrt(tbls{curStep}{8,5});

% Compute partial eta-squared using the effect size toolbox
pe2Stats_tmp = mes2way(curStepDat,[group{2},group{3}],'partialeta2','isDep',[1 1]);
pe2.dtr(curStep) =  pe2Stats_tmp.partialeta2(1);
pe2.ref(curStep) =  pe2Stats_tmp.partialeta2(2);
pe2.refDtr(curStep) =  pe2Stats_tmp.partialeta2(3);



