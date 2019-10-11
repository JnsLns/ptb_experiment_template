% Bootstrapping similar to Dale, Kehoe and Spivey 2007
% 
% This script performs a bootstrapping procedure like the one described
% in the paper above. The aim is to determine a reliable criterion at which
% a sequence of significant t-tests comparing multiple trajectory timesteps
% can be considered to indicate an overall significantly different sequence
% of trajecory data points.
% The rationale is to simulate a large number of experiments like the one from
% which the actual trajectories stem, by resampling from the sample
% distributions of the two mean trajectories that have been determined in the
% actual experiment. Key is that the independence of the successive data
% points is retained by this procedure, as the main goal of the whole
% procedure is to get a reliable criterion that holds despite the strong
% spatial dependence of data points in a trajectory.
% See a quote from Lins & Schöner (2017) at the bottom of this file, where
% we decribed the procedure in detail (the paragraph was later cut from the
% submitted version).
%
% Note that the ttest performed here is a two-tailed Welch t-test (i.e., not
% assuming equal variances), which is somewhat more conservative than a
% standard t-test. This can be easily adjusted in the respective portion
% of the code.
% 
% The bootstrapping is performed using the means and standard deviations
% computed from individual trajectories in a two-cell array a.trj.wrp.pos.ind
% (it may have more cells, but make sure in the settings below that the
% correct one is used).

%% Settings

% source data
% must contain a.trj.wrp.pos.ind and the struct a.s.trajCols, giving column number
% in individual trajectory matrices for values that should be compared.
dataFileName = 's:\bootstrap\007_meanTraj_DTRbySptAxisl_devVsPercTime.mat';
load(dataFileName); 

% set from which **two** cells trajectories should be taken; choose those
% that are also compared in the comparisons for which a criterion is computed
% here; bootstrapping is done based on the trajectory data in those cell.
useCellSubs_1 = [1 1]; % row and column of cell 1 from a.trj.wrp.pos.ind
useCellSubs_2 = [2 1]; % row and column of cell 2 from a.trj.wrp.pos.ind
trIndivWarped_bs = a.trj.wrp.pos.ind([sub2ind(size(a.trj.wrp.pos.ind),useCellSubs_1(1),useCellSubs_1(2)), ...
                              sub2ind(size(a.trj.wrp.pos.ind),useCellSubs_2(1),useCellSubs_2(2))]);

% Column number addressing into trajectory matrices pointing to data that
% should be used for comparisons (usually x-values).
sourceColumn = a.s.trajCols.x;

% Name of results file (all variables will be saved to it; decisive output
% is sigThresh, holding the length of a significant sequence that can be
% viewed as indicating overall significance in trajectory comparison)
resultsFileName = 'S:\testBoot';

% number of experiments to simulate
nExps = 10000;

% alpha level used in the individual t-tests between data points
tAlpha = 0.01;

% overall desired alpha level; used to determine sequence length that can
% be considered significant (note: after bootstrapping, it is possible to
% look up the required sequence length for other overall alpha-levels, by
% adjusting seqAlpha and then re-running the code line that computes
% sigThresh in the end of this script).
seqAlpha = 0.01;

% Plot results (empirical CDF with criterion marked)?
plotResults = 1;

%% Compute means and SDs across trajectories within each cell in input cell

for curNdx = 1:2
    % Compute means / stds and put into respective arrays                
    trWarpedMean_bs{curNdx} = alignedMean(trIndivWarped_bs{curNdx});
    trWarpedStd_bs{curNdx} = alignedStd(trIndivWarped_bs{curNdx});    
end

% Source data (means and sds of two trajectories that are compared).
traj1_means = trWarpedMean_bs{1}(:,sourceColumn);
traj1_stds = trWarpedStd_bs{1}(:,sourceColumn);
traj2_means = trWarpedMean_bs{2}(:,sourceColumn);
traj2_stds = trWarpedStd_bs{2}(:,sourceColumn);

n1 = numel(trIndivWarped_bs{1}); % number of trajs in condition 1
n2 = numel(trIndivWarped_bs{2}); % number of trajs in condition 1
                              % (these determine number of trials done in#
                              % each artificial experiment below)
%% Bootstrapping

tic

% this collects the length of the longest sig. sequence for each artifical experiment
longestSequences = zeros(nExps,1);

