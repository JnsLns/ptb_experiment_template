
% Bootstrapping similar to Dale, Kehoe and Spivey 2007
%
% ANOVA versions. Works, but pretty WIP...
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

% number of experiments to simulate
nExps = 10000;

% alpha level used in the individual t-tests between data points
% IMPORTANT: This has to be the same as the alpha level used for the
% multiple t-tests on the real data!
anovaAlpha = 0.05;

% overall desired alpha level; used to determine sequence length that can
% be considered significant ( it may be appropriate to correct, i.e. lower,
% this threshold based on the total number of comparisons done for the
% experiment at hand).
seqAlpha = 0.01;

% Plot results (empirical CDF with criterion marked)?
plotResults = 0;

%useCol = a.s.trajCols.x;

%% RMANOVA settings
nF1 = 2; % factor 1 levels
nF2 = 2; % factor 2 levels

% make columns denoting conditions and participants
nPts = 20; % get from artifical data
f1Levels = 2; % dtr % probably prespecify
f2Levels = 2; % ref % probably prespecify in bootstrap script

group = [];
for curPts = 1:nPts
    for curF1Lev = 1:f1Levels
        for curF2Lev = 1:f2Levels
            group(end+1,1) = curPts;
            group(end,2) = curF1Lev;
            group(end,3) = curF2Lev;
        end
    end
end

group = sortrows(group,[3,2,1]);
% this order allows to go through the four conditions and get all
% participants from the respective condition and concatenate them

group = {group(:,1),group(:,2),group(:,3)};
%%

% Input that must be present in workspace:
% a.byPts.trj.wrp.pos.avg
% holding difference scores btw pair B left and right trajectories for each
% participant and in each of the conditions
% full pair B (ref B pres, dtr pres)
% ref B only (ref B pres, dtr abs)
% dtr only (ref b abs, dtr pres)
% pair A only (ref b abs, dtr abs)
%
% first dimension must be singleton
% conditions must be columns (2nd dim)
% participants must be along a.s.ptsDim = third dim

load bootstrapInput.mat
%input = a.byPts.trj.wrp.pos.avg;
%ptsDim = a.s.ptsDim;

input = cellfun(@(tr) tr(:,useCol), input, 'uniformoutput',0);

%[bs.file_out,bs.path_out] = uiputfile;

bs.nExps = nExps;
bs.anovaAlpha = anovaAlpha;
bs.seqAlpha = seqAlpha;

tic

