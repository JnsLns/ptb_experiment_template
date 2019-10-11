% This is a test "aggregated subsampling" grand mean converges toward mean
% of means.
% The steps for the aggregated subsampling procedure are
% - Generate three blocks, each including a different number of randomly generated
%   values
% - From each block sample (without replacement) a number of values equal
%   to the minimum number of values in any block (i.e., the set of values
%   from the block including the least values is equal to the entire block)
% - Take the grand mean across all values 
% - Repeat this procedure a large number of times, storing the obtained
%   grand mean for each repetition
% - In the end, take the mean across all obtained grand means
%
% The resulting mean of subsampling means after each iteration is compared
% to the simple mean over the three group means (without any iteration or
% subsampling).
% The purpose of both is to include all available values into
% the overall mean to improve the estimate of the overall mean, while
% maintaining a balance between impacts from the different blocks (this is
% supposed to be analogous to using all trials in a condition in the
% complex array task while maintaining balance between balancing
% categories).

% Generate value blocks
blocks{1} = rand(100,1)*50;
blocks{2} = rand(500,1)*1;
blocks{3} = rand(1000,1)*10;

% Simple mean of block means
blockMeans = cellfun(@(curb)  mean(curb),blocks);
simple_meanOfMeans = mean(blockMeans);

% Subsampling   
numSamples = 100;
minCases = min(cellfun(@(curb)  numel(curb),blocks));
subsampledMeanOfMeans = []; curBlockMeans_subsampled = []; convergingOverallMeans = [];
for curSubsample = 1:numSamples
    for i = 1:numel(blocks)
        curb = blocks{i};
        curbNumCases = numel(curb);
        useLindcs = randperm(curbNumCases);
        curBlockMeans_subsampled(i) = mean(curb(useLindcs(1:minCases)));
    end
    subsampledMeanOfMeans(curSubsample) = mean(curBlockMeans_subsampled);   
    convergingOverallMeans(curSubsample) = mean(subsampledMeanOfMeans);
end


tmp1 = plot(ones(1,numSamples)*simple_meanOfMeans,'linewidth',2,'linestyle',':'); hold on;
set(get(get(tmp1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
tmp2 = plot(convergingOverallMeans,'color',tmp1.Color);
tmp2.DisplayName = [num2str(numel(blocks{1})) ,' ', num2str(numel(blocks{2})) ,' ', num2str(numel(blocks{3}))];