% loop over experiments
parfor curExp = 1:nExps        
    
    % Generate trajectories    
    simulatedTrajs_con1 = [];
    simulatedTrajs_con2 = [];    
    % loop over trials of each sample (same n as in respective input)
    % and for each trial, make an artificial trajectory by drawing from
    % normal distribution defined by parameters derived from input data
    for i = 1:n1
        simulatedTrajs_con1{i} = randnParams(traj1_means,traj1_stds);        
    end
    for i = 1:n1
        simulatedTrajs_con2{i} = randnParams(traj2_means,traj2_stds);
    end
    
    testWhat = {simulatedTrajs_con1',simulatedTrajs_con2'};
          
    % t-Testing
    
    % prepare ttests    
    tr_x1 = cell2mat(cellCollapseAndTrim(testWhat{1},1,3));
    tr_x2 = cell2mat(cellCollapseAndTrim(testWhat{2},1,3));    
    minLen = min(size(tr_x1,1),size(tr_x2,1));    
    h = [];
    
    % for each timestep, do two-sample ttest comparing x values --
    % (using Welch's test for unequal variances)
    for curTimestep = 1:minLen
        x1 = tr_x1(curTimestep,sourceColumn,:);
        x2 = tr_x2(curTimestep,sourceColumn,:);
        h(curTimestep) = ttest2(x1,x2, 'tail', 'both','vartype','unequal','Alpha',tAlpha);
    end    
            
    % Find longest sequence of consecutive significant tests in this experiment    
    lenHigh = 0; lenCur = 0;
    for i = 1:numel(h)
        if h(i) == 1
            lenCur = lenCur+1;
        end
        if i == numel(h) || h(i) == 0
            if lenCur > lenHigh
                lenHigh = lenCur;
            end
            lenCur = 0;
        end
    end
    longestSequences(curExp) = lenHigh;
       
end

toc

% determine sequence length required for significance at p < seqAlpha
[cumFreq,seqLen] = ecdf(longestSequences);
sigThresh = [];
sigThresh = seqLen(1-cumFreq < seqAlpha); sigThresh = sigThresh(1);

save(resultsFileName);

%% CDF plot for visualizing result

if plotResults
    
    % plot cumulative distribution function of simulated data
    figure('position',[680 430 730 550]);
    hCdf = cdfplot(longestSequences);
    xlabel(['max. sequence length (sig. timesteps with p < ' num2str(tAlpha) ')']);
    ylabel(['cumulative frequency']);
    title(['Empirical CDF of max. length of sig. sequences in ', num2str(nExps), ' simulated experiments w/ ', ...
        num2str(n1),'(cond1)/',num2str(n2),'(cond2) trials each']);
    
    % mark in plot
    if ~isempty(sigThresh)
        line([sigThresh sigThresh],[0 1],'linestyle',':','Color','r','linewidth',1.5)
    end
    
    legend({'CDF',['seq. length for overall p<' num2str(seqAlpha) ' = ' num2str(sigThresh)]},'location','northwest')
    
end

%% Quote from Lins & Schöner, 2017, about the procedure:

% "Mean trajectories were compared by testing for statistically significant
% differences between their x-coordinates at each of their 151 time steps,
% using two-tailed two-sample t-tests (Welch's unequal variances t-test).
% We used a threshold of $p<0.01$ for all comparisons. Since data points
% in each mean trajectory are highly interdependent, the informative value
% of each individual t-test is limited. To remedy this, we used the boot- 
% strapping procedure first employed by \citet{Dale2007} and since used
% in various mouse tracking studies. It provides a criterion for how many
% t-tests in a consecutive sequence must yield significance before the
% difference between trajectories can be considered overall significant.
% For each comparison reported here, a separate criterion was computed,
% using the compared data as basis. Computing a criterion for a given
% comparison included 10,000 artificial experiments, each conducted as
% follows. Given two mean trajectories computed from $N_i$ and $N_j$ real
% experimental trials, respectively, each of them was used to construct%
% $N_i$ and $N_j$ artificial trajectories, respectively. An artificial
% trajectory was constructed by drawing, for each time step, from a normal
% distribution defined by the mean and standard deviation for that time
% step in the corresponding mean trajectory. The two obtained sets of
% artificial trajectories were then used to compute two new mean
% trajectories. T-tests were conducted between each of their time steps
% in the same manner as for the real data (i.e., Welch's test, $p<0.01$).
% For each of the 10,000 experiments we recorded the length of the longest
% consecutive sequence of significantly different time steps.
% The final criterion for overall significance with $p<0.01$ was the
% maximum sequence length achieved in less than 100 (1\%) of the 10,000
% experiments. We report this length criterion for each comparison."
