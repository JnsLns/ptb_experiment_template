function trajViewerTwoPair(tr_1,rs_1,xAxLims_1,yAxLims_1,resCols,trajCols,sptStrings,yAxReverseFlag)


nTrajs = numel(tr_1);
nItems = resCols.horzPosEnd-resCols.horzPosStart;
refColor = [1 0 0];
tgtColors = colormap(summer(nItems)); close(gcf); 

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


curTraj = 1;
replot = 1;
isFirstRun = 1;

while 1
    
    pause(0.0001);
    
    if ~ishandle(trajPlots)
        return
    end
    
    if replot
        
        sptString = sptStrings{rs_1(curTraj,resCols.spt)};
        ID = num2str(rs_1(curTraj,resCols.trialID));
                
        set(trajNumBox,'string',['traj.#: ', num2str(curTraj), ' / ', num2str(nTrajs), ' ("', sptString, '", sptCode: ', num2str(rs_1(curTraj,resCols.spt)), ' trial ID: ', ID, ')']);                                                
                
        results = rs_1; trajectories = tr_1; xAxLims = xAxLims_1; yAxLims = yAxLims_1; xAxLabel = 'millimeters'; yAxLabel = 'millimeters';                                            
                    
            % number of target item
            tgtNum = results(curTraj,resCols.tgt);
            % number of ref1 item
            refNum = results(curTraj,resCols.ref);
            % number of ref2 item
            ref2Num = results(curTraj,resCols.ref2);            
            % additional item condition
            addItemCond = results(curTraj,resCols.additionalItemCondition);            
            % color code of item defined as target (usually best-fitting item in target color)
            tgtColCode = results(curTraj,resCols.colorsStart-1+tgtNum);
            % item numbers of items having that color (i.e., other potential targets, i.e. "target distracters")
            potTgtsNum = find(results(curTraj,resCols.colorsStart:resCols.colorsEnd) == tgtColCode);
            potTgtsNum(potTgtsNum == tgtNum) = [];            
            % Center of mass
            comCoords = sum([results(curTraj,resCols.horzPosStart:resCols.horzPosEnd)',results(curTraj,resCols.vertPosStart:resCols.vertPosEnd)'])/(nItems+1);
            
%             if showOnlyOne == 0 
%                 subplot(2,1,curAx)
%             end                          
              
            % Delete everything from all axes          
            %if curAx == min(loopAxes)
                allAxes = findobj(trajPlots,'type','axes');
                for axnum = 1:numel(allAxes)
                    delete(allchild(allAxes(axnum)));
                end
            %end
            
            % Plot all items            
            curItems_xyr = [results(curTraj,resCols.horzPosStart:resCols.horzPosEnd)',results(curTraj,resCols.vertPosStart:resCols.vertPosEnd)',results(curTraj,resCols.itemRadiiStart:resCols.itemRadiiEnd)'];
            for curItem = 1:size(curItems_xyr,1)
                if curItem == tgtNum
                    curFaceColor = [0 1 0]; curEdgeColor = [0 0 0];
                elseif curItem == refNum
                    curFaceColor = [1 0 0]; curEdgeColor = [1 1 1];
                elseif curItem == ref2Num && any(addItemCond == [1 2])
                    curFaceColor = [1 0 0]; curEdgeColor = [1 1 1];
                elseif any(curItem == potTgtsNum) 
                    curFaceColor = [0 1 0]; curEdgeColor = [1 1 1];
                else
                    curFaceColor = [.35 .35 .35]; curEdgeColor = [0 0 0];
                end
                rectangle('position',[curItems_xyr(curItem,1)-curItems_xyr(curItem,3), curItems_xyr(curItem,2)-curItems_xyr(curItem,3), curItems_xyr(curItem,3)*2, curItems_xyr(curItem,3)*2],'curvature',[1,1],'facecolor',curFaceColor,'edgeColor',curEdgeColor);                
            end                                    
            
            set(gca,'nextplot','add');  
            
            % mark center of mass of all items
            plot(comCoords(1),comCoords(2),'marker','d','markersize',10,'markeredgecolor','k','markerfacecolor','y');                                       
                                              
            % plot trajectory
            plot(trajectories{curTraj}(:,trajCols.x),trajectories{curTraj}(:,trajCols.y),'linewidth',2,'color','b');
            
            
            % add time markers on trajectory every 100 ms           
            tmStart = 0.1; % every 100 ms
            tmStep = 0.1;
            timePoints = tmStart:tmStep:max(trajectories{curTraj}(:,trajCols.t))-min(trajectories{curTraj}(:,trajCols.t));
            lndcs = [];
            for i = 1:numel(timePoints)
                curTp = timePoints(i);
                [~,lndcs(end+1)] = min(abs((trajectories{curTraj}(:,trajCols.t)-min(trajectories{curTraj}(:,trajCols.t))-curTp)));
            end
            plot(trajectories{curTraj}(lndcs,trajCols.x),trajectories{curTraj}(lndcs,trajCols.y),'o','MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor','none','markersize',4);
                        
            axis equal; xlim(xAxLims); ylim(yAxLims); grid on;
            set(gca,'nextplot','replacechildren');
            box on
            xlabel(xAxLabel); ylabel(yAxLabel);
            % reverse y axis
            if yAxReverseFlag
                set(gca,'ydir','reverse');
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


