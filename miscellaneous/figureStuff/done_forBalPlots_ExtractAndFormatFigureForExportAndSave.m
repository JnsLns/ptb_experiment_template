
% This is the version for balancing plots (i.e., bar group plots)
%
% This "extracts" an axes from a figure and casts it into a standardized
% format for publishing. The new figure is saved to the same path as the one
% from whcih the source figure was loaded, with an extended file name based
% on the file name of the source figure and the title of the axes.
% This is done for all axes holding bar objects currently present in open figures.
%
% In other words: open all figures the axes of which are needed as separate
% images and run this script.


% Settings for new axes
newYLims = [0 .45];
XTickVals = [2]; % determines position of x mid grid line
YTickVals_grid = [.1 .2 .3]; %determines position of y grid lines
YTickVals_tickMarks = [.1 .2 .3 .4];

newXLims = [0 4]; % it seems bar groups are placed on alteranting whole numbers (depends on width maybe?)
barGroupCenters = [1 3];
barWidth = 0.8;

%sigImgPropAx = 0.05; % width of significance (& effect size) map relative to axes width
%sigDotsPropAx = 0.15; % placement of sig dots from left axes border, relative to axes width
%sigDotSz = 2; % size of significance dots
%sigMarkerType = '.';
%axSz = [220 600]; % for each axes
figSize = [2 2]; % centimeters; note: figure is somewhat wider than specified here for some reason
%xLbl = 'Dev. from Direct Path [mm]'; % these replace existing axes labels (code may be adjusted to use existing ones)
%yLbl = '% Total Movement Time';
xLbl = ''; % these replace existing axes labels (code may be adjusted to use existing ones)
yLbl = '';
disableXTickLabels = true;
disableYTickLabels = true;
newDirName = 'cleanSingleAxes'; %new dir in figure's directory where extracted figure is  saved
useFontSize = 10;
labelFontSizeMulti = 1.2; % size of axes lables relative to useFontSize    
axBgColor = [.915 .915 .915];  % axes backgroudn color
patchAlpha = 0.135;
overallLineColor = [.5 .5 .5]; % settings for average line
overallLineStyle = ':';
overallLineWidth = 1.25;
dataLinesWidth = 1.25; % width of data lines
gridLineWidth = 1; % thickness of grid lines (also determines tick width)
gridAlpha = 0.8;
outlineLineWidth = 2;
tickLength = [0.04 0.035];
%barFaceColor = [.4 .4 .4]; % if used respective code needs to be uncommented
barEdgeColor = 'none';

% use this instead if there' only one bar group
% numBars = 8;
% newXLims = [0 2]; % it seems bar groups are placed on alteranting whole numbers (depends on width maybe?)
% barGroupCenters = linspace(0+2/numBars,2-2/numBars,numBars);

%% Formatting

% Running this section will export all open axes to separate files

% only bar figures may be open!
hAllBarAxes = findobj(0,'type','axes','-not','tag','suptitle');
hAllFigs = findobj(0,'type','figure'); % use this to close source figures afterwards

for curAx = 1:numel(hAllBarAxes)
    
    % get current source
    hSourceAx = hAllBarAxes(curAx);
    hSourceFig = get(hSourceAx,'parent');
    
    
    % store handles, titles, suptitle and legend info of source axe    
    fullFnSourceFig = get(hSourceFig,'filename');
    supTitleString = get(get(findobj(hSourceFig,'tag','suptitle'),'title'),'string');
    titleString = hSourceAx.Title.String;
    if ~isempty(supTitleString); sep = '_'; else sep = ''; end;
    addToName = [supTitleString,sep,titleString];
    if ~isempty(addToName); addToName = ['_' addToName]; end
    
    % Save legend info
    hLegSource = get(hSourceAx,'Legend');
    
    % Make new figure and axes    
    newFig = figure('color','w');
    set(newFig, 'Units', 'Centimeters', 'Position', [0 0 figSize], 'PaperUnits', 'Centimeters', 'PaperSize', figSize)    
    newAx = axes;
    
    % copy relevant children of source axes to new axes
    copyobj(get(hSourceAx,'children'),newAx)
    
    % copy relevant properties from source to new axes
    newAx.CLim = hSourceAx.CLim;
    newAx.YLim = hSourceAx.YLim;
    newAx.YTick = [];
    newAx.XTick = [];
    newAx.YTickLabel = hSourceAx.YTickLabel;
    newAx.YLabel.String = yLbl;
    newAx.XLabel.String = xLbl;
    newAx.Color = 'none';
    if disableXTickLabels; newAx.XTickLabels = []; end;
    if disableYTickLabels; newAx.YTickLabels = []; end;
    newAx.Box = 'off';       
    
    % set other axes settings
    newAx.XGrid = 'off';
    newAx.YGrid = 'off';
    newAx.GridColor = 'none';    
     
    % bar placement % color
    set(allchild(newAx),'edgeColor',barEdgeColor)
    %set(allchild(newAx),'faceColor',barFaceColor)
    set(findobj('type','bar'),'XData',barGroupCenters,'BarWidth',barWidth)
    
    
    % copy associated axes completely (everything but their data should be invisible)
    %copyobj(hAssocAxes,newFig)
    %newAssocAxes = findobj(newFig,'type','axes','-not','tag','lineAx');
    %set(newAssocAxes,'position',newAx.Position)
    
    % re-place data in associated axes based on prospective new xlims for lineAx
