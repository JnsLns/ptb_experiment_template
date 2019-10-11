
% This is almost the same as done_styleVersion_ExtractAndFormatFigureForExportAndSave
% but for histogram plots (of curvature distribution, but might work for
% others as well)

doSaveFig = 0; % save figure file of modified (stylized) figure?
doExportPdf = 1; % save pdf version of modified (stylized) figure?

% Settings for new axes
newXLims = [-0.25 pi+0.1]; % For trajectory plots over space
XTickVals = [0 pi/2 pi]; % For trajectory plots over space
minYMarginToUpperBorder = 50; % Minimum distance between highest bar and upper border of axes (in y units)
unitsBelowBaseline_y = 100; % margin on the left 

% centimeters.

% if 1, height is determined dynamically such that max values fit and scaling is constant across figures.
dynamicHeight = 0;
yMaxFixed = 1400; % upper ylim only; effective if dynamicHeight==0
figHeight = 4.93;  % figure height [cm]; only effective if dynamicHeight==0
figWidth = 5; 
heightDiv = 150; % [maximum y value in data / heightDiv] determines figure height in cm

cutoff = 0.9335; % curvature cutoff (determines bar coloring)
x0 = 0; % xlim start
xMax = pi; % xlim end
colorBelowThresh = 'b';
colorAboveThresh = 'r';

%xLbl = 'Dev. from Direct Path [mm]'; % these replace existing axes labels (code may be adjusted to use existing ones)
%yLbl = '% Total Movement Time';
xLbl = ''; % these replace existing axes labels (code may be adjusted to use existing ones)
yLbl = '';
disableXTickLabels = true;
disableYTickLabels = true;
newDirName = 'cleanSingleAxes'; %new dir in figure's directory where extracted figure is  saved
useFontSize = 10;
labelFontSizeMulti = 1; % size of axes lables relative to useFontSize    
axBgColor = [.915 .915 .915];  % axes backgroudn color
patchAlpha = 0.08; % face alpha
patchEdgeAlpha = 0.5; 
patchEdgeStyle = ':'; 
patchEdgeDarken = 0.7; % patch facecolor is multiplied by this to get to edge color
overallLineColor = [.5 .5 .5]; % settings for average line
overallLineStyle = ':';
overallLineWidth = 1.25;
%dataLinesWidth = 1.5; % width of data lines for diss mean traj plots
dataLinesWidth = 0.2; % width of data lines for diss individual traj plots
gridLineWidth = 1; % thickness of grid lines (also determines tick width)
gridAlpha = 0.8;
outlineLineWidth = 2;
tickLength = [0.025 0.035];


%% Formatting

% Running this section will export all open axes to separate files

hAllAxes = findobj(0,'type','axes');
hAllFigs = findobj(0,'type','figure'); % use this to close source figures afterwards

