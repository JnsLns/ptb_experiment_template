if aTmp.plotOtherResults
    
    disp('Plotting other data');
    
    %figure
    %set(gcf,'name',aTmp.titleStr{1},'numbertitle','off')
    
    
    % Get column with plot settings from IV definition array
    plotStyles = a.s.ivs(:,a.s.ivsCols.style);
    
    % check whether errors are supplied, if not, make dummy array same size as
    % aTmp.plotWhat_rs
    errorsSupplied = 1;
    if isempty(aTmp.plotWhat_rs_errors)
        aTmp.plotWhat_rs_errors = cellfun(@(x) x-x, aTmp.plotWhat_rs,'uniformoutput',0);
        errorsSupplied = 0;
    end
    
    % Remove from individual data matrices everything but the value that should
    % be plotted
    aTmp.plotWhat_rs = cellfun(@(x) {x(aTmp.plotCol)}, aTmp.plotWhat_rs);
    aTmp.plotWhat_rs_errors = cellfun(@(x) {x(aTmp.plotCol)}, aTmp.plotWhat_rs_errors);
    
    % For non-trajectory data, LineColor and LineStyle are interpreted as
    % different bars and different bar groups in a bar plot, respectively.
    barDim = find(cellfun(@(x) strcmp(x,'lineColor'),plotStyles));
    barGroupDim = find(cellfun(@(x) strcmp(x,'lineStyle'),plotStyles));
    barTitles = '';
    barGroupTitles = '';
    
    % "Collapse" data array along dimensions that will be represented as bars
    % and/or bar groups, making a matrix out of the collapsed data so thst it
    % can be fed to the bar() function.
    if ~isempty(barDim)
        % Collapse aTmp.plotWhat_rs along dimension that should later be represented as
        % different bars (formerly line color)
        aTmp.plotWhat_rs = cellCollapse(aTmp.plotWhat_rs,barDim,2);
        aTmp.plotWhat_rs_errors = cellCollapse(aTmp.plotWhat_rs_errors,barDim,2);
        barTitles = a.s.ivs{barDim,a.s.ivsCols.valLabels};
    end
    if ~isempty(barGroupDim)
        % Then further collapse aTmp.plotWhat_rs along dimension that should later be represented as
        % different bar groups (formerly line style)
        aTmp.plotWhat_rs = cellCollapse(aTmp.plotWhat_rs,barGroupDim,1);
        aTmp.plotWhat_rs_errors = cellCollapse(aTmp.plotWhat_rs_errors,barGroupDim,1);
        barGroupTitles = a.s.ivs{barGroupDim,a.s.ivsCols.valLabels};
    end
    
    % If only bars are specified but not barGroups (i.e., lineColor but no lineStyle
    % row in a.s.ivs), the bar plot uses the specified bars as groups of one bar each;
    % therefore move barTitles to barGroupTitles for correct labelling.
    if isempty(barGroupDim) && ~isempty(barDim)
        barGroupTitles = barTitles;
        barTitles = '';
    end
    
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
    figureDim = find(cellfun(@(x) strcmp(x,'figures'),plotStyles));
    numFigures = 1;
    if ~isempty(figureDim)
        numFigures = numel(a.s.ivs{figureDim,a.s.ivsCols.valLabels});
    end
    
    
    %% Go through data array by linear index, set plot target based on subscript indices, and plot
    hFigures = zeros(numFigures,1);
    for ndx = 1:numel(aTmp.plotWhat_rs)
        
        % Get subscript indices to the components of the data array
        subs = ind2subAll(size(aTmp.plotWhat_rs),ndx);
        
        % Set plot styles to correct value and get title of all elements
        if numFigures > 1
            curFig = subs(figureDim);
            figTitle = a.s.ivs{figureDim,a.s.ivsCols.valLabels}{subs(figureDim)};
        else
            curFig = 1;
            figTitle = '';
        end
        if numSubRows > 1
            subRow = subs(subRowDim);
            subRowTitle = a.s.ivs{subRowDim,a.s.ivsCols.valLabels}{subs(subRowDim)};
        else
            subRow = 1;
            subRowTitle = '';
        end
        if numSubCols > 1
            subCol = subs(subColDim);
            subColTitle = a.s.ivs{subColDim,a.s.ivsCols.valLabels}{subs(subColDim)};
        else
            subCol = 1;
            subColTitle = '';
        end
        
        % Make/ select figure
        if hFigures(curFig) == 0
            hFigures(curFig) = figure('name',aTmp.titleStr{1});
        end
        set(0, 'currentfigure', hFigures(curFig));
        
        % Make/select appropriate subplot according to values determined above
        if ~isempty(subRowDim); spRowMult = subs(subRowDim)-1; else spRowMult = 0; end
        if ~isempty(subColDim); spColAdd = subs(subColDim); else spColAdd = 1; end
        subplot(numSubRows, numSubCols, spRowMult*numSubCols+spColAdd);
        
        % Get data to plot
        curData = aTmp.plotWhat_rs{ndx};
        curData_errors = aTmp.plotWhat_rs_errors{ndx};
        
        % Plot
        h = bar(aTmp.plotWhat_rs{ndx},'edgecolor','flat');
        if ~isempty(barTitles)
            legend(barTitles);
        end
        set(gca, 'XTickLabel', barGroupTitles,'XTickLabelRotation',45,'ygrid','on','ticklength',[0 0],...
            'YLim',aTmp.rsYLims);
        
        % add errorbars
        if errorsSupplied
            xData= get(h,'xData');
            yData= get(h,'yData');
            if isa(xData,'cell')
                xData = cell2mat(xData);
                yData = cell2mat(yData);
            end
            xpositions = xData+repmat([h.XOffset]',1,size(yData,2));
            hold on;
            errorbar(xpositions,yData,curData_errors','.','marker','none','linewidth',0.75,'color','k');
            hold off;
        end
        
        % add title to current subplot
        if ~isempty(subRowTitle) && ~isempty(subRowTitle)
            separator = ' / ';
        else
            separator = '';
        end
        title([subRowTitle,separator,subColTitle]);
        
        
    end
    
end

clearvars -except a e tg aTmp