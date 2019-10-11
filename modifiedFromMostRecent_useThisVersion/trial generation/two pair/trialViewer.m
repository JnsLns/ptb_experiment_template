function trialViewer(trialFile)
%
% note: this function expects a coordinate frame with origin at bottom left
% of the presentation region, x-axis increasing to the right, and y-axis
% increasing upwards (that is, a non-PTB frame).
%
% Everything must be in millimeters.
%
% Also, all coordinates must be specified in absolute coordinates, never
% relative to any other item (e.g., tgt slot positions must be specified
% NOT relative to array center, but their absolute positions within the
% presentation area)

loaded = load(trialFile);

nTrials = size(loaded.tg.triallist,1);
nItems = loaded.tg.triallistCols.horzPosEnd-(loaded.tg.triallistCols.horzPosStart-1); % not counting ref!

xAxLims = [0 loaded.tg.presArea_mm(1)];
yAxLims = [0 loaded.tg.presArea_mm(2)];

% figure size depending on screen size
ss = get(0,'screenSize');
fHeight = round(ss(4)*0.85);
fWidth = 0.72 * fHeight;
fPosHorz = round(ss(3)/2-fWidth/2);
fPosVert = ss(4)-fHeight-ss(4)*0.05;
fTrialPlot = figure('position',[fPosHorz fPosVert fWidth fHeight],'color','w','DockControls','off','MenuBar','none','Name','Raw versus trimmed/translated/rotated trajectories');
nextButton = uicontrol('style','pushbutton','string','next','position',[75 25 75 50],'callback',@pb_next_callback);
backButton = uicontrol('style','pushbutton','string','prev.','position',[0 25 75 50],'callback',@pb_back_callback);
IDsearch = uicontrol('style','edit','string','enter trial ID','position',[150 25 75 50],'callback',@ed_IDsearch_callback);

trajNumBox = uicontrol('style','text','string','','position',[0 0 fWidth 20],'fontsize',10);

curTrial = 1;
replot = 1;

