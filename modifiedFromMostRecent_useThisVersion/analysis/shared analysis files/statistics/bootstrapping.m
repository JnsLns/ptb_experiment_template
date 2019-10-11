
% Bootstrapping similar to Dale, Kehoe and Spivey 2007
%
% This script performs a bootstrapping procedure like the one described
% in the paper above. The aim is to determine a reliable criterion at which
% a sequence of significant t-tests comparing multiple trajectory timesteps
% can be considered to indicate an overall significantly different sequence
% of trajecory data points.
% The rationale is to simulate a large number of experiments like the one from
% which the actual trajectories stem, by sampling from the sample
% distributions of the mean trajectories that have been determined in the
% actual experiment. Key is that the independence of the successive data
% points is retained by this procedure (in terms of sampling from the
% normal distribution around the actual mean), as the main goal of the whole
% procedure is to get a reliable criterion that holds despite the strong
% spatial dependence of data points in a trajectory. The point is that only
% displacement of data points due to error variance is made independent
% between timesteps in a trajectory, but not the dependence of means from
% one timestep to the next.
% So the rationale is that it is checked how many significant differences
% in a row are achieved if each point's error variance would impact purely
% randomly on that point instead of being bound by spatial dependency. If
% the resulting sequences are short, we can infer that any longer sequences
% in the actual data are not due to that random error variance.
%
%
% As input, the script expects the data stored by pairedSampleTtest.m which
% contains two mean trajectories for each participant, one for each of the
% two compared conditions.
%
% The script however takes the mean over those participant means*, in each
% condition separately. Then *for each condition separately*:
% the script samples from the obtained across-pts. mean trajectory, timestep
% by timestep, to construct an artificial mean trajectory (no detour over
% individual trials) for each participant. The sampling is done
% parametrically (in contrast to resampling) using as basis normal
% distributions centered on the individual data points in the across-pts.
% mean trajectory; the standard deviation parameter for that distribution
% is the standard deviation *across* participants (not trials or anything
% else) for that data point. This means individual trials and their numbers
% do not matter here anymore -- the ensemble that matters is the participants!

% *NOTE that this removes the paired sample information, doesn't that mean
% that the power of the test done here is reduced compared to that of the
% test performed of the original data?

%% Settings

nCores = 3; % Number of cores to use for parallel computation

% 0: single file (& manual output name)
% 1: multiple input files (automatic output name; same as input file, but bootstrapInput changed to bootstrapOutput)
multifile = 0;

% number of experiments to simulate
nExps = 10000;

% alpha level used in the individual t-tests between data points
% IMPORTANT: This has to be the same as the alpha level used for the
% multiple t-tests on the real data!
tAlpha = 0.01;

% overall desired alpha level; used to determine sequence length that can
% be considered significant ( it may be appropriate to correct, i.e. lower,
% this threshold based on the total number of comparisons done for the
% experiment at hand).
seqAlpha = 0.01;

% Plot results (empirical CDF with criterion marked)?
plotResults = 0;


%%

if ~multifile
    [bs.file_in,bs.path_in] = uigetfile;
    [bs.file_out,bs.path_out] = uiputfile;
    nFiles = 1;
elseif multifile
    [file_in_list,path_in] = uigetfile('Select input files','Select input files','multiselect','on');
    path_out = uigetdir('title','Select output directory');
    nFiles = numel(file_in_list);
end

parpool(nCores);

