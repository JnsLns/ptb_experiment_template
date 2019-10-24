
% NOTE This script works but is quite rough in usage (if this is needed
% more often, code something more embedded in existing analysis script).
%
% This auxiliary script plots an average trajectory for each of a number of
% comparisons (and the associated plots). It does so without changing
% anything in any of the experimental/analysis data, as everything that
% happens here is encapsulated in a function (that calls existing analysis code).
% a and aTmp must be present in the workspace, that is, analysis must have
% been run already. The output average trajectory is based on the exact
% same trials as specified in the existing rowSets (i.e., if balancing has
% been done, that is replicated here). Rowsets are joined along the
% dimension defined by overall Dim.
%
% Average curves can then be copied into existing codes by hand (see code
% at the bottom).

% Note: The average curve may not lie on the exact center between the
% compared ones in case one of the compared mean trajectory is based on
% fewer trials than the other in some of the participants.

% Note: This script subtracts the overall mean trajectory (including all
% individual trials from condition A and B) from the mean trajectory of
% each separate condition; this is equivalent to subtracting the overall
% mean trajectory from each individual trajectory in a condition and then
% averaging across the individual differences.

% Note: Is the mean trajectory done across participants (i.e., pooling
% all trials in the comparison) or within participant and then averaged?
%(note: this comment also applies to the original overall mean traj
% script!) --> checked that: it is done within each participant and only
% then averaged.

% Call function at the bottom using existing vars as arguments
aOverall = testa(a,aTmp);

%%
function aOverall = testa(a,aTmp)

% Dimension/IV for which an overall trajecotry is desired
overallDim = 1;

% Collpase rowSets along dimension along whcih average is desired
a.s.rowSets = cellLogicalOr(a.s.rowSets,overallDim,1:size(a.s.rowSets,overallDim));

if ~isfield(a.s,'someFlippingHasOccurred')
a.s.someFlippingHasOccurred = 0;
end

computeStatistics;
averageAcrossPtsMeans;
plotSettings; % Be sure to select the correct plot settings 
plotTrajData;           % Plotting: trajectories

aOverall = a;

% UNTESTED (but should work, I think)
%plotResData;            % Plotting: non-trajectory data
%plotConstraintCategoryDistribution_analysis; 

end


%% Code for copying line into different axes, change style etc.


% %Click into source axes (containing average line)
% %Change properties
% curAvgLine = findobj(gca,'type','line');
% curAvgLine.LineStyle = ':';
% curAvgLine.LineWidth = 1.5;
% curAvgLine.Color = [.6 .6 .6];
% curAvgLine.DisplayName = '';
% curAvgLine.Annotation.LegendInformation.IconDisplayStyle = 'off';
% curAvgLine.Tag = 'overallLine';
% 
% % click into target axes
% % copy
% copyobj(curAvgLine,gca)



 
