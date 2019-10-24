
% This script performs paired sample ttests between mean trajectories from
% two experimental conditions that were administered to a group of
% participants. It returns p-values and hypothesis tests for each time step
% and allows to plot a visual representation directly into existing
% trajectory plots (significance marker for p-level of useAlpha as well as
% color-coded p-values across the entire movement time; click into the target
% axis before running the script). 
%
% The input must consist of pairs of mean trajectories from multiple 
% participants. The struct a.byPts.(...) obtained from the analysis script
% holds the data in the required format (i.e., independent variables
% correspond to different array dimensions and the highest array dimension
% corresponds to different participants).
%
% --- WHICH DATA from a.byPts exactly is tested is specified by:
%
% interpType = which type of interpolation (warped or aligned, wrp/alg);
% measure = which measure, e.g. position (pos) or velocity (vel);
%
% These settings determine from which sub-field of the struct
% a.byPts data is used in the comparisons.
% 
% --- WHICH TWO CONDITIONS are compared by the ttests is specified by
% addressing into the cell array within the chosen subfield of a.byPts.
% The two cells of the array that should be compared are addressed via
% subscript indices set in the row vectors cell_1_subs and cell_2_subs.
% Note that when setting the subscript indices, the last dimension of the
% cell array in a.ByPts.(...) can be ignored because the participant dimension
% (last one) will be collapsed before the subscripts are applied (i.e.,
% write the subscript indices as if that dimension did not exist),
% cell_1_subs and cell_2_subs take three coordinates -- if the array
% has less than three dimensions (not counting the pts-dim), pad them with 1.
%
% --- Finally, WHICH DATA COLUMNS provide the data that is to be compared
% is specified by x1Col AND x2Col, which are simply the column number for
% condition 1 and condition 2 data. E.g., to do t-tests for x-position use
% x1Col = a.s.trajCols.x and x2Col = a.s.trajCols.x
%
% 
% Optionally, data for performing bootstrapping can be stored in a format
% which can be loaded directly by bootstrapping_pairedSample.m (saveBootstrapInput = 1)
%
% Note: Cohen's d (ABSOLUTE (!!!) and for paired samples*; variable d) is also
% computed for each timestep
% effect size: Cohen's d for paired samples; aka d_z
% *(mean difference score divided by standard deviation of difference scores,
% see Daniel Lakens, 2013, p.4)

% --- Input data:

% Which array to use as data source (a.byPts.trj.(interpType).(measure).avg)
interpType = 'wrp'; % wrp, alg
measure = 'pos'; % vel, acc, spd

% Cells in source array providing data that should be compared against each other
cell_1_subs = [1 1 1];
cell_2_subs = [1 1 1];

% Column of interest
x1Col = 1;
x2Col = 1;

% --- Miscellaneous

% Describe test (for saving bootstrap data)
testDescription = 'bla';

% alpha level for individual tests
useAlpha = 0.01;

% plot results to current axes (select appropriate axes by clicking into it
% before running this script)?
doFigureStuff = 1;
% proportion of axes width taekn up by significance color bar and effect
% size color bar (each; p-bar is placed left, d-bar is placed right)
barWidthProp = 0.05;
% significance marker distance from left axes border as proportion of axes
% width
sigMarkerPlacementProp = 0.1;
sigMarkerSize = 5;


%% --- PREPARATIONS

ref_dat = a.byPts.trj.wrp.ang.ref.avg;
dtr_dat = a.byPts.trj.wrp.ang.dtr.avg;

% participants are always expected along last dimension of array
ptsDim = ndims(ref_dat); % pts dim should always highest one
    
% Collapse along participant dimension, aggregating trajectories from the
% different participants in each cell (for paired sample tests)
testWhat1 = ref_dat; 
testWhat1 = cellCollapse(cellfun(@(tw) {tw} ,testWhat1,'uniformoutput',0),ptsDim,1);
testWhat2 = dtr_dat; 
testWhat2 = cellCollapse(cellfun(@(tw) {tw} ,testWhat2,'uniformoutput',0),ptsDim,1);

