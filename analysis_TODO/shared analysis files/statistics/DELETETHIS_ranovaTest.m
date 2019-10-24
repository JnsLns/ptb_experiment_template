
% Before running the ANOVA (first section of this code, second is visualization)
% run the usual analysis script for two pair paradigms using the iv
% definition below (i.e., balance by pair B side, compute R-L difference
% scores within each add item condition). Then run the first section (after
% that, the different effects (image maps & sig markers) may be plotted one
% after the other into appropriate axes for interaction and main effects
% (that need to be plotted before all this using appropriate iv Definition)

% plot results to current axes (select appropriate axes by clicking into it
% before running this script)?
% IMPORTANT: See visualization section at the bottom, there are more
% settings to adjust (and some instructions)
doFigureStuff = 1;

% second pair side (i.e., ref2 side) by addItem condition
% a.s.relevantBalancingColumn = a.s.resCols.pair2VsRef1VsComSide_ana; 
% a.s.expectedBalancingValues = 1:4;
% a.s.balancingLegendEntries = {'r1s/cs','r1s/co','r1o/cs','r1o/co'};
% 
% a.s.ivs{end+1,a.s.ivsCols.name } = 'pair2 side rel. to dir.path';
% a.s.ivs{end,a.s.ivsCols.style } = '';
% a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.ref2Side;
% a.s.ivs{end,a.s.ivsCols.values} = [1;2];
% a.s.ivs{end,a.s.ivsCols.valLabels} = {'Pair2 left of dir. path'; 'Pair2 right of dir. path'};
% a.s.ivs{end,a.s.ivsCols.useVal} = [0;0];
% a.s.ivs{end,a.s.ivsCols.diffs} = [2,1]; 
% a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
% a.s.ivs{end,a.s.ivsCols.joinVals} = {};
% a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
% 
% a.s.ivs{end+1,a.s.ivsCols.name} = 'add. item condition';
% a.s.ivs{end,a.s.ivsCols.style} = 'lineColor';
% a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.additionalItemCondition;
% a.s.ivs{end,a.s.ivsCols.values} = [1;2;3;4];
% a.s.ivs{end,a.s.ivsCols.valLabels} = {'fullPair2','onlyRef2','onlyDtr','onlyPair1'};
% a.s.ivs{end,a.s.ivsCols.useVal} = [1;1;1;1]; 
% a.s.ivs{end,a.s.ivsCols.diffs} = [];
% a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0;0;0];
% a.s.ivs{end,a.s.ivsCols.joinVals} = {};
% a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;


% make columns denoting conditions and participants
nPts = 20;
f1Levels = 2; % factor 1 levels (dtr)
f2Levels = 2; % factor 2 levels (ref)

group = [];
for curPts = 1:nPts
    for curF1Lev = 1:f1Levels
        for curF2Lev = 1:f2Levels
            group(end+1,1) = curPts;
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
useDat = a.byPts.trj.wrp.pos.avg;
useCol = a.s.trajCols.x;

% Prepare output cells/mats
ps = cell(size(useDat{1},1),1);
tbls = ps;
hLineFig = figure;
alternativeStats = cell(size(useDat{1},1),1);
isNormal = [];
d_z = [];
alternativeES = [];
p_multComp = [];
for curStep = 1:size(useDat{1},1)
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
    
    
    % WIP WIP WIP
    % Test for normality  in each cell
%     isNormal(end+1,1) = swtest(fullPair2,0.01);
%     isNormal(end,2) = swtest(ref2Only,0.01);
%     isNormal(end,3) = swtest(dtrOnly,0.01);
%     isNormal(end,4) = swtest(pair1Only,0.01);    
    % WIP WIP WIP            
    
%     %make line plot of current step
%     %if curStep == 129
%     try
%         delete([hEb1,hEb2]);
%     end   
%     % line ref 2 present
%     hEb1 = errorbar([mean(fullPair2),mean(ref2Only)],[std(fullPair2),std(ref2Only)],'displayName','ref2 present','color','r','marker','x');
%     hold on;
%     % line ref 2 absent
%     hEb2 = errorbar([mean(dtrOnly),mean(pair1Only)],[std(pair1Only),std(pair1Only)],'displayName','ref2 absent','color','b','marker','o');
%     hTmp = gca;
%     hTmp.XTick = [1 2];
%     hTmp.XLim = [.75 2.25];
%     hTmp.XTickLabels
%     hTmp.XTickLabels = {'dtr present','dtr absent'};
%     hTmp.YDir = 'normal';    
%     hTmp.YLim = [-20 20];        
%     drawnow
%     pause(0.1)
%     %end            
    
    
    % collapse across conditions
    curStepDat = cellCollapse(curStepDat,2,1);
    curStepDat = cell2mat(curStepDat);
    % do the ANOVA
    try
    [ps{curStep} tbls{curStep} stats] = anovan(curStepDat,group,'random',[1],'model','interaction','varnames',{'pts','dtr','ref'},'display','off');
    end
    
   
    disp(curStep)
    c = multcompare(stats,'Dimension',[2 3],'ctype','bonferroni');             
    p_multComp(:,curStep) = c([1 2 5 6],6);
        
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
    
    
end