% Loop over bootstrap experiments
%parpool(3)
parfor curExp = 1:bs.nExps
    
    % Loop over the compared conditions
    artificialData = cell(size(input));
    for curCondition = 1:size(input,2)
        
        % compute mean and standard deviation ACROSS PARTICIPANTS MEAN
        % trajectories (i.e., participant means pose the ensemble here,
        % variance between trials and individual trial numbers do not
        % affect this) in the current condition
        meanOvrPts = mean(cell2mat(cellCollapse(input(1,curCondition,:),3,2)),2);
        stdOvrPts = std(cell2mat(cellCollapse(input(1,curCondition,:),3,2)),0,2);
        % Loop over participants and for each sample a mean trajectory from
        % the across-pts mean trajectory
        for curPts = 1:size(input,ptsDim)
            artificialData{1,curCondition,curPts} = randnParams(meanOvrPts,stdOvrPts);
        end
        
        %%%%%%%%%%%% debug plot
        % figure;
        % hold on; hMn = plot(1:151,meanOvrPts,'linewidth',4,'color','b');
        % plotErrorPatch(hMn,stdOvrPts);
        % ptsMeans = cell2mat(cellCollapse(loaded.bootstrapInput.(curCondition{1}).avg,2,2));
        % plot(1:151,ptsMeans,'color','g');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    end
                
    
    
    % RM ANOVA          
    anovaPs = cell(size(artificialData{1},1),1);
    anovaTbls = anovaPs;       
    for curStep = 1:size(artificialData{1},1)
        % get one value from each participant (1 per condition)
        curStepDat = cellfun(@(tr) tr(curStep,useCol),artificialData,'uniformoutput',0);
        % collapse cell along pts dim, so that the new cell has one cell for each
        % condition and in each of these cells a row vector holding participants'
        % effect values
        curStepDat = cellCollapse(curStepDat,ptsDim,1);                
        % collapse across conditions
        curStepDat = cellCollapse(curStepDat,2,1);
        curStepDat = cell2mat(curStepDat);
        % do the ANOVA
        [anovaPs{curStep} anovaTbls{curStep}] = anovan(curStepDat,group,'random',[1],'model','interaction','varnames',{'pts','dtr','ref'},'display','off');                        
    end
    
    effects = [];
    pstmp = [];
    
    % All ps (includes some irrelevant ones from the random factor)
    pstmp = cell2mat(cellCollapse(anovaPs,1,2));
    % Dtr main effect assumed to be second
    effects.dtr = pstmp(2,:)'<anovaAlpha;    
    % Ref main effect assumed to be third
    effects.ref = pstmp(3,:)'<anovaAlpha;
    % Interaction dtr*ref assumed to be sixth
    effects.dtrRef = pstmp(6,:)'<anovaAlpha;                     
    
    % Find longest sequence of consecutive significant tests in this experiment    
    % for each effect/interaction
    for curEff = fieldnames(effects)'
        
        h = effects.(curEff{1});
        
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
        
        switch curEff{1}
            case 'dtrRef'            
            longestSequences_dtrRef(curExp) = lenHigh;
            case 'dtr'
            longestSequences_dtr(curExp) = lenHigh;
            case 'ref'        
            longestSequences_ref(curExp) = lenHigh;
        end                            
        
    end
    
    %%%%%%%%%%%%%%%% debug plot
    % figure
    % plot(1:151,artificialData.conditionA,'color','r');
    % hold on
    % plot(1:151,artificialData.conditionB,'color','b');
    % hTmp = plot(1:151,meanOvrPts,'color','g','linewidth',3);
    % hPatch = plotErrorPatch(hTmp,stdOvrPts);
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    
end

longestSequences.dtrRef = longestSequences_dtrRef;
longestSequences.dtr = longestSequences_dtr;
longestSequences.ref = longestSequences_ref;
bs.longestSequences = longestSequences;

for curEff = fieldnames(longestSequences)'
    
    % determine sequence length required for significance at p < bs.seqAlpha
    [bs.cumFreq.(curEff{1}),bs.seqLen.(curEff{1})] = ecdf(longestSequences.(curEff{1}));
    bs.sigThresh.(curEff{1}) = [];
    bs.sigThresh.(curEff{1}) = bs.seqLen.(curEff{1})(1-bs.cumFreq.(curEff{1}) < bs.seqAlpha);
    bs.sigThresh.(curEff{1}) = bs.sigThresh.(curEff{1})(1);
    
    % save results
    %save([bs.path_out bs.file_out],'bs','loaded');
    
    toc
    
    
    % CDF plot for visualizing result
    
    if plotResults
        % plot cumulative distribution function of simulated data
        figure('position',[680 430 730 550]);
        hCdf = cdfplot(bs.longestSequences.(curEff{1}));
        xlabel(['max. sequence length (sig. timesteps with p < ' num2str(bs.anovaAlpha) ')']);
        ylabel(['cumulative frequency']);
        title([curEff{1},' / Empirical CDF of max. length of sig. sequences in ', num2str(bs.nExps), ' simulated experiments']);
        % mark in plot
        if ~isempty(bs.sigThresh.(curEff{1}))
            line([bs.sigThresh.(curEff{1}) bs.sigThresh.(curEff{1})],[0 1],'linestyle',':','Color','r','linewidth',1.5)
        end
        legend({'CDF',['seq. length for overall p<' num2str(bs.seqAlpha) ' = ' num2str(bs.sigThresh.(curEff{1}))]},'location','northwest')
    end
    
       
end

save('S:\bootstrapOutput_pairBfillers_ANOVA.mat');
