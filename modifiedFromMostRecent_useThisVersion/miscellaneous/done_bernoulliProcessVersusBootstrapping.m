% This is a test script to see whether a simple Bernoulli process (implemented here
% over 101 steps and p = 0.05 yields the same outcome as bootstrapping from
% experimental trajectory data when sampling from an overall mean trajectory
% (i.e., under the null hypothesis) instead of from condition-specific mean
% trajectories.

n = 151; % length of bernoulli process
p = 0.01; % P(success) = alpha of t-test
nExps = 10000;% repetitions of Bernoulli process

longestSequences = [];
for curExp = 1:nExps

    expResults = rand(1,n)<p;

    % Find longest sequence of consecutive significant tests in this experiment
    lenHigh = 0; lenCur = 0;
    for i = 1:numel(expResults)
        if expResults(i) == 1
            lenCur = lenCur+1;
        end
        if i == numel(expResults) || expResults(i) == 0
            if lenCur > lenHigh
                lenHigh = lenCur;
            end
            lenCur = 0;
        end
    end
    longestSequences(curExp) = lenHigh;
    
end

seqAlpha = 0.01;
[cumFreq,seqLen] = ecdf(longestSequences);
sigThresh = seqLen(1-cumFreq < seqAlpha);    
sigThresh = sigThresh(1);

figure; cdfplot(longestSequences)
line([sigThresh sigThresh],[0 1],'linestyle',':','Color','r','linewidth',1.5)

figure; histogram(longestSequences)