while 1
    
    pause(0.0001);
    
    if ~ishandle(fTrialPlot)
        return
    end
    
    if replot
        
        sptString = loaded.tg.sptStrings{loaded.tg.triallist(curTrial,loaded.tg.triallistCols.spt)};
        ID = num2str(loaded.tg.triallist(curTrial,loaded.tg.triallistCols.trialID));
        %         curTgtFit = num2str(rs_2(curTrial,loaded.tg.triallistCols.tgtFit));
        %         curDtrFit = num2str(rs_2(curTrial,loaded.tg.triallistCols.dtrFit));
        %         curRelFit = num2str(rs_2(curTrial,loaded.tg.triallistCols.tgtMinDtrFit));        
        %         set(trajNumBox,'string',['traj.#: ', num2str(curTrial), ' / ', num2str(nTrials), ' ("', sptString, '", sptCode: ', num2str(rs_1(curTrial,loaded.tg.triallistCols.spt)), ', tgtFit: ', curTgtFit, ', dtrFit: ', curDtrFit, ', trial ID: ', ID, ')']);
        set(trajNumBox,'string',['trial #: ', num2str(curTrial), ' / ', num2str(nTrials), ' ("', sptString, '", sptCode: ', num2str(loaded.tg.triallist(curTrial,loaded.tg.triallistCols.spt)),' trial ID: ', ID, ')']);
        
        % number of target item
        tgtNum = loaded.tg.triallist(curTrial,loaded.tg.triallistCols.tgt);
        % number of target item
        refNum = loaded.tg.triallist(curTrial,loaded.tg.triallistCols.ref);
        % color code of item defined as target (usually best-fitting item in target color)
        tgtColCode = loaded.tg.triallist(curTrial,loaded.tg.triallistCols.colorsStart-1+tgtNum);
        % item numbers of items also having target color (distracters)
        potTgtsNum = find(loaded.tg.triallist(curTrial,loaded.tg.triallistCols.colorsStart:loaded.tg.triallistCols.colorsEnd) == tgtColCode);
        potTgtsNum(potTgtsNum == tgtNum) = [];
        % Center of mass
        comCoords = sum([loaded.tg.triallist(curTrial,loaded.tg.triallistCols.horzPosStart:loaded.tg.triallistCols.horzPosEnd)',loaded.tg.triallist(curTrial,loaded.tg.triallistCols.vertPosStart:loaded.tg.triallistCols.vertPosEnd)'])/nItems;
        
        % Delete everything from all axes
        allAxes = findobj(fTrialPlot,'type','axes');
        delete(allchild(allAxes));
        
        % Plot all items
        curItems_xyr = [loaded.tg.triallist(curTrial,loaded.tg.triallistCols.horzPosStart:loaded.tg.triallistCols.horzPosEnd)',loaded.tg.triallist(curTrial,loaded.tg.triallistCols.vertPosStart:loaded.tg.triallistCols.vertPosEnd)',loaded.tg.triallist(curTrial,loaded.tg.triallistCols.radiiStart:loaded.tg.triallistCols.radiiEnd)'];
        for curItem = 1:size(curItems_xyr,1)
            
            curFaceColor = loaded.tg.stimColors(loaded.tg.triallist(curTrial,loaded.tg.triallistCols.colorsStart-1+curItem),:);
            
            if curItem == tgtNum                
                curEdgeColor = [0 0 0];
                curLineStyle = ':';
                curLineWidth = 2;
            elseif curItem == refNum                
                curEdgeColor = [0 0 0];
                curLineStyle = '--';
                curLineWidth = 2;
            elseif any(curItem == potTgtsNum)                
                curEdgeColor = [0 0 0];
                curLineStyle = '-';
                curLineWidth = 2;
            else                
                curEdgeColor = [0 0 0];
                curLineStyle = '-';
                curLineWidth = 0.5;
            end
            rectangle('position',[curItems_xyr(curItem,1)-curItems_xyr(curItem,3), curItems_xyr(curItem,2)-curItems_xyr(curItem,3), curItems_xyr(curItem,3)*2, curItems_xyr(curItem,3)*2],'curvature',[1,1],'facecolor',curFaceColor,'edgeColor',curEdgeColor,'linewidth',curLineWidth);
        end
        
        hold on;
        
        % Plot other stuff        
        % stimulus region rectangle
        rectangle('position',[loaded.tg.array_pos_mm(1)-loaded.tg.gen.maxDistFromCenterHorz_all_mm loaded.tg.array_pos_mm(2)-loaded.tg.gen.maxDistFromCenterVert_all_mm loaded.tg.gen.maxDistFromCenterHorz_all_mm*2 loaded.tg.gen.maxDistFromCenterVert_all_mm*2],'EdgeColor','k','Curvature',[0 0]);
        % target slots
        plot(loaded.tg.gen.tgtSlots_xy_mm(:,1),loaded.tg.gen.tgtSlots_xy_mm(:,2),'x','markersize',12,'color','w','linewidth',2);
        plot(loaded.tg.gen.tgtSlots_xy_mm(:,1),loaded.tg.gen.tgtSlots_xy_mm(:,2),'x','markersize',10,'color','k');
        % start marker
        rectangle('position',[loaded.tg.start_pos_mm(1)-loaded.tg.start_r_mm loaded.tg.start_pos_mm(2)-loaded.tg.start_r_mm loaded.tg.start_r_mm*2 loaded.tg.start_r_mm*2],'EdgeColor','k','FaceColor','k','Curvature',[1 1]);
        % mark center of mass of all items
        plot(comCoords(1),comCoords(2),'marker','+','markersize',12,'markeredgecolor','w','markerfacecolor','w','linewidth',2);        
        plot(comCoords(1),comCoords(2),'marker','+','markersize',10,'markeredgecolor','k','markerfacecolor','k');        
        
        set(gca,'nextplot','add');                        
        
        axis equal; xlim(xAxLims); ylim(yAxLims); grid on;
        set(gca,'nextplot','replacechildren');        
        
    end
        
    replot = 0;
end

    function pb_next_callback(hObject, callbackdata)
        
        if curTrial < nTrials
            curTrial = curTrial + 1;
            replot = 1;
        end
        
    end

    function pb_back_callback(hObject, callbackdata)
        
        if curTrial > 1
            curTrial = curTrial - 1;
            replot = 1;
        end
        
    end

    function ed_IDsearch_callback(hObject, callbackdata)
        rowNum = [];
        rowNum = find(loaded.tg.triallist(:,loaded.tg.triallistCols.trialID) == str2num(hObject.String));
        if ~isempty(rowNum)
            curTrial = rowNum;
            replot = 1;
        end
        set(IDsearch,'string','enter trial ID');
    end

end