%     if ~isempty(hAssocAxes)
%         wdhImg = abs(diff(newXLims))*sigImgPropAx; % relative to axes width
%         sigImgTMP = findobj(gcf,'tag','sigImg');
%         sigImgTMP.XData = [newXLims(1),newXLims(1)+wdhImg];
%         sigDotsTMP = findobj(gcf,'tag','sigDot');
%         esImgTMP = findobj(gcf,'tag','esImg');
%         esImgTMP.XData = [newXLims(2)-wdhImg,newXLims(2)];
%         for i = 1:numel(sigDotsTMP)
%             sigDotsTMP(i).XData = newXLims(1)+sigDotsPropAx*diff(newXLims);
%         end
%     end
    
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
    
    % Axes for white Grid
    whiteGridAx = copyobj(newAx,newFig);
    delete(whiteGridAx.Children) % delete all data from white axis        
    whiteGridAx.Color = axBgColor;
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
    whiteGridAx.YTick = YTickVals_grid;           
    
    uistack(newAx,'top');
    
    % Axes for line and error data; move data (also: delete that data from newAx)
    % (also holds patches and sigDots)
%     dataLineAx = copyobj(whiteGridAx,newFig);
%     dataLineAx.Visible = 'off';        
%     patches = findobj(newAx,'type','patch');
%     set(patches,'FaceAlpha',patchAlpha);
%     copyobj(patches,dataLineAx);
%     delete(patches)    
%     overallLine = findobj(newAx,'tag','overallLine');
%     newOverallLine = copyobj(overallLine,dataLineAx);            
%     delete(overallLine);    
%     newOverallLine.Color = overallLineColor;
%     newOverallLine.LineStyle = overallLineStyle;
%     newOverallLine.LineWidth = overallLineWidth;
%     dataLines = findobj(newAx,'tag','dataLine');
%     newDataLines = copyobj(dataLines,dataLineAx);
%     delete(dataLines);
%     set(newDataLines,'LineWidth',dataLinesWidth);    
%     sigDots = findobj(newFig,'tag','sigDot');
%     newSigDots = copyobj(sigDots,dataLineAx);
%     delete(sigDots);
%     set(newSigDots,'markerSize',sigDotSz,'marker',sigMarkerType);
    
    % Axes for black tick marks
    tickAx = copyobj(newAx,newFig);    
    delete(tickAx.Children) % delete all data  
    tickAx.Tag = 'tickAx';
    tickAx.Color = 'none'; tickAx.XGrid = 'off'; tickAx.YGrid = 'off';
    tickAx.XAxis.Color = 'k'; tickAx.YAxis.Color = 'k';
    tickAx.XAxis.TickLabel = []; tickAx.XAxis.Label = [];
    tickAx.YAxis.TickLabel = []; tickAx.YAxis.Label = [];    
    tickAx.LineWidth = whiteGridAx.LineWidth;       
    tickAx.YTick = YTickVals_tickMarks;
    tickAx.XTick = [];   
    tickAx.TickLength = tickLength;
    
    % Axes for white outline    
    whiteBoxAx = copyobj(whiteGridAx,newFig);
    whiteBoxAx.Color = 'none';
    whiteBoxAx.XGrid = 'off';  whiteBoxAx.YGrid = 'off';
    whiteBoxAx.Box = 'on';
    whiteBoxAx.LineWidth = outlineLineWidth;   
    
    % set same YLim for all axes
    set(findobj(newFig,'type','axes'),'YLim',newYLims);
    
    % set all axes to fit figure size
    set( findobj(gcf,'type','axes'), 'Units', 'normalized', 'Position', [0 0 1 1] );     
    
    % save fig-file with extended file name (based on suptitle and axes title
    fullFnSourceFig(strfind(fullFnSourceFig,'.fig'):end) = [];
    addToName(strfind(addToName,'"')) = [];
    addToName(strfind(addToName,'/')) = '_';
    pathSourceFig = fullFnSourceFig;
    pathSourceFig(max(strfind(pathSourceFig,'\'))+1:end) = [];
    fnSourceFig = fullFnSourceFig;
    fnSourceFig = fnSourceFig(max(strfind(fnSourceFig,'\'))+1:end);
    mkdir(pathSourceFig,newDirName);
    try
        savefig([pathSourceFig,newDirName,'\',fnSourceFig,addToName,'.fig']);
    catch
        disp('ahhh!')
    end                
        
    % save pdf-file
    mkdir([pathSourceFig,newDirName,'\'],'pdfVersions');    
    
    myStyle = hgexport('factorystyle');
    myStyle.Format = 'pdf';
    myStyle.Width = figSize(1);
    myStyle.Height = figSize(2);
    myStyle.Resolution = 300;
    myStyle.Units = 'centimeters';
    %myStyle.FixedFontSize = 12;   
    
    hgexport(newFig, [pathSourceFig,newDirName,'\','pdfVersions\',fnSourceFig,addToName], myStyle);     
    
end

