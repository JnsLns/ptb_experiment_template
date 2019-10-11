function trajViewerComparison_temp(tr_1,rs_1,xAxLims_1,yAxLims_1,tr_2,rs_2,xAxLims_2,yAxLims_2,resCols,trajCols,sptStrings,yAxReverseFlags,showOnlyOne,pxPerMm)
%
% Note: showOnlyOne == 1 --> show only raw trajectories
%       showOnlyOne == 2 --> show only transformed trajectories
%       showOnlyOne == 0 --> show both
%
% regardless of value of showOnlyOne, both data must be provided (this can
% easily be changed in function code).

if nargin < 13
    showOnlyOne = 0;
end

% Plot transformed alongside raw trajectories...


nTrajs = numel(tr_1);
nItems = resCols.horzPosEnd-resCols.horzPosStart;
refColor = [1 0 0];
tgtColors = colormap(summer(nItems));

% figure size depending on screen size
ss = get(0,'screenSize');
fHeight = round(ss(4)*0.85);
fWidth = 0.72 * fHeight;
fPosHorz = round(ss(3)/2-fWidth/2);
fPosVert = ss(4)-fHeight-ss(4)*0.05;
trajPlots = figure('position',[fPosHorz fPosVert fWidth fHeight],'color','w','DockControls','off','MenuBar','none','Name','Raw versus trimmed/translated/rotated trajectories');
nextButton = uicontrol('style','pushbutton','string','next','position',[75 25 75 50],'callback',@pb_next_callback);
backButton = uicontrol('style','pushbutton','string','prev.','position',[0 25 75 50],'callback',@pb_back_callback);
IDsearch = uicontrol('style','edit','string','enter trial ID','position',[150 25 75 50],'callback',@ed_IDsearch_callback);

trajNumBox = uicontrol('style','text','string','','position',[0 0 fWidth 20],'fontsize',10);


switch showOnlyOne
    case 1
    loopAxes = 1;
    fHeight = round(ss(4)*0.85);
    fWidth =1.65 * fHeight;
    fPosHorz = round(ss(3)/2-fWidth/2);
    fPosVert = ss(4)-fHeight-ss(4)*0.05;
    set(gcf,'position',[fPosHorz fPosVert fWidth fHeight]);
    case 2
    loopAxes = 2;
    fHeight = round(ss(4)*0.85);
    fWidth =1.65 * fHeight;
    fPosHorz = round(ss(3)/2-fWidth/2);
    fPosVert = ss(4)-fHeight-ss(4)*0.05;
    set(gcf,'position',[fPosHorz fPosVert fWidth fHeight]);
    case 0
    loopAxes = [1 2];
end
  

curTraj = 1;
replot = 1;

