if aTmp.doPlotConstraintCategoryDistribution && (isfield(a.s,'relevantBalancingColumn') && ~isempty(a.s.relevantBalancingColumn))
                                                 
    disp('Plotting constraint categories...');
        
    % Switch legend entries depending on which column is provided for
    % balancing information regarding the position of ref/com/dtr    
    switch a.s.relevantBalancingColumn
        case a.s.resCols.refVsComVsNciSide % for reference position effect
            balancingLegendEntries = {'cs/ds','cs/do','co/ds','co/do'};
            useHistBins = 1:4;
        case a.s.resCols.comVsRefVsNciSide % for com position effect
            balancingLegendEntries = {'rs/ds','rs/do','ro/ds','ro/do'};
            useHistBins = 1:4;
        case a.s.resCols.nciVsRefVsComSide % for non chosen item in tgt color position effect
            balancingLegendEntries = {'rs/cs','rs/co','ro/cs','ro/co'};            
            useHistBins = 1:4;
        case a.s.resCols.absSideCategoryNciRefCom % for overall effects
            balancingLegendEntries = {'dl/rl/cl','dr/rl/cl','dl/rr/cl','dr/rr/cl','dl/rl/cr','dr/rl/cr','dl/rr/cr','dr/rr/cr'};
            useHistBins = 1:8;
    end           
    
    % Compute histograms of numbers of each constraint Category for each of the trial sets in current IV configuration
    rsIndivConstraintHist_n = cell(size(a.res.ind));
    rsIndivConstraintHist_xout = rsIndivConstraintHist_n;
    for curIdx = 1:numel(a.res.ind)
        [histn,histxout] = ...
            hist(a.res.ind{curIdx}(:,a.s.relevantBalancingColumn),useHistBins);
        rsIndivConstraintHist_n{curIdx} = histn;
        histxout = histxout(:)';
        rsIndivConstraintHist_xout{curIdx} = histxout;
    end
    
        
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
    
    % For constraint distribution, each line in trajectory plots
    % corresponds to one bar group (and each group includes one bar for
    % each constraint category). Therefore, rsIndivConstraintHist_n and
    % rsIndivConstraintHist_n need to be collapsed along those dimensions
    % (as well as the line title arrays).
    % The data is concatenated along dimension 1, as bar interprets
    % different rows as different bar groups
    
    if ~isempty(lineColorDim)
        rsIndivConstraintHist_n = cellCollapse(rsIndivConstraintHist_n,lineColorDim,1);
        rsIndivConstraintHist_xout = cellCollapse(rsIndivConstraintHist_xout,lineColorDim,1);
        
    end
    if ~isempty(lineStyleDim)
        rsIndivConstraintHist_n = cellCollapse(rsIndivConstraintHist_n,lineStyleDim,1);
        rsIndivConstraintHist_xout = cellCollapse(rsIndivConstraintHist_xout,lineStyleDim,1);            
    end
    
    
    % Make bar group label strings
    if ~isempty(lineColorDim) && ~isempty(lineStyleDim)
        separator = ' / ';
    else
        separator = '';
    end
    
    % initialize cell with titles for all bar groups
    barGroupTitles = cell(size(rsIndivConstraintHist_n{1},1),1);
        
    % Generate bar group titles
    for ls = 1:numLineStyles
        for lc = 1:numLineColors            
            
            if numLineColors > 1
                curColorLabel = a.s.ivs{lineColorDim,a.s.ivsCols.valLabels}{lc};
            else
                curColorLabel = '';
            end
            
            if numLineStyles > 1
                curStyleLabel = a.s.ivs{lineStyleDim,a.s.ivsCols.valLabels}{ls};
            else
                curStyleLabel = '';
            end
            
            barGroupTitles{lc+(ls-1)*numLineColors} = ...
                [curColorLabel,separator,curStyleLabel];
        end
    end
    
    
    
    % ----
    
    % Go through cells of data array and make one plot with the data in each cell.
    hFigures = zeros(numFigures,1);
    
    
    for histNdx = 1:numel(rsIndivConstraintHist_n);
        
        subs = ind2subAll(size(rsIndivConstraintHist_n),histNdx);
        
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
        
        curData_n = rsIndivConstraintHist_n{histNdx};
        curData_x = rsIndivConstraintHist_xout{histNdx};
        
        
        
        % Plot proportion of trials for each constraint category
        colormap([.6 .6 1; 1 .6 .6; 0 0 .75; .75 0 0]);
        curData_proportion = curData_n./repmat(sum(curData_n,2),1,size(curData_n,2));
        bar(curData_proportion);                        
        %bar(curData_proportion,'stacked');                        
        set(gca,'xtick',1:numel(barGroupTitles))
        set(gca,'xticklabels',barGroupTitles)
        ylim([0 1])        
        legend(balancingLegendEntries);        
        set(gca,'XTickLabelRotation',45,'ygrid','on','ticklength',[0 0]);
                
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


clearvars -except a e tg aTmp