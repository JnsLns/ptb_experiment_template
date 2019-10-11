if aTmp.plotTrajectories

    disp('Plotting trajectories...');        
    
    % Determine plot settings and number of dims from a.s.ivs
    plotStyles = a.s.ivs(:,a.s.ivsCols.style);
    
    % Find dimension/iv numbers and corresponding plot styles; how many of each style?
    subColDim = find(cellfun(@(x) strcmp(x,'subplotColumns'),plotStyles));
    numSubCols = 1;
    if ~isempty(subColDim)
        numSubCols = numel(a.s.ivs{subColDim,a.s.ivsCols.valLabels});
    end
    
    subRowDim = find(cellfun(@(x) strcmp(x,'subplotRows'),plotStyles));
    numSubRows = 1;
    if ~isempty(subRowDim)
        numSubRows = numel(a.s.ivs{subRowDim,a.s.ivsCols.valLabels});
    end
    
    lineColorDim = find(cellfun(@(x) strcmp(x,'lineColor'),plotStyles));
    numLineColors = 1;
    if ~isempty(lineColorDim)
        numLineColors = numel(a.s.ivs{lineColorDim,a.s.ivsCols.valLabels});
    end
    
    lineStyleDim = find(cellfun(@(x) strcmp(x,'lineStyle'),plotStyles));
    numLineStyles = 1;
    if ~isempty(lineStyleDim)
        numLineStyles = numel(a.s.ivs{lineStyleDim,a.s.ivsCols.valLabels});
    end
    
    figureDim = find(cellfun(@(x) strcmp(x,'figures'),plotStyles));
    numFigures = 1;
    if ~isempty(figureDim)
        numFigures = numel(a.s.ivs{figureDim,a.s.ivsCols.valLabels});
    end
    
    % ----
    
            
    % Go through cells of data array and make one plot with the data in each cell.
    hLines = [];
    hPatches = [];
    hFigures = zeros(numFigures,1);
    hText = [];
    for ndx = 1:numel(aTmp.plotWhat_tr)
        
        % Get set of trajs or single traj for this plot (plus get subscript indices)
        curData = aTmp.plotWhat_tr{ndx};
        subs = ind2subAll(size(aTmp.plotWhat_tr),ndx);
        
        % Set plot styles to correct value and get title of all elements
        try
            curFig = subs(figureDim);
            figTitle = a.s.ivs{figureDim,a.s.ivsCols.valLabels}{subs(figureDim)};
        catch
            curFig = 1;
            figTitle = '';
        end
                
        try
            subRow = subs(subRowDim);
            subRowTitle = a.s.ivs{subRowDim,a.s.ivsCols.valLabels}{subs(subRowDim)};
        catch
            subRow = 1;
            subRowTitle = '';
        end
                
        try
            subCol = subs(subColDim);
            subColTitle = a.s.ivs{subColDim,a.s.ivsCols.valLabels}{subs(subColDim)};
        catch
            subCol = 1;
            subColTitle = '';
        end
                
        try
            clr = aTmp.plotColors{subs(lineColorDim)};
            clrTitle = a.s.ivs{lineColorDim,a.s.ivsCols.valLabels}{subs(lineColorDim)};
        catch
            clr = aTmp.plotColors{1};
            clrTitle = '';
        end
                
        try
            sty = aTmp.lineStyles{subs(lineStyleDim)};
            styTitle = a.s.ivs{lineStyleDim,a.s.ivsCols.valLabels}{subs(lineStyleDim)};
        catch
            sty = aTmp.lineStyles{1};
            styTitle = '';
        end
        
        % Make/ select figure
        if hFigures(curFig) == 0
            hFigures(curFig) = figure('name',aTmp.titleStr{1}, 'color', 'w');
        end
        set(0, 'currentfigure', hFigures(curFig));        
        
        % Make/select subplot
        if ~isempty(subRowDim); spRowMult = subs(subRowDim)-1; else spRowMult = 0; end
        if ~isempty(subColDim); spColAdd = subs(subColDim); else spColAdd = 1; end
        curSubAxis = spRowMult*numSubCols+spColAdd;
        subplot(numSubRows, numSubCols, curSubAxis);
        
        if ~isempty(clrTitle) && ~isempty(styTitle)
            separator = ' / ';
        else
            separator = '';
        end
        
        % Plot single trajectory (for means and the like)
        if isa(curData,'double') && ~isempty(curData)
            
            if numel(aTmp.plotY) == 1
                yData = curData(:,aTmp.plotY)';
            elseif numel(aTmp.plotY) > 1
                yData = aTmp.plotY;
            end
            if numel(aTmp.plotX) == 1
                xData = curData(:,aTmp.plotX);
            elseif numel(aTmp.plotX) > 1
                xData = aTmp.plotX;
            end
            
            % Number of trials in plotted condition
            try
                nCases = [' (n=',num2str(a.res.ncs(ndx)),')'];
            catch
                nCases = '';
            end
            
            hLines(end+1) = ...
                plot(xData,yData,'color',clr,'linestyle',sty,'linewidth',aTmp.lineWidth, ...
                'DisplayName',[clrTitle,separator,styTitle,nCases]);
            set(hLines(end),'tag','dataLine');
            
            set(gca,'nextplot','add','XLim',aTmp.xLims,'YLim',aTmp.yLims);
            
            % add error region if error data supplied
            if ~isempty(aTmp.plotWhat_tr_errors)
                xData_errors = aTmp.plotWhat_tr_errors{ndx}(:,aTmp.plotX_errors);
                xData_errors = [xData-xData_errors; flipud(xData+xData_errors)];
                xData_errors(isnan(xData_errors)) = 0;
                yData_errors = [yData';flipud(yData')];
                yData_errors(isnan(yData_errors)) = 0;
                hPatches(end+1) = fill(xData_errors, yData_errors, ...
                    get(hLines(end),'color'),'facealpha',0.07,'linestyle','none');
                set(get(get(hPatches(end),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            end
            
            
            % Plot multiple trajectories in same style (for individual trajectories)
        elseif isa(curData,'cell') && ~isempty(curData)
            
            % Loop through trajectories
            for k = 1:numel(curData)
                
                curTraj = curData{k};
                
                if numel(aTmp.plotY) == 1
                    yData = curTraj(:,aTmp.plotY);
                elseif numel(aTmp.plotY > 1)
                    yData = aTmp.plotY;
                end
                if numel(aTmp.plotX) == 1
                    xData = curTraj(:,aTmp.plotX);
                elseif numel(aTmp.plotX > 1)
                    xData = aTmp.plotX;
                end
                
                hLines(end+1) = ...
                    plot(xData,yData,'color',clr,'linestyle',sty,'linewidth',aTmp.lineWidth, ...
                    'DisplayName',[clrTitle,separator,styTitle]);
                grid on;
                set(gca,'nextplot','add');
                
                if k ~= 1
                    set(get(get(hLines(end),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
                end
                
            end
            
        end
                
        set(gca,'nextplot','add','XLim',aTmp.xLims,'YLim',aTmp.yLims,'xgrid','on','ygrid','on');
        
        % add x-axis label for lowest row of subplot
        if ceil(curSubAxis/numSubCols) == numSubRows
            xlabel(aTmp.xAxLbl);
        end
        
        % add y-labels and -ticks as specified and depending on position in subplot
        if ~isempty(aTmp.yTkLbl) && ~isempty(aTmp.yTkLoc)
            set(gca, 'YTickLabel',aTmp.yTkLbl,'YTick',aTmp.yTkLoc);
        end
        
        if isempty(subColDim)  ||  spColAdd == 1
            ylabel(aTmp.yAxLbl);
        end
        
        % remove/ switch side of y-axis for axes within/ on side of subplot
        if spColAdd == numSubCols && spColAdd ~= 1
            set(gca, 'yaxislocation', 'right');
        elseif spColAdd ~= 1
            set(gca, 'yticklabel', []);
        end
                
        % add title to subplot
        if ~isempty(subRowTitle) && ~isempty(subRowTitle)
            separator = ' / ';
        else
            separator = '';
        end
        title([subRowTitle,separator,subColTitle]);
                
    end
    
    
    % activate legends
     hAllAxes = findobj(hFigures,'type','axes'); % all axes in newly generated figures
     for curAx = 1:numel(hAllAxes)
         axes(hAllAxes(curAx)); % make current                    
         legend('show')        
     end
    
    % add supertitle above subplot in each figure
    for curFig = 1:numel(hFigures)
        figure(hFigures(curFig)); % make current
        suptitle(aTmp.superSubplotTitle)
    end
    
end

%clearvars -except a e tg aTmp