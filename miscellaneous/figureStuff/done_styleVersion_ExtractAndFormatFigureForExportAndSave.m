
% This is the version for trajectory plots (plus significance & effect size
% image maps) and this version also completely changes figure appearance
% (background color etc. pp), adding a number of overlayed axes for
% cosmetic reasons (there is a more basic version).
%
% This "extracts" an axes from a figure and casts it into a standardized
% format for publishing. The new figure is saved to the same path as the one
% from whcih the source figure was loaded, with an extended file name based
% on the file name of the source figure and the title of the axes.
% This is done for all axes holding objects with tag "dataLine" that are
% currently present in open figures.
%
% In other words: open all figures the axes of which are needed as separate
% images and run this script.

% note: this script also saves a version of each figure to pdf, but the result
% is suboptimal (the patches are exported as small fragments; the colorbars
% are strangely light... can be remedied by selecteing effects>lense>assign
% in corel draw while having the bitmap selected).

% note2: if using this for figures where lines are not tagged 'dataLine'
% first use this:
% set(findobj(gcf,'type','line'),'tag','dataLine')

doSaveFig = 1; % save figure file of modified (stylized) figure?
doExportPdf = 1; % save pdf version of modified (stylized) figure?

% Settings for new axes
newXLims = [-15 15]; % (A) for R vs L; for figSize for three plots in a row in portrait (ensures constant ratio x-units/figWidth)
%newXLims = [-12 12]; % (B) for R vs L; for figSize for four plots in a row in portrait (ensures constant ratio x-units/figWidth)
%newXLims = [-8.5 8.5]; % (C) for R minus L; for figSize for four plots in a row in portrait (ensures constant ratio x-units/figWidth)
%newXLims = [-10 10]; % (D) for R minus L; for figSize for three plots in a row in portrait (ensures constant ratio x-units/figWidth)
newYLims = [1 151.1]; % for all plots against percentual movement time
XTickVals = [-10 -5 0 5 10];

%newXLims = [-85 85]; % For trajectory plots over space
%newYLims = [-20 270]; % For trajectory plots over space
%XTickVals = -100:50:100; % For trajectory plots over space
%YTickVals = 0:50:270; % can be left empty [] to use ticks from source axis;
%YTickVals = 0:151/10:151;
YTickVals = [];

sigImgPropAx = 0.05; % width of significance (& effect size) map relative to axes width
sigDotsPropAx = 0.15; % placement of sig dots from left axes border, relative to axes width
sigDotSz = 5; % size of significance dots
sigMarkerType = '.';

% centimeters; note: figure is somewhat wider than specified here for some reason
figSize = [4 7.4]; % (A) for R vs L; for three plots in a row in portrait
%figSize = [3.2 7.4]; % (B) for R vs L; for four plots in a row in portrait
%figSize = [3.2 7.4]; % (C) for R minus L; for four plots in a row in portrait
%figSize = [4 7.4]; % (D) for R minus L; for three plots in a row in portrait
% fw = 3.4*0.85; figSize = [fw fw*(newYLims(2)-newYLims(1))/(newXLims(2)-newXLims(1))]; % for plots over space with 1:1 axes ratio


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
dataLinesWidth = 1.5; % width of data lines for diss mean traj plots
%dataLinesWidth = 0.2; % width of data lines for diss individual traj plots
gridLineWidth = 1; % thickness of grid lines (also determines tick width)
gridAlpha = 0.8;
outlineLineWidth = 2;
tickLength = [0.025 0.035];

removeAllText = 1;

%% Formatting

% Running this section will export all open axes to separate files

hAllLineAxes = findobj(0,'tag','lineAx');
hAllFigs = findobj(0,'type','figure'); % use this to close source figures afterwards

