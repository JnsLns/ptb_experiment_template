
% Trials file must be loaded into workspace
%
% Note that this file is not fully re-usable as some column numbers and
% other values are are hard-coded such that they apply to the second trial
% batch used for the first 2-pair run (in use July 11 2017).

tgtSlots_xy_mm = [28.28 , 28.28; -28.28, 28.28; 28.28, -28.28; -28.28, -28.28] + repmat(tg.array_pos_mm,4,1);
tgtSlotStrings = {'upR','upL','botR','botL'};
sameDiffStrings = {'Same','Diff'};
sptColors = {'r','g','b','y'};
tg.triallist(:,tg.triallistCols.tgt)


for curSpatialTerm = 1:4

    figure('name',tg.sptStrings{curSpatialTerm});    
    
    % cell array for handles of subplots such that 4 plots for each target slot,
    % one for each balancing category, arranged rectangularly where rows are
    % com sides relative to pair 2 side, and cols are ref 1 sides relative to
    % pair 2 side.
    % For the cell array:
    % dim 1: target slots
    % dim 2: com same/diff
    % dim 3: r1 same diff
    tcr = cell(4,2,2);    
    tcr{2,1,1} = subplot(4,4,1);
    tcr{2,1,2} = subplot(4,4,2);
    tcr{1,1,1} = subplot(4,4,3);
    tcr{1,1,2} = subplot(4,4,4);
    tcr{2,2,1} = subplot(4,4,5);
    tcr{2,2,2} = subplot(4,4,6);
    tcr{1,2,1} = subplot(4,4,7);
    tcr{1,2,2} = subplot(4,4,8);
    tcr{4,1,1} = subplot(4,4,9);
    tcr{4,1,2} = subplot(4,4,10);
    tcr{3,1,1} = subplot(4,4,11);
    tcr{3,1,2} = subplot(4,4,12);
    tcr{4,2,1} = subplot(4,4,13);
    tcr{4,2,2} = subplot(4,4,14);
    tcr{3,2,1} = subplot(4,4,15);
    tcr{3,2,2} = subplot(4,4,16);
    
    set(findobj(gcf,'type','axes'),'xlim',[0 tg.presArea_mm(1)],'ylim',[0 tg.presArea_mm(2)], ...
    'nextplot','add');
    
    for curTrial = 1:size(tg.triallist,1)
        
        % spatial term: 1 left, 2 right, 3 above, 4 below
        spt = tg.triallist(curTrial,tg.triallistCols.spt);               
        
        % positions
        tp = [tg.triallist(curTrial,(tg.triallistCols.horzPosStart-1)+tg.triallist(curTrial,tg.triallistCols.tgt)),tg.triallist(curTrial,(tg.triallistCols.vertPosStart-1)+tg.triallist(curTrial,tg.triallistCols.tgt))];
        rp = [tg.triallist(curTrial,(tg.triallistCols.horzPosStart-1)+tg.triallist(curTrial,tg.triallistCols.ref)),tg.triallist(curTrial,(tg.triallistCols.vertPosStart-1)+tg.triallist(curTrial,tg.triallistCols.ref))];
        r2p = [tg.triallist(curTrial,(tg.triallistCols.horzPosStart-1)+tg.triallist(curTrial,tg.triallistCols.ref2)),tg.triallist(curTrial,(tg.triallistCols.vertPosStart-1)+tg.triallist(curTrial,tg.triallistCols.ref2))];
        dp = [tg.triallist(curTrial,(tg.triallistCols.horzPosStart-1)+tg.triallist(curTrial,tg.triallistCols.dtr)),tg.triallist(curTrial,(tg.triallistCols.vertPosStart-1)+tg.triallist(curTrial,tg.triallistCols.dtr))];
        cp = sum([tg.triallist(curTrial,tg.triallistCols.horzPosStart:tg.triallistCols.horzPosEnd);
            tg.triallist(curTrial,tg.triallistCols.vertPosStart:tg.triallistCols.vertPosEnd)]')/tg.triallist(curTrial,tg.triallistCols.nItems);
        
        % Preparation of helper function for determining item side relative to direct path
        strt = tg.start_pos_mm;
        % function returns 1 if p left of line from strt to tp, 2 if right or on the line
        % (note that current tp and start positions are not arguments but used statically in the function definition)
        lrPoint = @(px,py)  (((tp(1)-strt(1))*(py-strt(2)) - (px-strt(1))*(tp(2)-strt(2)))<0)+1;
        
        % balanding category: row 1 = r1s/cs, 2 = r1s/cd, 3 = r1d/cs, 4 = r1d/cd
        bc = tg.triallist(curTrial,tg.triallistCols.pair2VsRef1VsComSide);
        
        % target slot: 1 top right, 2 top left, 3 bottom right, 4 bottom left
        ts = tg.triallist(curTrial,tg.triallistCols.tgtSlot);
        
        % sides relative to direct path: 1 left, 2 right
        p2side = lrPoint(r2p(1),r2p(2));
        rSide = lrPoint(rp(1),rp(2));
        cSide = lrPoint(cp(1),cp(2));
        
        cVsP2 = (cSide~=p2side)+1;
        r1VsP2 = (rSide~=p2side)+1;
        
        axes(tcr{ts,cVsP2,r1VsP2});
        set(gca,'color',[.5 .5 .5]);
        
        % first plot direct path 6 target slots
        if isempty(findobj(tcr{ts,cVsP2,r1VsP2},'type','line'))
            plot([tg.start_pos_mm(1),tp(1)],[tg.start_pos_mm(2),tp(2)],'color','k','linestyle',':');
            plot(tgtSlots_xy_mm(:,1),tgtSlots_xy_mm(:,2),'.','color',[.75 .75 .75]);
            titleStr = [ tgtSlotStrings{tg.triallist(curTrial,tg.triallistCols.tgtSlot)},' & /r2',sameDiffStrings{r1VsP2},'/com',sameDiffStrings{cVsP2}  ];
            title(titleStr);                                    
        end
        
        if spt ~= curSpatialTerm
            continue
        end
        
        % Plot current pair
        plot([r2p(1) dp(1)],[r2p(2) dp(2)],'marker','o','color',sptColors{spt})
        % Plot current reference 1
        plot(rp(1),rp(2),'marker','x','color','k');
        
        
        
    end
    
end


