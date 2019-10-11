








%% THIS IS PRELIMINARY !!!!! 
% CHECK AND REFINE THOROUGHLY BEFORE USING!!!!!









































% Using matlabs ttest with all the data, not the means and stds...
% for comparison with own computation.
    
% use which trajectories (differ in interpolation: homogeneous time intervals
% versus time-warped to equal number of timesteps)
%testWhat = a.trj.alg.pos.ind;
testWhat = a.trj.wrp.pos.ind;
%testWhat = a.trj.wrp.spd.ind;

% Define columns of interest 
x1Col = a.s.trajCols.x;

% adjust indexing into elements of testWhat trajectories from which should
% be compared (remember that dimensionality of testWhat is dependent on
% number of IVs, which can be looked up in cell array a.s.ivs from analysis)
tr_x1 = cell2mat(cellCollapseAndTrim(testWhat{1},1,3));

% alpha level for individual tests
useAlpha = 0.01;

% Add info about dots and significant sequence length to axis title?=
augmentAxisTitle = 0;
% If so, add the following info about bootstrap results regarding
% significance 
bootstrapResultString =  ' ; btstrp: 15 = sig.'; % may be left empty ''
%bootstrapResultString = '';

% Place significance marker at what x-value in figure?
xValueForSigMarkers = -15;

%%--- RUN TEST

minLen = min(size(tr_x1,1));

[h, p] = deal([]);
[ci, stats] = deal ({});

% one-sample ttest testing for diff to zero
for curTimestep = 1:minLen

    x1 = tr_x1(curTimestep,x1Col,:);
    
    
    
    [h(curTimestep), p(curTimestep)] = ttest(x1);            
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


for i = 1:numel(h)
    if ~isnan(h(i)) && h(i) 
    %plot(0,i*0.01-0.01,'k.', 'MarkerSize', 5); % for aligned trajs
    hTmp = plot(xValueForSigMarkers,i,'k.','color','k', 'MarkerSize',2); % for warped trajs                
    if augmentAxisTitle
        prevTitle = get(gca,'title'); prevTitle = prevTitle.String;
        title([prevTitle,' -- ','dots ind sig dif steps w/ p<', num2str(useAlpha) '; lngst seq: ' num2str(longestSeq) bootstrapResultString]);
    end
    set(get(get(hTmp,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    hold on
    end
end


disp(['max n of successive sig. (each p<', num2str(useAlpha),'): ' num2str(longestSeq)]);
 
% figure;
% %plot(h*10,1:minLen);
% plot(p);
% set(gca,'nextplot','add');
% plot(h);
% %set(gca,'nextplot',add);



