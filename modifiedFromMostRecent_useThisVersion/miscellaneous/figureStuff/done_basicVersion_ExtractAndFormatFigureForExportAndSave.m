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

% TODO NOTE: Font size changes in pdf exports so that legend is moved
% around...

% TODO NOTE: Incorporate conversion to LM Roman 12 here... also, switch box
% on, and standardize text (e.g., make black). see older script for that...

% at some point also deal with the patches correctly (from old script and
% then by hand probably).

% note: if the legend is not flush right in the (pdf) figure, this might be
% simply because the legend is too wide relative to the size of the axes.
% adjust figPaperHeight in this case 

% Settings for new axes
newXLims = [-10 10];
sigImgPropAx = 0.03; % width of significance (& effect size) map relative to axes width
sigDotsPropAx = 0.11; % placement of sig dots from left axes border, relative to axes width
sigDotSz = 4; % size of significance dots
axSz = [220 600]; % for each axes
figSz = [724   264   323   714];
xLbl = 'Dev. from Direct Path [mm]'; % these replace existing axes labels (code may be adjusted to use existing ones)
yLbl = '% Total Movement Time';
newDirName = 'cleanSingleAxes'; %new dir in figure's directory where extracted figure is  saved
figPaperHeight = 19; % figure height on paper in centimeters
useFontSize = 10;
labelFontSizeMulti = 1.2; % size of axes lables relative to useFontSize

%% Formatting

% Running this section will export all open axes to separate files


hAllLineAxes = findobj(0,'tag','lineAx');
hAllFigs = findobj(0,'type','figure'); % use this to close source figures afterwards

for curAx = 1:numel(hAllLineAxes)                
    
    % get current source
    hSourceAx = hAllLineAxes(curAx);
                 
    % identify associated (i.e., overlayed) axes by ID given by t-test % script    
    % (these are copied as well but are expected to be invisible and have no
    % legend or similar stuff)
    if ~isempty(hSourceAx.UserData)
        hAssocAxes = findobj(0,'userdata',hSourceAx.UserData,'-not','tag','lineAx');
    else
        hAssocAxes = [];
    end
    
    % store handles, titles and suptitle of source axe
    hSourceFig = get(hSourceAx,'parent');
    fullFnSourceFig = get(hSourceFig,'filename');
    supTitleString = get(get(findobj(hSourceFig,'tag','suptitle'),'title'),'string');
    titleString = hSourceAx.Title.String;
    if ~isempty(supTitleString); sep = '_'; else sep = ''; end;
    addToName = [supTitleString,sep,titleString];
    if ~isempty(addToName); addToName = ['_' addToName]; end
    % Save legend info
    %hLegSource = getappdata(hSourceAx,'LegendPeerHandle');  % use this for older matlab versions (2014b)    
    hLegSource = get(hSourceAx,'Legend'); 
    
    % Make new figure and axes
    cmp = colormap;
    newFig = figure('color','w','position',figSz);
    colormap(cmp);
    newAx = axes;
    
    % copy relevant children of source axes to new axes
    copyobj(get(hSourceAx,'children'),newAx)
    
    % copy relevant properties to new axes
    newAx.CLim = hSourceAx.CLim;
    newAx.YLim = hSourceAx.YLim;
    newAx.YTick = hSourceAx.YTick;
    newAx.YTickLabel = hSourceAx.YTickLabel;    
    newAx.YLabel.String = yLbl;    
    newAx.XLabel.String = xLbl;    
    newAx.Color = 'none';
    
    % other axes settings
    newAx.XGrid = 'on';
    newAx.YGrid = 'on';
    newAx.GridAlpha = 0.1500;
    newAx.Box = 'on';
    
    % copy associated axes completely (everything but their data should be invisible)    
    copyobj(hAssocAxes,newFig)            
    newAssocAxes = findobj(gcf,'type','axes','-not','tag','lineAx');
    set(newAssocAxes,'position',newAx.Position)
        
    % re-place data in associated axes based on prosepctive new xlims for lineAx
    if ~isempty(hAssocAxes)
        wdhImg = abs(diff(newXLims))*sigImgPropAx; % relative to axes width
        sigImgTMP = findobj(gcf,'tag','sigImg');
        sigImgTMP.XData = [newXLims(1),newXLims(1)+wdhImg];
        sigDotsTMP = findobj(gcf,'tag','sigDot');
        esImgTMP = findobj(gcf,'tag','esImg');
        esImgTMP.XData = [newXLims(2)-wdhImg,newXLims(2)];
        for i = 1:numel(sigDotsTMP)
            sigDotsTMP(i).XData = newXLims(1)+sigDotsPropAx*diff(newXLims);
        end
    end
    
    % set all axes xlims to same values
    set(findobj(gcf,'type','axes'),'xlim',newXLims);       
    
    % legend
    legend(newAx, hLegSource.String);
    
    % adjustments to figure fonts etc.
    set(gcf,'PaperPositionMode','auto'); % needed to prevent font size from changing on export
    hAllChild = get(gcf,'children');
    set(hAllChild,'FontSize',useFontSize,'linewidth',1)
    set(hAllChild,'FontWeight','default')
    %set(hAllChild,'FontName','LM Roman 12'); % needs this font installed
    set(newAx,'LabelFontSizeMultiplier',labelFontSizeMulti);
    
    % Move legend outside of current axes, top right border, flush with right side of axes
    legVertDistToFig = 0.01;
    axPos = get(newAx,'position');
    axTopRightCorner(1) = axPos(1)+axPos(3);
    axTopRightCorner(2) = axPos(2)+axPos(4);
    %hLegend = getappdata(gca,'LegendPeerHandle'); % use this for older matlab versions (2014b)
    hLegend = get(newAx,'Legend');
    legPos = get(hLegend,'position');
    legLeftBorder = axTopRightCorner(1) -  legPos(3);
    legBottomBorder = axTopRightCorner(2) + legVertDistToFig;
    set(hLegend,'position',[legLeftBorder,legBottomBorder,legPos([3 4])]);
    
    % stack axes 
    uistack(newAssocAxes,'top');    
    axes(newAx);
    
    wip_butWorking_removeAxesBoxGrayBackground;
    
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
    fpTmp = get(gcf,'position');     
    set(gcf, 'PaperUnits', 'centimeters');
    oldpp = get(gcf,'PaperPosition'); 
    set(gcf, 'PaperPosition', [oldpp(1:2),figPaperHeight/(fpTmp(4)/fpTmp(3)),figPaperHeight]);        
    print(gcf, '-dpdf', [pathSourceFig,newDirName,'\','pdfVersions\',fnSourceFig,addToName,'.pdf']);
     
end