% adjust indexing into elements of testWhat trajectories from which data
% should be compared (remember that dimensionality of testWhat and assignemnt
% of dimensions of testWhat to independent variables and their levels is
% dependent on number of IVs and levels, which can be looked up in cell
% array a.s.ivs from analysis)
cell_1_lndx = sub2ind(size(testWhat1),cell_1_subs(1),cell_1_subs(2),cell_1_subs(3));
cell_2_lndx = sub2ind(size(testWhat2),cell_2_subs(1),cell_2_subs(2),cell_2_subs(3));
tr_x1 = cell2mat(cellCollapseAndTrim(testWhat1{cell_1_lndx},1,3));
tr_x2 = cell2mat(cellCollapseAndTrim(testWhat2{cell_2_lndx},1,3));

%%--- RUN TEST

minLen = min(size(tr_x1,1),size(tr_x2,1));

[h, p, d] = deal([]);

% two-sample ttests comparing x values for each time step
for curTimestep = 1:minLen
    
    x1 = squeeze(tr_x1(curTimestep,x1Col,:));
    x2 = squeeze(tr_x2(curTimestep,x2Col,:));
    %x2 = zeros(12,0)
    
    
    % paired sample ttest (two-tailed)
    [h(curTimestep), p(curTimestep), ~, stats] = ttest(x1,x2,'alpha',useAlpha);
    
    % effect size: Cohen's d for paired samples; aka d_z
    % (mean difference score divided by standard deviation of difference scores,
    % see Daniel Lakens, 2013, p.4)
    d(curTimestep) = abs(mean(x1-x2)/std(x1-x2));
            
end


% find longest sequence of significant data points
% (its length can be comapred to bootstrapping results regarding required
% number of significant poitns)
counter = 0;
longestSeq = 0;
currentStartStep = [];
startStep  = [];
endStep = [];
for i = 1:numel(h)   
    if h(i) == 1
        counter = counter+1;
        if counter == 1
            currentStartStep = i;        
        end
    end    
    if h(i) ~= 1 || i == numel(h)
        if counter > longestSeq
            longestSeq = counter;
            startStep = currentStartStep;
        end
        counter = 0;
    end    
end
endStep = startStep + longestSeq - 1;

disp(['max n of successive sig. (each p<', num2str(useAlpha),'): ' num2str(longestSeq)]);

%% Visualization