while 1
    
    pause(0.0001);
    
    if ~ishandle(trajPlots)
        return
    end
    
    if replot
        
        sptString = sptStrings{rs_1(curTraj,resCols.spt)};
        ID = num2str(rs_1(curTraj,resCols.trialID));
        curTgtFit = num2str(rs_2(curTraj,resCols.tgtFit));
        curDtrFit = num2str(rs_2(curTraj,resCols.dtrFit));
        curRelFit = num2str(rs_2(curTraj,resCols.tgtMinDtrFit));
                
        set(trajNumBox,'string',['traj.#: ', num2str(curTraj), ' / ', num2str(nTrajs), ' ("', sptString, '", sptCode: ', num2str(rs_1(curTraj,resCols.spt)), ', tgtFit: ', curTgtFit, ', dtrFit: ', curDtrFit, ', trial ID: ', ID, ')']);                                                
        
        % display some values from results matrix in matlab prompt
        disp(['----traj. ', num2str(curTraj),' / ', num2str(rs_2(curTraj,resCols.trialID)), '-------------']); 
        disp([' reference side to dir. path: ', num2str(rs_2(curTraj,resCols.refSide))])
        disp(['       com side to dir. path: ', num2str(rs_2(curTraj,resCols.comSide))])
        disp(['dist non chosen to dir. path: ', num2str(rs_2(curTraj,resCols.distNonChosenToDirPath))])
        disp(['side non chosen to dir. path: ', num2str(rs_2(curTraj,resCols.sideNonChosenToDirPath))])
        
        
        for curAx = loopAxes
            
            switch curAx
                case 1                    
                    results = rs_1; trajectories = tr_1; xAxLims = xAxLims_1./pxPerMm(1); yAxLims = yAxLims_1./pxPerMm(2); xAxLabel = 'millimeters'; yAxLabel = 'millimeters';                                            
                case 2
                    results = rs_2; trajectories = tr_2; xAxLims = xAxLims_2; yAxLims = yAxLims_2; xAxLabel = 'millimeters'; yAxLabel = 'millimeters';
            end
            
            % number of target item
            tgtNum = results(curTraj,resCols.tgt);
            % number of target item
            refNum = results(curTraj,resCols.ref);
            % color code of item defined as target (usually best-fitting item in target color)
            tgtColCode = results(curTraj,resCols.colorsStart-1+tgtNum);
            % item numbers of items having that color (i.e., other potential targets, i.e. "target distracters")
            potTgtsNum = find(results(curTraj,resCols.colorsStart:resCols.colorsEnd) == tgtColCode);
            potTgtsNum(potTgtsNum == tgtNum) = [];            
            % Center of mass
            comCoords = sum([results(curTraj,resCols.horzPosStart:resCols.horzPosEnd)',results(curTraj,resCols.vertPosStart:resCols.vertPosEnd)'])/(nItems+1);
            
            if showOnlyOne == 0 
                subplot(2,1,curAx)
            end                          
              
            % Delete everything from all axes          
            if curAx == min(loopAxes)
                allAxes = findobj(trajPlots,'type','axes');
                for axnum = 1:numel(allAxes)
                    delete(allchild(allAxes(axnum)));
                end
            end
            
            % Plot all items            
            curItems_xyr = [results(curTraj,resCols.horzPosStart:resCols.horzPosEnd)',results(curTraj,resCols.vertPosStart:resCols.vertPosEnd)',results(curTraj,resCols.itemRadiiStart:resCols.itemRadiiEnd)'];
            curItems_xyr = curItems_xyr./repmat([pxPerMm,mean(pxPerMm)],size(curItems_xyr,1),1);
            for curItem = 1:size(curItems_xyr,1)
                if curItem == tgtNum
                    %curFaceColor = [0 1 0]; curEdgeColor = [0 0 0];
                    curFaceColor = [0 1 0]; curEdgeColor = [1 1 1];
                elseif curItem == refNum
                    curFaceColor = [1 0 0]; curEdgeColor = [1 1 1];
                elseif any(curItem == potTgtsNum)
                    curFaceColor = [0 1 0]; curEdgeColor = [1 1 1];
                else
                    curFaceColor = [.35 .35 .35]; curEdgeColor = [0 0 0];                    
                end
                % enable if to omit filler items in plot
                %if curItem == tgtNum || curItem == refNum || any(curItem == potTgtsNum)
                rectangle('position',[curItems_xyr(curItem,1)-curItems_xyr(curItem,3), curItems_xyr(curItem,2)-curItems_xyr(curItem,3), curItems_xyr(curItem,3)*2, curItems_xyr(curItem,3)*2],'curvature',[1,1],'facecolor',curFaceColor,'edgeColor',curEdgeColor);                
                %end
            end                                    
            
            set(gca,'nextplot','add');  
            
            % mark center of mass of all items
            plot(comCoords(1)/pxPerMm(1),comCoords(2)/pxPerMm(2),'marker','d','markersize',10,'markeredgecolor','k','markerfacecolor','y');                                       
            
            % add time markers on trajectory every 100 ms
            if curAx == 2
                tmStart = 0.1; % every 100 ms
                tmStep = 0.1;
                timePoints = tmStart:tmStep:max(trajectories{curTraj}(:,trajCols.t));
                lndcs = [];
                for i = 1:numel(timePoints)
                    curTp = timePoints(i);
                    [~,lndcs(end+1)] = min(abs(trajectories{curTraj}(:,trajCols.t)-curTp));
                end
                plot(trajectories{curTraj}(lndcs,trajCols.x),trajectories{curTraj}(lndcs,trajCols.y),'o','MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor','none','markersize',4);
            end
            
            % plot trajectory
            %plot(trajectories{curTraj}(:,trajCols.x),trajectories{curTraj}(:,trajCols.y),'linewidth',2,'color','b');
            axis equal; xlim(xAxLims); ylim(yAxLims); grid on;                        
            
            set(gca,'nextplot','replacechildren');
            
            % reverse y axis
            if yAxReverseFlags(curAx) 
                set(gca,'ydir','reverse');
            end
            xlabel(xAxLabel); ylabel(yAxLabel);
            
        end
                                               
        
        replot = 0;
    end
    
end



    function pb_next_callback(hObject, callbackdata)
        
        if curTraj < nTrajs
            curTraj = curTraj + 1;
            replot = 1;
        end
        
    end

    function pb_back_callback(hObject, callbackdata)
        
        if curTraj > 1
            curTraj = curTraj - 1;
            replot = 1;
        end
        
    end

    function ed_IDsearch_callback(hObject, callbackdata)                
        rowNum = [];
        rowNum = find(rs_1(:,resCols.trialID) == str2num(hObject.String));        
        if ~isempty(rowNum)        
            curTraj = rowNum;
            replot = 1;                                
        end        
        set(IDsearch,'string','enter trial ID');
    end

end


