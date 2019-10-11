
% Using matlabs ttest with all the data, not the means and stds...
% for comparison with own computation.
    
% use which trajectories (differ in interpolation: homogeneous time intervals
% versus time-warped to equal number of timesteps)
%testWhat = a.trj.alg.pos.ind; interpType = 'aligned';
%testWhat = a.trj.alg.spd.ind; interpType = 'aligned';
%testWhat = a.trj.alg.vel.ind; interpType = 'aligned';

% testWhat = a.trj.wrp.pos.ind; interpType = 'warped';

testWhat = tmpCell; interpType = 'warped';

%testWhat = a.trj.wrp.spd.ind; interpType = 'warped';
%testWhat = a.trj.wrp.vel.ind; interpType = 'warped';

% Define the two cells within testWhat (each corresponding to one condition)
% from which means will be compared in the ttests. Use subscript indices to
% address into testWhat;
% if testWhat has less than 3 dimensions, insert 1 for unused dimensions.
% (note: code below can be easily adjusted to more dimensions if needed)
cell_1_subs = [1 1 1];
cell_2_subs = [1 2 1];

% Define column of interest for each of the above cells
x1Col = a.s.trajCols.x; x2Col = x1Col;
%x1Col = a.s.trajCols.y; 5x2Col = x1Col;

% alpha level for individual tests
useAlpha = 0.01;

% Add info about dots and significant sequence length to axis title?
augmentAxisTitle = 0;
% If so, add the following info about bootstrap results regarding
% significance 
%bootstrapResultString =  ' ; btstrp: 15 = sig.'; % may be left empty ''
bootstrapResultString = '';

% Place significance marker at what x-value in figure?
xValueForSigMarkers = -20;





%%--- PREPARATIONS

% if row numbers of matrices in testWhat differ (e.g., aligned interpolation
% was used), go through all cells and pad each matrix with nans to the
% length of the overall longest one (overall meaning that even cells are
% incorporated that are not compared below; shouldn't hurt).
cellMaxs = []; padToLenght = [];
for curCell_lndx = 1:numel(testWhat)
    cellMaxs(curCell_lndx) = max(cellfun(@(trs) size(trs,1),testWhat{curCell_lndx}));
end
padToLength = max(cellMaxs);
for curCell_rows = 1:size(testWhat,1)
    for curCell_cols = 1:size(testWhat,2)
        testWhat{curCell_rows,curCell_cols} = cellfun(@(trs) [trs;nan(padToLength-size(trs,1),size(trs,2))] ,testWhat{curCell_rows,curCell_cols},'uniformoutput',0);
    end
end

% adjust indexing into elements of testWhat trajectories from which data
% should be compared (remember that dimensionality of testWhat and assignemnt
% of dimensions of testWhat to independent variables and their levels is
% dependent on number of IVs and levels, which can be looked up in cell
% array a.s.ivs from analysis)
cell_1_lndx = sub2ind(size(testWhat),cell_1_subs(1),cell_1_subs(2),cell_1_subs(3));
cell_2_lndx = sub2ind(size(testWhat),cell_2_subs(1),cell_2_subs(2),cell_2_subs(3));
tr_x1 = cell2mat(cellCollapseAndTrim(testWhat{cell_1_lndx},1,3));
tr_x2 = cell2mat(cellCollapseAndTrim(testWhat{cell_2_lndx},1,3));



%%--- RUN TEST

minLen = min(size(tr_x1,1),size(tr_x2,1));

[h, p] = deal([]);
[ci, stats] = deal ({});

% two-sample ttests comparing x values for each time step
for curTimestep = 1:minLen

    x1 = tr_x1(curTimestep,x1Col,:);
    x2 = tr_x2(curTimestep,x2Col,:);
    
    % CURRENTLY ASSUMING UNEQUAL VARIANCES !!! 
    
    [h(curTimestep), p(curTimestep)] = ttest2(x1,x2, 'tail', 'both','vartype','equal','alpha',useAlpha);            
    %h(curTimestep) = ttest2(x1,x2, 'tail', 'both');            
    %h(curTimestep) = ttest2(x1,x2);            
    
    
    
end


% find longest sequence of significant data points
% (its length can be comapred to bootstrapping results regarding required
% number of significant poitns)
counter = 0;
longestSeq = 0;
for i = 1:numel(h)
    
    if h(i) == 1
        counter = counter+1;
    end
    
    if h(i) ~= 1 || i == numel(h)
        if counter > longestSeq
            longestSeq = counter;
        end
        counter = 0;
    end
    
end

% Plot significance markers to currently selected axes
for i = 1:numel(h)
    if ~isnan(h(i)) && h(i)
        
        switch interpType
            case  'warped'
                yValueForSigMarkers = i;
            case 'aligned'
                yValueForSigMarkers = (i-1)*a.s.samplingPeriodForInterp;
            otherwise
                yValueForSigMarkers = [];
        end
        
        hTmp = plot(xValueForSigMarkers,yValueForSigMarkers,'k.','color','k', 'MarkerSize',5); % for warped trajs
        set(get(get(hTmp,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        hold on
        
    end
end

if augmentAxisTitle
    prevTitle = get(gca,'title'); prevTitle = prevTitle.String;
    title([prevTitle,' -- ','dots ind sig dif steps w/ p<', num2str(useAlpha) '; lngst seq: ' num2str(longestSeq) bootstrapResultString]);
end

disp(['max n of successive sig. (each p<', num2str(useAlpha),'): ' num2str(longestSeq)]);
 
% figure;
% %plot(h*10,1:minLen);
% plot(p);
% set(gca,'nextplot','add');
% plot(h);
% %set(gca,'nextplot',add);