if doFigureStuff
    
    curLineAx = gca; %currently active axes into/over which stuff should be plotted
    curAxID = round(rand*1000000000); % unique ID
    curLineAx.UserData = curAxID; % add ID to axes so that associated axes (below) can later be identified
    
    hold on
    
    % --- Plot significance indicators to currently selected axes
    
    % delete preexisting sig./effect size indicators and associated axes          
    % effect size axes (image)
    existingEsAxes = findobj(gcf,'tag','esAx');
    effAxPosesTmp = get(existingEsAxes,'position');
    if isa(effAxPosesTmp,'double') && isequal(curLineAx.Position, effAxPosesTmp)
        delete(existingEsAxes);
    elseif ~isempty(effAxPosesTmp) && isequal(curLineAx.Position, effAxPosesTmp)
        delete(existingEsAxes(cellfun(@(esp) all(curLineAx.Position==esp),effAxPosesTmp)))
    end
    % p-value-image axes (dots and image)
    existingSigAxes = findobj(gcf,'tag','sigAx');
    sigAxPosesTmp = get(existingSigAxes,'position');
    if isa(sigAxPosesTmp,'double') && isequal(curLineAx.Position, sigAxPosesTmp)
        delete(existingSigAxes);
    elseif ~isempty(sigAxPosesTmp) && isequal(curLineAx.Position, sigAxPosesTmp)
        delete(existingSigAxes(cellfun(@(esp) all(curLineAx.Position==esp),sigAxPosesTmp)))
    end
               
    % p-value axes/image/dots---------------------------------------------
    % overlay new axes to place imagemap in    
    sigAx = axes('position',get(curLineAx,'position'));                            
    sigAx.XLim = curLineAx.XLim;    
    barWidth = diff(sigAx.XLim)*barWidthProp; % width in x-axes units
    yDatTmp = get(findobj(curLineAx,'tag','dataLine'),'YData');
    if iscell(yDatTmp)
        yDatTmp = cell2mat(yDatTmp);
    end
    ymin = min(min(yDatTmp)); % y extent    
    ymax = max(max(yDatTmp)); % y extent  
    hSigImg = image([sigAx.XLim(1), sigAx.XLim(1)+barWidth],[ymin ymax],p');    
    hSigImg.Tag = 'sigImg';  
    set(hSigImg,'alphadata',~isnan(p')) % make transparent where p has nans
    colormap(sigAx,flipud(parula));
    hSigImg.CDataMapping = 'scaled';
    set(sigAx,'Clim',[0 0.1],'ydir','normal');           
    sigAx.XLim = curLineAx.XLim;    
    sigAx.Tag = 'sigAx';
    sigAx.Visible = 'off';    
    sigAx.UserData = curAxID;
    % associated colorbar
    delete(findobj(gcf,'type','colorbar'))
    cbarw=.02;cbarh=.2; cbarx=.01;cbary=.01; % colorbar position in figure
    colorbar('position',[cbarx cbary cbarw cbarh],'ticks',[0 .01 .05 0.1],'fontsize',5, 'YAxisLocation','right');                             
    %---
    
    % Add significance markers
    hold(sigAx,'on');
    for i = 1:numel(h)
        if ~isnan(h(i)) && h(i)
            switch interpType
                case  'wrp'
                    yValueForSigMarkers = i;
                case 'alg'
                    yValueForSigMarkers = (i-1)*a.s.samplingPeriodForInterp;
                otherwise
                    yValueForSigMarkers = [];
            end
            hSigMarkers = plot(sigAx.XLim(1)+sigMarkerPlacementProp*diff(sigAx.XLim),yValueForSigMarkers,'marker','.','color','k', 'MarkerSize',sigMarkerSize); % for warped trajs
            set(hSigMarkers,'tag','sigDot');
            set(get(get(hSigMarkers,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');            
        end
    end
    hold(sigAx,'off');
    %---------------------------------------------------------------------
    
    
    % d axes/image -------------------------------------------------------
    % overlay new axes with separate color map to place imagemap in    
    esAx = axes('position',get(curLineAx,'position'));                            
    esAx.XLim = curLineAx.XLim;    
    barWidth = diff(esAx.XLim)*barWidthProp; % width in x-axes units
    yDatTmp = get(findobj(curLineAx,'tag','dataLine'),'YData');
    if iscell(yDatTmp)
        yDatTmp = cell2mat(yDatTmp);
    end
    ymin = min(min(yDatTmp)); % y extent    
    ymax = max(max(yDatTmp)); % y extent    
    hEsImg = image([esAx.XLim(2)-barWidth, esAx.XLim(2)],[ymin ymax],d');    
    hEsImg.Tag = 'esImg';  
    set(hEsImg,'alphadata',~isnan(d')) % make transparent where d has nans and where nonsig.
    colormap(esAx,hot);
    hEsImg.CDataMapping = 'scaled';
    set(esAx,'Clim',[0 4],'ydir','normal');           
    esAx.XLim = curLineAx.XLim;    
    esAx.Tag = 'esAx';
    esAx.Visible = 'off';    
    esAx.UserData = curAxID;
    % associated colorbar    
    cbarw=.02;cbarh=.2; cbarx=.01;cbary= 1-cbarh-.01; % colorbar position in figure
    colorbar('position',[cbarx cbary cbarw cbarh],'ticks',0:4,'fontsize',5, 'YAxisLocation','right');                  
    %---------------------------------------------------------------------          
    
    linkaxes([curLineAx,esAx],'y');                  
    linkaxes([curLineAx,sigAx],'y');  
    
    uistack(esAx,'top');
    uistack(sigAx,'top');
    axes(curLineAx);
    curLineAx.Color = 'none';
    
    text(0.1,0.1,[num2str(longestSeq),' steps', ' (', num2str(round(startStep/numel(h)*100,2)), ' to ', num2str(round(endStep/numel(h)*100,2)), ' \%)']  ,'units','normalized')
    
end