for curAx = 1:numel(hAllLineAxes)
    
    % get current source
    hSourceAx = hAllLineAxes(curAx);
    hSourceFig = get(hSourceAx,'parent');
    
    % Use unique IDs assigned in t-test script to identify associated/overlayed
    % axes (significance & effect size); these axes are copied to a new figure
    % as well but are expected to be invisible and have no legend etc.
    if ~isempty(hSourceAx.UserData)
        hAssocAxes = findobj(0,'userdata',hSourceAx.UserData,'-not','tag','lineAx');
    else
        hAssocAxes = [];
    end
    
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
        
    % copy associated axes completely (everything but their data should be invisible)
    copyobj(hAssocAxes,newFig)
    newAssocAxes = findobj(newFig,'type','axes','-not','tag','lineAx');
    set(newAssocAxes,'position',newAx.Position)
    
    % re-place data in associated axes based on prospective new xlims for lineAx
    if ~isempty(hAssocAxes)
        wdhImg = abs(diff(newXLims))*sigImgPropAx; % relative to axes width
        sigImgTMP = findobj(gcf,'tag','sigImg');                
        sigImgTMP = sigImgTMP(1);            
        sigImgTMP.XData = [newXLims(1),newXLims(1)+wdhImg];
        sigDotsTMP = findobj(gcf,'tag','sigDot');
        esImgTMP = findobj(gcf,'tag','esImg');
        esImgTMP = esImgTMP(1); 
        esImgTMP.XData = [newXLims(2)-wdhImg,newXLims(2)];
        for i = 1:numel(sigDotsTMP)
            sigDotsTMP(i).XData = newXLims(1)+sigDotsPropAx*diff(newXLims);
        end
    end
    
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
    if ~isempty(YTickVals)
        newAx.YTick = [];       
    end
    
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
    
    % Axes for line and error data; move data (also: delete that data from newAx)
    % (also holds patches and sigDots)
    dataLineAx = copyobj(whiteGridAx,newFig);
    dataLineAx.Tag = 'dataLineAx';
    dataLineAx.Visible = 'off';            
    dataLineAx.GridLineStyle = 'none';  
    patches = findobj(newAx,'type','patch');            
    for curPatch = patches'
        set(curPatch,'Edgecolor',(curPatch.FaceColor*patchEdgeDarken),'facealpha',patchAlpha,'EDGEalpha',patchEdgeAlpha,'linestyle',patchEdgeStyle)        
    end            
    copyobj(patches,dataLineAx);
    delete(patches)    
    overallLine = findobj(newAx,'tag','overallLine');
    newOverallLine = copyobj(overallLine,dataLineAx);            
    delete(overallLine);    
    newOverallLine.Color = overallLineColor;
    newOverallLine.LineStyle = overallLineStyle;
    newOverallLine.LineWidth = overallLineWidth;
    dataLines = findobj(newAx,'tag','dataLine');
    copyobj(findobj(findobj(newFig,'tag','bgColorAx'),'type','line'),dataLineAx);    
    delete(findobj(findobj(newFig,'tag','bgColorAx'),'type','line')); % delete lines from bg color axes
    set(findobj(dataLineAx,'tag','dataLine'),'LineWidth',dataLinesWidth);    
    sigDots = findobj(newFig,'tag','sigDot');
    newSigDots = copyobj(sigDots,dataLineAx);
    delete(sigDots);
    set(newSigDots,'markerSize',sigDotSz,'marker',sigMarkerType);
    
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
    
    % set all axes to fit figure size
    set( findobj(gcf,'type','axes'), 'Units', 'normalized', 'Position', [0 0 1 1] );
    
    if removeAllText
        delete(findobj(gcf,'type','text'));
    end
        
    % Legend
    doLegend = 0;
    if doLegend
        dataLineAxLeg = legend(dataLineAx,'show');
        dataLineAxLeg.Color = axBgColor ;
        dataLineAxLeg.EdgeColor = axBgColor;
        % Move legend outside of current axes, top right border, flush with right side of axes
        legVertDistToFig = 0.01;
        axPos = get(dataLineAx,'position');
        axTopRightCorner(1) = axPos(1)+axPos(3);  axTopRightCorner(2) = axPos(2)+axPos(4);
        hLegend = get(dataLineAx,'Legend');
        legPos = get(hLegend,'position');
        legLeftBorder = axTopRightCorner(1) -  legPos(3); legBottomBorder = axTopRightCorner(2) + legVertDistToFig;
        set(hLegend,'position',[legLeftBorder,legBottomBorder,legPos([3 4])]);
    end           
           
    % Adjust order of elements 
    % At this point (before adjusting), the order of axes in the new figure is
    % 1 = white border (to overlay black border)
    % 2 = black tick marks (with black border)
    % 3 = data lines, patches, and significance dots
    % 4 = grid
    % 5 = p-values image map
    % 6 = effect size image map
    % 7 = gray background
    if ~isempty(findobj(newFig,'tag','sigImg'))
        newFig.Children = newFig.Children([1 2 5 6 3 4 7]);
    else
        newFig.Children = newFig.Children([3 1 2 4 5]);
    end
    
    if doSaveFig || doExportPdf
        pathSourceFig = fullFnSourceFig;
        pathSourceFig(max(strfind(pathSourceFig,'\'))+1:end) = [];
        mkdir(pathSourceFig,newDirName);
        fnSourceFig = fullFnSourceFig;
        fnSourceFig = fnSourceFig(max(strfind(fnSourceFig,'\'))+1:end);        
        addToName(strfind(addToName,'"')) = [];
        addToName(strfind(addToName,'/')) = '_';
        fnSaveFig = [fnSourceFig(1:end-4),addToName];
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