% Find longest sequence of consecutive significant tests i

anovaAlpha = 0.05;
effects = [];
pstmp = [];

% All ps (includes some irrelevant ones from the random factor)
pstmp = cell2mat(cellCollapse(ps,1,2));
% Dtr main effect assumed to be second
effects.p.dtr = pstmp(2,:)';
effects.h.dtr = pstmp(2,:)'<anovaAlpha;
% Ref main effect assumed to be third
effects.p.ref = pstmp(3,:)';
effects.h.ref = pstmp(3,:)'<anovaAlpha;
% Interaction dtr*ref assumed to be sixth
effects.p.refDtr = pstmp(6,:)';
effects.h.refDtr = pstmp(6,:)'<anovaAlpha;

% find longest sequence of significant data points for each main effect and interaction

for curEff = fieldnames(effects.h)'

    h = effects.h.(curEff{1});
    
    counter = 0;
    longestSeq = 0;
    currentStartStep = [];
    startStep  = [];
    endStep = [];
    for i = 1:numel(h)
        if h(i) == 1
            counter = counter+1;
            if counter == 1
                currentStartStep = i;
            end
        end
        if h(i) ~= 1 || i == numel(h)
            if counter > longestSeq
                longestSeq = counter;
                startStep = currentStartStep;
            end
            counter = 0;
        end
    end
    endStep = startStep + longestSeq - 1;

    sigSeq.longest.(curEff{1}) = longestSeq;    
    sigSeq.startStep.(curEff{1}) = startStep;  
    sigSeq.endStep.(curEff{1}) = endStep;  
end

%% Visualization
% Run this cell separately for main effects and interaction, selecting the
% correct axes beforehand and setting the right data below

if doFigureStuff

hTgtFig = gcf;

% choose one of these
whichEff = 'dtr';
%whichEff = 'ref';
%whichEff = 'refDtr';

plotWhatEffect_h = effects.h.(whichEff); % for significance markers
plotWhatEffect_p = effects.p.(whichEff); % for p value colormap
plotWhatEffect_d = d_z.(whichEff);       % for effect size colormap
plotWhatEffect_longestSeq = sigSeq.longest.(whichEff);
plotWhatEffect_startStep = sigSeq.startStep.(whichEff);
plotWhatEffect_endStep = sigSeq.endStep.(whichEff);


% proportion of axes width taekn up by significance color bar and effect
% size color bar (each; p-bar is placed left, d-bar is placed right)
barWidthProp = 0.05;
% significance marker distance from left axes border as proportion of axes
% width
sigMarkerPlacementProp = 0.1;
sigMarkerSize = 5;


%---

interpType = 'wrp';