for curAx = 1:numel(hAllAxes)
   
    % get current source
    hSourceAx = hAllAxes(curAx);
    hSourceFig = get(hSourceAx,'parent');

    % get values in original histogram and compute figure size, y lims, and y ticks
    if dynamicHeight
        histTmp = findobj(hSourceAx,'type','histogram');
        tmpa = [round(max(histTmp.Values),-2) round(max(histTmp.Values)+100,-2)] ;
        tmpb = find(tmpa > max(histTmp.Values));
        ymax = tmpa(tmpb(1));
        if ymax-max(histTmp.Values)<minYMarginToUpperBorder; ymax = max(histTmp.Values)+minYMarginToUpperBorder; end        
        figSize = [figWidth (ymax+unitsBelowBaseline_y)/heightDiv];
    else
        ymax = yMaxFixed;
        figSize = [figWidth figHeight];
    end
    newYLims = [-unitsBelowBaseline_y ymax];
    YTickVals = 0:100:ymax;
    
    
    % Make new figure and axes
    cmp = colormap;
    newFig = figure('color','w');    
    set(newFig, 'Units', 'Centimeters', 'Position', [0 0 figSize], 'PaperUnits', 'Centimeters', 'PaperSize', figSize)
    colormap(cmp);
    newAx = axes;
    
    % copy relevant children of source axes to new axes
    copyobj(get(hSourceAx,'children'),newAx)
    
    % copy relevant properties from source to new axes
    newAx.CLim = hSourceAx.CLim;
    newAx.YLim = hSourceAx.YLim;
    newAx.YTick = hSourceAx.YTick;
    newAx.YTickLabel = hSourceAx.YTickLabel;
    newAx.YLabel.String = yLbl;
    newAx.XLabel.String = xLbl;
    newAx.Color = 'none';
    if disableXTickLabels; newAx.XTickLabels = []; end;
    if disableYTickLabels; newAx.YTickLabels = []; end;
        
    % set other axes settings
    newAx.XGrid = 'off';
    newAx.YGrid = 'off';
    newAx.GridColor = 'none';    
               
    % set all axes xlims to same values
    set(findobj(newFig,'type','axes'),'xlim',newXLims);
        
    % adjustments to figure fonts etc.
    set(newFig,'PaperPositionMode','auto'); % needed to prevent font size from changing on export
    hAllChildNewFig = get(newFig,'children');
    set(hAllChildNewFig,'FontSize',useFontSize,'linewidth',1)
    set(hAllChildNewFig,'FontWeight','default')
    set(hAllChildNewFig,'FontName','LM Roman 12'); % needs this font installed
    set(newAx,'LabelFontSizeMultiplier',labelFontSizeMulti);            
        
    %-----------------------                  
    % cosmetics using overlayed axes 
    
    newAx.Color = axBgColor;   
    newAx.Tag = 'bgColorAx';
    newAx.Box = 'off';      
    newAx.XTick = [];       
    newAx.YTick = [];       
        
    curHist = findobj(newAx,'type','histogram');    
    histVals = curHist.Values;
    delete(curHist);    
    dataAx = copyobj(newAx,newFig);     
    set(gcf, 'currentaxes', dataAx);
    xSpan = linspace(x0,xMax,numel(histVals));
    for numVal = 1:numel(histVals)
        if xSpan(numVal)>cutoff
            useColor = colorAboveThresh;
        else
            useColor = colorBelowThresh;
        end
        bar(dataAx,xSpan(numVal),histVals(numVal),'facecolor',useColor,'barwidth',(xSpan(end)-xSpan(1))/numel(histVals)-((xSpan(end)-xSpan(1))/numel(histVals))*0.2,'ShowBaseLine','off')     
        hold on
    end    
    set(findobj(dataAx,'type','bar'),'linestyle','none')
    dataAx.Visible = 'off';  
    dataAx.Tag = 'barAx';     
    
    
    % Axes for white Grid
    whiteGridAx = copyobj(newAx,newFig);
    delete(whiteGridAx.Children) % delete all data from white axis        
    whiteGridAx.Color = 'none';
    whiteGridAx.Tag = 'whiteGridAx';
    whiteGridAx.GridColor = 'w';
    whiteGridAx.GridAlpha = gridAlpha;
    whiteGridAx.XGrid = 'on';
    whiteGridAx.YGrid = 'on';
    whiteGridAx.XAxis.Color = 'w';
    whiteGridAx.YAxis.Color = 'w';
    whiteGridAx.XAxis.TickLabel = [];
    whiteGridAx.XAxis.Label = [];
    whiteGridAx.YAxis.TickLabel = [];
    whiteGridAx.YAxis.Label = [];
    whiteGridAx.XAxis.TickLength = [0 0];
    whiteGridAx.YAxis.TickLength = [0 0];
    whiteGridAx.LineWidth = gridLineWidth;           
    whiteGridAx.XTick = XTickVals;           
    if ~isempty(YTickVals)
    whiteGridAx.YTick = YTickVals;
    end
        
    % Axes for black tick marks
    tickAx = copyobj(newAx,newFig);    
    delete(tickAx.Children) % delete all data  
    tickAx.Tag = 'tickAx';
    tickAx.Color = 'none'; tickAx.XGrid = 'off'; tickAx.YGrid = 'off';
    tickAx.XAxis.Color = 'k'; tickAx.YAxis.Color = 'k';
    tickAx.XAxis.TickLabel = []; tickAx.XAxis.Label = [];
    tickAx.YAxis.TickLabel = []; tickAx.YAxis.Label = [];    
    tickAx.LineWidth = whiteGridAx.LineWidth;    
    tickAx.XTick = XTickVals;   
    if ~isempty(YTickVals)
    tickAx.YTick = YTickVals;
    end
    tickAx.TickLength = tickLength;
    
    % Axes for white outline    
    whiteBoxAx = copyobj(whiteGridAx,newFig);
    whiteBoxAx.XGrid = 'off';  whiteBoxAx.YGrid = 'off';
    whiteBoxAx.Box = 'on';
    whiteBoxAx.LineWidth = outlineLineWidth;   
    whiteBoxAx.Tag = 'whiteBoxAx';
    
    % set same YLim for all axes
    set(findobj(newFig,'type','axes'),'YLim',newYLims);
    set(findobj(newFig,'type','axes'),'XLim',newXLims);
    
    % set all axes to fit figure size
    allAx = findobj(gcf,'type','axes');
    set(allAx, 'Units', 'normalized', 'Position', [0 0 1 1] );
    % and fix limits and ticks
    set(allAx,'XTickMode','manual','YTickMode','manual','XLimMode','manual','YLimMode','manual');
    % set export size to same dimensions as onscreen
    fig = gcf;
    fig.PaperUnits = 'centimeters';
    fig.PaperPosition = [0 0 figSize];
    %print('SameAxisLimits','-dpng','-r0')
           
    % Adjust order of elements 
    newFig.Children = newFig.Children([1 2 4 3 5]);
    
    % Delete all text and line
    try
    delete(findobj(gcf,'type','text'));
    end
    try
    delete(findobj(gcf,'type','line'));
    end
    
    if doSaveFig || doExportPdf
        fullFnSourceFig = get(hSourceFig,'filename');
        pathSourceFig = fullFnSourceFig;
        pathSourceFig(max(strfind(pathSourceFig,'\'))+1:end) = [];
        mkdir(pathSourceFig,newDirName);
        fnSourceFig = fullFnSourceFig;
        fnSourceFig = fnSourceFig(max(strfind(fnSourceFig,'\'))+1:end);        
        fnSaveFig = [fnSourceFig(1:end-4)];
    end
    
    if doSaveFig
        % save fig-file with extended file name (based on suptitle and axes title        
        try
            savefig([pathSourceFig,newDirName,'\',fnSaveFig,'.fig']);
        catch
            disp('ahhh!')
        end
    end
    
    if doExportPdf
        % save pdf-file
        mkdir([pathSourceFig,newDirName,'\'],'pdfVersions');
        
        myStyle = hgexport('factorystyle');
        myStyle.Format = 'pdf';
        myStyle.Width = figSize(1);
        myStyle.Height = figSize(2);
        myStyle.Resolution = 300;
        myStyle.Units = 'centimeters';
        %myStyle.FixedFontSize = 12;
        
        hgexport(newFig, [pathSourceFig,newDirName,'\','pdfVersions\',fnSaveFig], myStyle);
    end
    
end