% loop over files
for curFile = 1:nFiles
    
    if multifile
        bs.path_in = path_in;
        bs.file_in = file_in_list{curFile};
        bs.path_out = [path_out,'\'];
        bs.file_out = strrep(bs.file_in,'bootstrapInput','bootstrapOutput');
        if strcmp(bs.file_in,bs.file_out); error('input and output file have the same name'); end
    end
    
    bs.nExps = nExps;
    bs.tAlpha = tAlpha;
    bs.seqAlpha = seqAlpha;
    
    tic
    
    loaded = load([bs.path_in,bs.file_in]);
    
    % Loop over experiments    
    parfor curExp = 1:bs.nExps
    
        % Loop over the two compared conditions
        artificialData = [];
        for curCondition = fieldnames(loaded.bootstrapInput)'
    
            % compute mean and standard deviation ACROSS PARTICIPANTS MEAN
            % trajectories (i.e., participant means pose the ensemble here,
            % variance between trials and individual trial numbers do not
            % affect this) in the current condition
            meanOvrPts = mean(cell2mat(cellCollapse(loaded.bootstrapInput.(curCondition{1}).avg,2,2)),2);
            stdOvrPts = std(cell2mat(cellCollapse(loaded.bootstrapInput.(curCondition{1}).avg,2,2)),0,2);
            % Loop over participants and for each sample a mean trajectory from
            % the across-pts mean trajectory
            for curPts = 1:numel(loaded.bootstrapInput.(curCondition{1}).avg)
                artificialData.(curCondition{1})(:,curPts) = randnParams(meanOvrPts,stdOvrPts);
            end
    
            %%%%%%%%%%%% debug plot
            % figure;
            % hold on; hMn = plot(1:151,meanOvrPts,'linewidth',4,'color','b');
            % plotErrorPatch(hMn,stdOvrPts);
            % ptsMeans = cell2mat(cellCollapse(loaded.bootstrapInput.(curCondition{1}).avg,2,2));
            % plot(1:151,ptsMeans,'color','g');
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
        end
    
        % Paired sample ttest for each time step
        [h, p] = deal([]);
        for curTimestep = 1:size(artificialData.conditionA,1)
            [h(curTimestep), p(curTimestep)] = ttest(artificialData.conditionA(curTimestep,:)', ...
                artificialData.conditionB(curTimestep,:)', ...
                'alpha',bs.tAlpha);
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
    
    
        %%%%%%%%%%%%%%%% debug plot
        % figure
        % plot(1:151,artificialData.conditionA,'color','r');
        % hold on
        % plot(1:151,artificialData.conditionB,'color','b');
        % hTmp = plot(1:151,meanOvrPts,'color','g','linewidth',3);
        % hPatch = plotErrorPatch(hTmp,stdOvrPts);
        %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    end
    
    bs.longestSequences = longestSequences;
    
    % determine sequence length required for significance at p < bs.seqAlpha
    [bs.cumFreq,bs.seqLen] = ecdf(longestSequences);
    bs.sigThresh = [];
    bs.sigThresh = bs.seqLen(1-bs.cumFreq < bs.seqAlpha);
    bs.sigThresh = bs.sigThresh(1);
    
    % save results
    save([bs.path_out bs.file_out],'bs','loaded');
    
    toc
        
    %% CDF plot for visualizing result
    
    if plotResults
        
        % plot cumulative distribution function of simulated data
        figure('position',[680 430 730 550]);
        hCdf = cdfplot(bs.longestSequences);
        xlabel(['max. sequence length (sig. timesteps with p < ' num2str(bs.tAlpha) ')']);
        ylabel(['cumulative frequency']);
        title(['Empirical CDF of max. length of sig. sequences in ', num2str(bs.nExps), ' simulated experiments']);
        
        % mark in plot
        if ~isempty(bs.sigThresh)
            line([bs.sigThresh bs.sigThresh],[0 1],'linestyle',':','Color','r','linewidth',1.5)
        end
        
        legend({'CDF',['seq. length for overall p<' num2str(bs.seqAlpha) ' = ' num2str(bs.sigThresh)]},'location','northwest')
        
        % plot p-value against sequence threshold (i.e.:
        % "what's the p-value of the sequence length I actually found in my experiment?")
        % WORK IN PROGRESS (works in principle but not very useful due to the
        %"low resolution" of p-estimates)
%         ps = fliplr([0.00001 0.0001 0.001 0.01 0.05 0.1]);
%         seqLens = nan(1,numel(ps));
%         for k = 1:numel(ps)
%             curSigThresh = bs.seqLen(1-bs.cumFreq < ps(k));
%             seqLens(k) = curSigThresh(1);
%         end
%         figure; barh(1:numel(ps),seqLens); hold on;
        
    end
    
    
    %%
    if multifile
        clearvars loaded bs
    end
    
end