figure(hTgtFig);

    curLineAx = gca; %currently active axes into/over which stuff should be plotted
    curAxID = round(rand*1000000000); % unique ID
    curLineAx.UserData = curAxID; % add ID to axes so that associated axes (below) can later be identified

    hold on

    % --- Plot significance indicators to currently selected axes

    % delete preexisting sig./effect size indicators and associated axes
    % effect size axes (image)
    existingEsAxes = findobj(gcf,'tag','esAx');
    effAxPosesTmp = get(existingEsAxes,'position');
    if isa(effAxPosesTmp,'double') && isequal(curLineAx.Position, effAxPosesTmp)
        delete(existingEsAxes);
    elseif ~isempty(effAxPosesTmp) && isequal(curLineAx.Position, effAxPosesTmp)
        delete(existingEsAxes(cellfun(@(esp) all(curLineAx.Position==esp),effAxPosesTmp)))
    end
    % p-value-image axes (dots and image)
    existingSigAxes = findobj(gcf,'tag','sigAx');
    sigAxPosesTmp = get(existingSigAxes,'position');
    if isa(sigAxPosesTmp,'double') && isequal(curLineAx.Position, sigAxPosesTmp)
        delete(existingSigAxes);
    elseif ~isempty(sigAxPosesTmp) && isequal(curLineAx.Position, sigAxPosesTmp)
        delete(existingSigAxes(cellfun(@(esp) all(curLineAx.Position==esp),sigAxPosesTmp)))
    end

    % p-value axes/image/dots---------------------------------------------
    % overlay new axes to place imagemap in
    sigAx = axes('position',get(curLineAx,'position'));
    sigAx.XLim = curLineAx.XLim;
    barWidth = diff(sigAx.XLim)*barWidthProp; % width in x-axes units
    yDatTmp = get(findobj(curLineAx,'tag','dataLine'),'YData');
    if iscell(yDatTmp)
        yDatTmp = cell2mat(yDatTmp);
    end
    ymin = min(min(yDatTmp)); % y extent
    ymax = max(max(yDatTmp)); % y extent
    hSigImg = image([sigAx.XLim(1), sigAx.XLim(1)+barWidth],[ymin ymax],plotWhatEffect_p);
    hSigImg.Tag = 'sigImg';
    set(hSigImg,'alphadata',~isnan(plotWhatEffect_p)) % make transparent where p has nans
    colormap(sigAx,flipud(parula));
    hSigImg.CDataMapping = 'scaled';
    set(sigAx,'Clim',[0 0.1],'ydir','normal');
    sigAx.XLim = curLineAx.XLim;
    sigAx.Tag = 'sigAx';
    sigAx.Visible = 'off';
    sigAx.UserData = curAxID;
    % associated colorbar
    delete(findobj(gcf,'type','colorbar'))
    cbarw=.02;cbarh=.2; cbarx=.01;cbary=.01; % colorbar position in figure
    colorbar('position',[cbarx cbary cbarw cbarh],'ticks',[0 .01 .05 0.1],'fontsize',5, 'YAxisLocation','right');
    %---

    % Add significance markers
    hold(sigAx,'on');
    for i = 1:numel(plotWhatEffect_h)
        if ~isnan(plotWhatEffect_h(i)) && plotWhatEffect_h(i)
            switch interpType
                case  'wrp'
                    yValueForSigMarkers = i;
                case 'alg'
                    yValueForSigMarkers = (i-1)*a.s.samplingPeriodForInterp;
                otherwise
                    yValueForSigMarkers = [];
            end
            hSigMarkers = plot(sigAx.XLim(1)+sigMarkerPlacementProp*diff(sigAx.XLim),yValueForSigMarkers,'marker','.','color','k', 'MarkerSize',sigMarkerSize); % for warped trajs
            set(hSigMarkers,'tag','sigDot');
            set(get(get(hSigMarkers,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        end
    end
    hold(sigAx,'off');
    %---------------------------------------------------------------------


    % d axes/image -------------------------------------------------------
    % overlay new axes with separate color map to place imagemap in
    esAx = axes('position',get(curLineAx,'position'));
    esAx.XLim = curLineAx.XLim;
    barWidth = diff(esAx.XLim)*barWidthProp; % width in x-axes units
    yDatTmp = get(findobj(curLineAx,'tag','dataLine'),'YData');
    if iscell(yDatTmp)
        yDatTmp = cell2mat(yDatTmp);
    end
    ymin = min(min(yDatTmp)); % y extent
    ymax = max(max(yDatTmp)); % y extent
    hEsImg = image([esAx.XLim(2)-barWidth, esAx.XLim(2)],[ymin ymax],plotWhatEffect_d');
    hEsImg.Tag = 'esImg';
    set(hEsImg,'alphadata',~isnan(plotWhatEffect_d')) % make transparent where d has nans and where nonsig.
    colormap(esAx,hot);
    hEsImg.CDataMapping = 'scaled';
    set(esAx,'Clim',[0 4],'ydir','normal');
    esAx.XLim = curLineAx.XLim;
    esAx.Tag = 'esAx';
    esAx.Visible = 'off';
    esAx.UserData = curAxID;
    % associated colorbar
    cbarw=.02;cbarh=.2; cbarx=.01;cbary= 1-cbarh-.01; % colorbar position in figure
    colorbar('position',[cbarx cbary cbarw cbarh],'ticks',0:4,'fontsize',5, 'YAxisLocation','right');
    %---------------------------------------------------------------------

%    linkaxes([curLineAx,esAx],'y');
    linkaxes([curLineAx,sigAx],'y');

%    uistack(esAx,'top');
    uistack(sigAx,'top');
    axes(curLineAx);
    curLineAx.Color = 'none';

    text(0.1,0.1,[num2str(plotWhatEffect_longestSeq ),' steps', ' (', num2str(round(plotWhatEffect_startStep/numel(plotWhatEffect_h)*100,2)), ' to ', num2str(round(plotWhatEffect_endStep/numel(plotWhatEffect_h)*100,2)), ' \%)']  ,'units','normalized')

end