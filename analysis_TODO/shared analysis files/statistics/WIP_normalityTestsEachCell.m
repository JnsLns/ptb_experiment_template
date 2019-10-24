
% IMPORTANT
%
%
%
%
%
%
% THIS IS HIGHLY WIP/TESTING AND MAY VERY WELL BE COMPLETELY INCORRECT!!!
%
%
%
%
%
%
%


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
cell_1_subs = [1 4 1];

% Column of interest
x1Col = a.s.trajCols.x;
x2Col = x1Col;

% --- Miscellaneous

% Describe test (for saving bootstrap data)
testDescription = 'exp7_onlyDtr_RvsL';

% Extract and save compared data for later input to boostrap script?
saveBootstrapInput = 0;

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

% participants are always expected along last dimension of array
ptsDim = ndims(a.byPts.trj.(interpType).(measure).avg); % pts dim should always highest one
    
% Collapse along participant dimension, aggregating trajectories from the
% different participants in each cell (for paired sample tests)
testWhat = a.byPts.trj.(interpType).(measure).avg; 
testWhat = cellCollapse(cellfun(@(tw) {tw} ,testWhat,'uniformoutput',0),ptsDim,1);

% adjust indexing into elements of testWhat trajectories from which data
% should be compared (remember that dimensionality of testWhat and assignemnt
% of dimensions of testWhat to independent variables and their levels is
% dependent on number of IVs and levels, which can be looked up in cell
% array a.s.ivs from analysis)
cell_1_lndx = sub2ind(size(testWhat),cell_1_subs(1),cell_1_subs(2),cell_1_subs(3));
tr_x1 = cell2mat(cellCollapseAndTrim(testWhat{cell_1_lndx},1,3));


[h, p, d, isNonNormal_ks, isNonNormal_lf, isNonNormal_sw] = deal([]);
minLen = min(size(tr_x1,1));

% two-sample ttests comparing x values for each time step
for curTimestep = 1:minLen
    
    x1 = squeeze(tr_x1(curTimestep,x1Col,:));        
    
    %Use residuals?
    x1 = x1-mean(x1);
    
    try
        % use z-standardization since kstests tests for standard normal distribution
        normalityAlpha = 0.05;
        isNonNormal_ks(curTimestep) = kstest((x1-mean(x1))/std(x1),'alpha',normalityAlpha); % 0 if normal, 1 if nonnormal
        isNonNormal_lf(curTimestep) = lillietest((x1),'alpha',normalityAlpha); % 0 if normal, 1 if nonnormal
        isNonNormal_sw(curTimestep) = swtest((x1),normalityAlpha); % 0 if normal, 1 if nonnormal
    catch
        disp('error')
    end
                    
end

disp(['non-normal steps (p<', num2str(normalityAlpha),'): ',num2str(sum(isNonNormal_ks)), ' (kstest) ', num2str(sum(isNonNormal_lf)), ' (lilliefors) ',num2str(sum(isNonNormal_sw)), ' (swtest) '  ]);

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
               
 
    sigAx = axes('position',get(curLineAx,'position'));                            
    sigAx.XLim = curLineAx.XLim;                
    sigAx.XLim = curLineAx.XLim;    
    sigAx.Tag = 'sigAx';
    sigAx.Visible = 'off';    
    sigAx.UserData = curAxID;           
    
    % Add non-normality markers
    nnMarkerPlacementProp   = sigMarkerPlacementProp + sigMarkerPlacementProp*0.5;
    hold(sigAx,'on');
    for i = 1:numel(isNonNormal_ks)
        % Kolmogorov
        if ~isnan(isNonNormal_ks(i)) && isNonNormal_ks(i)
            switch interpType
                case  'wrp'
                    yValueForSigMarkers = i;
                case 'alg'
                    yValueForSigMarkers = (i-1)*a.s.samplingPeriodForInterp;
                otherwise
                    yValueForSigMarkers = [];
            end
            hNNMarkers_ks = plot(sigAx.XLim(1)+nnMarkerPlacementProp*diff(sigAx.XLim),yValueForSigMarkers,'marker','.','color','r', 'MarkerSize',sigMarkerSize); % for warped trajs
            set(hNNMarkers_ks,'tag','nnksDot');
            set(get(get(hNNMarkers_ks,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');            
        end
        % lilliefors
        nnMarkerPlacementProp   = sigMarkerPlacementProp + sigMarkerPlacementProp*1;
        if ~isnan(isNonNormal_lf(i)) && isNonNormal_lf(i)
            switch interpType
                case  'wrp'
                    yValueForSigMarkers = i;
                case 'alg'
                    yValueForSigMarkers = (i-1)*a.s.samplingPeriodForInterp;
                otherwise
                    yValueForSigMarkers = [];
            end
            hNNMarkers_lf = plot(sigAx.XLim(1)+nnMarkerPlacementProp*diff(sigAx.XLim),yValueForSigMarkers,'marker','.','color','g', 'MarkerSize',sigMarkerSize); % for warped trajs
            set(hNNMarkers_lf,'tag','nnlfDot');
            set(get(get(hNNMarkers_lf,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');            
        end
        % Shapiro Wilks
        nnMarkerPlacementProp   = sigMarkerPlacementProp + sigMarkerPlacementProp*1.5;
        if ~isnan(isNonNormal_sw(i)) && isNonNormal_sw(i)
            switch interpType
                case  'wrp'
                    yValueForSigMarkers = i;
                case 'alg'
                    yValueForSigMarkers = (i-1)*a.s.samplingPeriodForInterp;
                otherwise
                    yValueForSigMarkers = [];
            end
            hNNMarkers_sw = plot(sigAx.XLim(1)+nnMarkerPlacementProp*diff(sigAx.XLim),yValueForSigMarkers,'marker','.','color','b', 'MarkerSize',sigMarkerSize); % for warped trajs
            set(hNNMarkers_sw,'tag','nnswDot');
            set(get(get(hNNMarkers_sw,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');            
        end
    end
    hold(sigAx,'off');
    %---------------------------------------------------------------------
    
         
    linkaxes([curLineAx,sigAx],'y');  
        
    uistack(sigAx,'top');
    axes(curLineAx);
    curLineAx.Color = 'none';        
    
end







