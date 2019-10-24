%% Define independent variables (IVs), IV-levels, plotting styles, etc.

disp('Reading IV definition');

% See Documentation.txt for help.

%% Define meaning of columns in cell array ivs 

a.s.ivsCols.name = 1;           % IV name 
a.s.ivsCols.style = 2;          % plot style
a.s.ivsCols.rsCol = 3;          % corresponding column in results matrix
a.s.ivsCols.values = 4;         % set of possible code values for conditions
a.s.ivsCols.valLabels = 5;      % verbal labels for these codes
a.s.ivsCols.useVal = 6;         % include conditions in analysis?
a.s.ivsCols.diffs = 7;          % define differences that will be computed btw. conditions                     
a.s.ivsCols.tmpValsDiff = 8;    % internal, do not set by hand
a.s.ivsCols.doMirror = 9;       % flip trajectories from that condition?
a.s.ivsCols.joinVals = 10;      % treat conditions as one set by computing grand mean
                                % across their trials (a.s.combineLevelsByMeanOfMeansNotGrandMean==0) 
                                % OR or do mean of means across the means
                                % in these conditions (a.s.combineLevelsByMeanOfMeansNotGrandMean==1) 
a.s.ivsCols.subtractOverallMean = 11; % flag for subtracting overall mean across that IV from all levels (*)
a.s.ivsCols.tmpValsJoin = 12;   % internal, do not set by hand

% (*) a.s.ivsCols.subtractOverallMean may be 1 for at most *one* IV and must
% be zero for all others!

%% Define IVs and their levels/conditions:
% enable one of the predefined blocks or construct a new one.

a.s.ivs = cell(0); % initialize ivs cell
a.s.relevantBalancingColumn = []; % make sure no balancing is done by default even if pre-processed data is loaded


% --- Basic settings (participants, correct/incorrect, word order etc.)

% The manually defined participant IV must always be the first one defined here
% and thus occupy the first row of a.s.ivs (in contrast to the automatically
% generated internalPtsDim that is used if a.s.averageAcrossParticipantMeans==1)
% NOTE: This comes to effect only if averaging over participants is DISabled!
if ~a.s.averageAcrossParticipantMeans
    a.s.ivs{end+1,a.s.ivsCols.name } = 'participants (manual)'; % THIS LABEL MUST NOT BE CHANGED
    a.s.ivs{end,a.s.ivsCols.style } = '';
    a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.pts;
    a.s.ivs{end,a.s.ivsCols.values} = unique(a.rs(:,a.s.resCols.pts));
    a.s.ivs{end,a.s.ivsCols.valLabels} = num2cell(unique(a.rs(:,a.s.resCols.pts)));
    a.s.ivs{end,a.s.ivsCols.useVal} = ones(numel(unique(a.rs(:,a.s.resCols.pts))),1);  % all
    %a.s.ivs{end,a.s.ivsCols.useVal} = [1 0 0 0 0 0 0 0 0 0 0 0]';
    a.s.ivs{end,a.s.ivsCols.diffs} = [];
    a.s.ivs{end,a.s.ivsCols.doMirror} = zeros(numel(unique(a.rs(:,a.s.resCols.pts))),1);    
    a.s.ivs{end,a.s.ivsCols.joinVals} = {};
    a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;    
    
    % set number of participant dimension   
    a.s.ptsDim = size(a.s.ivs,1);
    
end

% exclude "incorrect" trials
a.s.ivs{end+1,a.s.ivsCols.name } = 'correct/incorrect';
a.s.ivs{end,a.s.ivsCols.style } = '';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.correct;
a.s.ivs{end,a.s.ivsCols.values} = [1;0];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'correct','incorrect'};
a.s.ivs{end,a.s.ivsCols.useVal} = [1;0];
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

% exclude curved trials
a.s.ivs{end+1,a.s.ivsCols.name } = 'curvature';
a.s.ivs{end,a.s.ivsCols.style } = 'subplotColumns';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.exceedsCurveThresh;
a.s.ivs{end,a.s.ivsCols.values} = [0;1];
a.s.ivs{end,a.s.ivsCols.valLabels} = {['crv <= ' num2str(a.s.curvatureCutoff)];['crv > ' num2str(a.s.curvatureCutoff)] };
a.s.ivs{end,a.s.ivsCols.useVal} = [1;0];
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

% curvature bins
% a.s.ivs{end+1,a.s.ivsCols.name } = 'curvature bin';
% a.s.ivs{end,a.s.ivsCols.style } = 'subplotRows';
% a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.curvatureBin;
% a.s.ivs{end,a.s.ivsCols.values} = (1:numel(a.s.curvatureBinsUpperBounds))';
% a.s.ivs{end,a.s.ivsCols.valLabels} = cellfun(@(numLabel) num2str(numLabel), num2cell(a.s.curvatureBinsUpperBounds), 'uniformoutput',0)';
% a.s.ivs{end,a.s.ivsCols.useVal} = ones(1,numel(a.s.curvatureBinsUpperBounds));
% a.s.ivs{end,a.s.ivsCols.diffs} = [];
% a.s.ivs{end,a.s.ivsCols.doMirror} = zeros(1,numel(a.s.curvatureBinsUpperBounds))';
% a.s.ivs{end,a.s.ivsCols.joinVals} = {};
% a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

% MAY NOT BE PRESENT IN SOME DATA (and coding may vary)
% a.s.ivs{end+1,a.s.ivsCols.name } = 'tgtSlotDerived';
% a.s.ivs{end,a.s.ivsCols.style } = 'subplotRows';
% a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.tgtSlotDerived;
% a.s.ivs{end,a.s.ivsCols.values} = [1;2;3;4];
% a.s.ivs{end,a.s.ivsCols.valLabels} = {'top left';'top right';'lower left';'lower right'};
% a.s.ivs{end,a.s.ivsCols.useVal} = [0;0;0;0];
% a.s.ivs{end,a.s.ivsCols.diffs} = [];
% a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
% a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2];[3;4]};
% a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

% Plot curved and non-curved trajectories in different figures
% a.s.ivs{end+1,a.s.ivsCols.name } = 'curvature';
% a.s.ivs{end,a.s.ivsCols.style } = 'figures';
% a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.exceedsCurveThresh;
% a.s.ivs{end,a.s.ivsCols.values} = [0;1];
% a.s.ivs{end,a.s.ivsCols.valLabels} = {['crv <= ' num2str(a.s.curvatureCutoff)];['crv > ' num2str(a.s.curvatureCutoff)] };
% a.s.ivs{end,a.s.ivsCols.useVal} = [1;1];
% a.s.ivs{end,a.s.ivsCols.diffs} = [];
% a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
% a.s.ivs{end,a.s.ivsCols.joinVals} = {};
% a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

% word order
% a.s.ivs{end+1,a.s.ivsCols.name } = 'word order';
% a.s.ivs{end,a.s.ivsCols.style } = 'lineColor';
% a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.wordOrder;
% a.s.ivs{end,a.s.ivsCols.values} = [1;2];
% a.s.ivs{end,a.s.ivsCols.valLabels} = {'t-s-r';'s-r-t'};
% a.s.ivs{end,a.s.ivsCols.useVal} = [1,1];
% a.s.ivs{end,a.s.ivsCols.diffs} = [];
% a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
% a.s.ivs{end,a.s.ivsCols.joinVals} = {};
% a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

% the four target positions
% a.s.ivs{end+1,a.s.ivsCols.name } = 'tgtpos';
% a.s.ivs{end,a.s.ivsCols.style } = 'subplotRows';
% a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.tgtSlotDerived;
% a.s.ivs{end,a.s.ivsCols.values} = [1;2;3;4];
% a.s.ivs{end,a.s.ivsCols.valLabels} = {'1';'2';'3';'4'};
% a.s.ivs{end,a.s.ivsCols.useVal} = [1;1;1;1];
% a.s.ivs{end,a.s.ivsCols.diffs} = [];
% %a.s.ivs{end,a.s.ivsCols.doMirror} = [0;1];
% a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
% a.s.ivs{end,a.s.ivsCols.joinVals} = {};
% a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

% to exclude trials where there was an "opposite distractor"
% a.s.ivs{end+1,a.s.ivsCols.name } = 'n items in tgt color';
% a.s.ivs{end,a.s.ivsCols.style } = 'subplotRows';
% a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.nTgts;
% a.s.ivs{end,a.s.ivsCols.values} = [2;3];
% a.s.ivs{end,a.s.ivsCols.valLabels} = {'2';'3'};
% a.s.ivs{end,a.s.ivsCols.useVal} = [1;1];
% a.s.ivs{end,a.s.ivsCols.diffs} = [];
% a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
% a.s.ivs{end,a.s.ivsCols.joinVals} = {};
% a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;




% use these to switch between analyses quickly (else set all to zero and
% select manually in the code below)
%
% effects of item side
acrossAll_butBalanced = 1;
allBySptAxis = 0;
byDtrSide = 0;
byDtrSideBySptAxis = 0;
byRefSide = 0;
byRefSideBySptAxis = 0;
% differences for interaction tests
dtrSide_DIFF_RminL_bySptAxis = 0;
refSide_DIFF_RminL_bySptAxis = 0;
% use the follwing one for impact of word order on item side effects (computes
% difference R-L so that positive equals stronger attraction to item of
% interest); activate word order IV above as well
byDtrSide_forWorderEffect = 0;
byDtrSideBySptAxis_forWorderEffect = 0;
byRefSide_forWorderEffect = 0;
byRefSideBySptAxis_forWorderEffect = 0;








% START TMP DELETE

% % for plotting histogram over mDev or AUC and looking for signs of
% % bimodality
% 
% aTmp.superSubplotTitle = 'Non-chosen item side ("correct" trials)';
% a.s.relevantBalancingColumn = a.s.resCols.nciVsRefVsComSide; % for considering chosen item in tgt color (dtr) position effect 
% a.s.expectedBalancingValues = 1:4;
% 
% % a.s.ivs{end+1,a.s.ivsCols.name } = 'COM side (rtdp)';
% % a.s.ivs{end,a.s.ivsCols.style } = '';
% % a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.comSide;
% % a.s.ivs{end,a.s.ivsCols.values} = [1;2];
% % a.s.ivs{end,a.s.ivsCols.valLabels} = {'CoM left of dir. path'; 'CoM right of dir path'};
% % a.s.ivs{end,a.s.ivsCols.useVal} = [1;0];
% % a.s.ivs{end,a.s.ivsCols.diffs} = [];
% % %a.s.ivs{end,a.s.ivsCols.doMirror} = [0;1];
% % a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
% % a.s.ivs{end,a.s.ivsCols.joinVals} = {};
% % a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
% 
% a.s.ivs{end+1,a.s.ivsCols.name } = 'tgtpos';
% a.s.ivs{end,a.s.ivsCols.style } = 'subplotColumns';
% a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.tgtSlotDerived;
% a.s.ivs{end,a.s.ivsCols.values} = [1;2;3;4];
% a.s.ivs{end,a.s.ivsCols.valLabels} = {'1';'2';'3';'4'};
% a.s.ivs{end,a.s.ivsCols.useVal} = [1;1;1;1];
% a.s.ivs{end,a.s.ivsCols.diffs} = [];
% %a.s.ivs{end,a.s.ivsCols.doMirror} = [0;1];
% a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
% a.s.ivs{end,a.s.ivsCols.joinVals} = {};
% a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
% 
% a.s.ivs{end+1,a.s.ivsCols.name} = 'spatial term';
% a.s.ivs{end,a.s.ivsCols.style} = '';
% a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.spt;
% a.s.ivs{end,a.s.ivsCols.values} = [1;2;3;4];
% a.s.ivs{end,a.s.ivsCols.valLabels} = {'"links"','"rechts"','"über"','"unter"'};
% a.s.ivs{end,a.s.ivsCols.useVal} = [0;0;0;0];
% a.s.ivs{end,a.s.ivsCols.diffs} = [];
% %a.s.ivs{end,a.s.ivsCols.doMirror} = [0;1;0;0];
% a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0;0;0];
% a.s.ivs{end,a.s.ivsCols.joinVals} = {[3;4]};
% %a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2;3;4]};
% a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
% 
% % a.s.ivs{end+1,a.s.ivsCols.name } = 'dtr.side rel. to dir.path';
% % a.s.ivs{end,a.s.ivsCols.style } = 'lineColor';
% % a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.sideNonChosenToDirPath;
% % a.s.ivs{end,a.s.ivsCols.values} = [1;2];
% % a.s.ivs{end,a.s.ivsCols.valLabels} = {'Distr. left of direct path'; 'Distr. right of direct path'};
% % a.s.ivs{end,a.s.ivsCols.useVal} = [1;1];
% % a.s.ivs{end,a.s.ivsCols.diffs} = [];
% % %a.s.ivs{end,a.s.ivsCols.doMirror} = [0;1];
% % a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
% % a.s.ivs{end,a.s.ivsCols.joinVals} = {};
% % a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
% 
% a.s.ivs{end+1,a.s.ivsCols.name } = 'reference side (rtdp)';
% a.s.ivs{end,a.s.ivsCols.style } = 'lineColor';
% a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.refSide;
% a.s.ivs{end,a.s.ivsCols.values} = [1;2];
% a.s.ivs{end,a.s.ivsCols.valLabels} = {'ref left'; 'ref right'};
% a.s.ivs{end,a.s.ivsCols.useVal} = [1;1];
% a.s.ivs{end,a.s.ivsCols.diffs} = [];
% a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
% a.s.ivs{end,a.s.ivsCols.joinVals} = {};
% a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

% END TMP DELETE




% --- Specific comparisons
% (these are added to what has been specified above; activate only one block here)

if acrossAll_butBalanced
% All trajectories
aTmp.superSubplotTitle = 'All trajectories (target selected)';   
a.s.relevantBalancingColumn = a.s.resCols.absSideCategoryNciRefCom; % for overall balancing / comparisons against zero
a.s.expectedBalancingValues = 1:8;

end



if allBySptAxis
% All trajectories by SPT axis
aTmp.superSubplotTitle = 'All trajectories (target selected)';   
a.s.relevantBalancingColumn = a.s.resCols.absSideCategoryNciRefCom; % for overall balancing / comparisons against zero
a.s.expectedBalancingValues = 1:8;

a.s.ivs{end+1,a.s.ivsCols.name} = 'spatial term';
a.s.ivs{end,a.s.ivsCols.style} = 'subplotColumns';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.spt;
a.s.ivs{end,a.s.ivsCols.values} = [1;2;3;4];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'"links"','"rechts"','"über"','"unter"'};
a.s.ivs{end,a.s.ivsCols.useVal} = [0;0;0;0];
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0;0;0];
%a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2];[3;4]};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
%
end



if byDtrSide
% distracter side, across all else   
aTmp.superSubplotTitle = 'Non-chosen item side ("correct" trials)';
a.s.relevantBalancingColumn = a.s.resCols.nciVsRefVsComSide; % for considering chosen item in tgt color (dtr) position effect 
a.s.expectedBalancingValues = 1:4;

a.s.ivs{end+1,a.s.ivsCols.name } = 'dtr.side rel. to dir.path';
a.s.ivs{end,a.s.ivsCols.style } = 'lineColor';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.sideNonChosenToDirPath;
a.s.ivs{end,a.s.ivsCols.values} = [1;2];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'Distr. left of direct path'; 'Distr. right of direct path'};
a.s.ivs{end,a.s.ivsCols.useVal} = [1;1];
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
end

if byDtrSide_forWorderEffect
% distracter side, across all else   
aTmp.superSubplotTitle = 'Non-chosen item side ("correct" trials)';
a.s.relevantBalancingColumn = a.s.resCols.nciVsRefVsComSide; % for considering chosen item in tgt color (dtr) position effect 
a.s.expectedBalancingValues = 1:4;

a.s.ivs{end+1,a.s.ivsCols.name } = 'dtr.side rel. to dir.path';
a.s.ivs{end,a.s.ivsCols.style } = '';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.sideNonChosenToDirPath;
a.s.ivs{end,a.s.ivsCols.values} = [1;2];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'Distr. left of dir. path'; 'Distr. right of dir. path'};
%a.s.ivs{end,a.s.ivsCols.useVal} = [1;1];
%a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.useVal} = [0;0];
a.s.ivs{end,a.s.ivsCols.diffs} = [2,1];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
end

if byDtrSideBySptAxis
% distracter side by horizontal vs. vertical spatial terms, across all else
aTmp.superSubplotTitle = 'Dtr side by spatial term axis ("correct" trials)';
a.s.relevantBalancingColumn = a.s.resCols.nciVsRefVsComSide; % for considering chosen item in tgt color (dtr) position effect 
a.s.expectedBalancingValues = 1:4;

a.s.ivs{end+1,a.s.ivsCols.name } = 'dtr.side rel. to dir.path';
a.s.ivs{end,a.s.ivsCols.style } = 'lineColor';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.sideNonChosenToDirPath;
a.s.ivs{end,a.s.ivsCols.values} = [1;2];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'Distr. left of dir. path'; 'Distr. right of dir. path'};
a.s.ivs{end,a.s.ivsCols.useVal} = [1;1];
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

a.s.ivs{end+1,a.s.ivsCols.name} = 'spatial term';
a.s.ivs{end,a.s.ivsCols.style} = 'subplotColumns';
%a.s.ivs{end,a.s.ivsCols.style} = '';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.spt;
a.s.ivs{end,a.s.ivsCols.values} = [1;2;3;4];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'"links"','"rechts"','"über"','"unter"'};
a.s.ivs{end,a.s.ivsCols.useVal} = [0;0;0;0]; 
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0;0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2];[3;4]};   % usual "by spt axis"
%a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2]};   % only left&right
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
end


if byDtrSideBySptAxis_forWorderEffect
% distracter side by horizontal vs. vertical spatial terms, across all else
aTmp.superSubplotTitle = 'Dtr side by spatial term axis ("correct" trials)';
a.s.relevantBalancingColumn = a.s.resCols.nciVsRefVsComSide; % for considering chosen item in tgt color (dtr) position effect 
a.s.expectedBalancingValues = 1:4;

a.s.ivs{end+1,a.s.ivsCols.name } = 'dtr.side rel. to dir.path';
a.s.ivs{end,a.s.ivsCols.style } = '';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.sideNonChosenToDirPath;
a.s.ivs{end,a.s.ivsCols.values} = [1;2];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'Distr. left of dir. path'; 'Distr. right of dir. path'};
%a.s.ivs{end,a.s.ivsCols.useVal} = [1;1];
%a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.useVal} = [0;0];
a.s.ivs{end,a.s.ivsCols.diffs} = [2,1];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

a.s.ivs{end+1,a.s.ivsCols.name} = 'spatial term';
a.s.ivs{end,a.s.ivsCols.style} = 'subplotColumns';
%a.s.ivs{end,a.s.ivsCols.style} = '';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.spt;
a.s.ivs{end,a.s.ivsCols.values} = [1;2;3;4];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'"links"','"rechts"','"über"','"unter"'};
a.s.ivs{end,a.s.ivsCols.useVal} = [0;0;0;0]; 
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0;0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2];[3;4]};   % usual "by spt axis"
%a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2]};   % only left&right
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
end


if byRefSide
% Effect of ref side, overall
aTmp.superSubplotTitle = 'Effect of ref side, overall';   
a.s.relevantBalancingColumn = a.s.resCols.refVsComVsNciSide; % for considering reference position effect
a.s.expectedBalancingValues = 1:4;

a.s.ivs{end+1,a.s.ivsCols.name } = 'reference side (rtdp)';
a.s.ivs{end,a.s.ivsCols.style } = 'lineColor';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.refSide;
a.s.ivs{end,a.s.ivsCols.values} = [1;2];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'ref left'; 'ref right'};
a.s.ivs{end,a.s.ivsCols.useVal} = [1;1];
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0; 0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
end

if byRefSide_forWorderEffect
% Effect of ref side, overall
aTmp.superSubplotTitle = 'Effect of ref side, overall';   
a.s.relevantBalancingColumn = a.s.resCols.refVsComVsNciSide; % for considering reference position effect
a.s.expectedBalancingValues = 1:4;

a.s.ivs{end+1,a.s.ivsCols.name } = 'reference side (rtdp)';
a.s.ivs{end,a.s.ivsCols.style } = '';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.refSide;
a.s.ivs{end,a.s.ivsCols.values} = [1;2];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'ref left'; 'ref right'};
a.s.ivs{end,a.s.ivsCols.useVal} = [0;0];
a.s.ivs{end,a.s.ivsCols.diffs} = [2,1];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0; 0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
end

if byRefSideBySptAxis
% Effect of ref side, by spatial term main axis
aTmp.superSubplotTitle = 'Effect of ref side, by spatial term main direction';    
a.s.relevantBalancingColumn = a.s.resCols.refVsComVsNciSide; % for considering reference position effect
a.s.expectedBalancingValues = 1:4;

a.s.ivs{end+1,a.s.ivsCols.name } = 'reference side (rtdp)';
a.s.ivs{end,a.s.ivsCols.style } = 'lineColor';
%a.s.ivs{end,a.s.ivsCols.style } = '';
%a.s.ivs{end,a.s.ivsCols.style } = 'subplotRows';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.refSide;
a.s.ivs{end,a.s.ivsCols.values} = [1;2];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'ref left'; 'ref right'};
a.s.ivs{end,a.s.ivsCols.useVal} = [1;1];
%a.s.ivs{end,a.s.ivsCols.diffs} = [2,1];
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

a.s.ivs{end+1,a.s.ivsCols.name} = 'spatial term';
a.s.ivs{end,a.s.ivsCols.style} = 'subplotColumns';
%a.s.ivs{end,a.s.ivsCols.style} = '';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.spt;
a.s.ivs{end,a.s.ivsCols.values} = [1;2;3;4];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'"links"','"rechts"','"über"','"unter"'};
a.s.ivs{end,a.s.ivsCols.useVal} = [0;0;0;0]; 
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0;0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2];[3;4]};   % usual "by spt axis"
%a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2]};   % only left&right
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

end

if byRefSideBySptAxis_forWorderEffect
% Effect of ref side, by spatial term main axis
aTmp.superSubplotTitle = 'Effect of ref side, by spatial term main direction';    
a.s.relevantBalancingColumn = a.s.resCols.refVsComVsNciSide; % for considering reference position effect
a.s.expectedBalancingValues = 1:4;

a.s.ivs{end+1,a.s.ivsCols.name } = 'reference side (rtdp)';
a.s.ivs{end,a.s.ivsCols.style } = '';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.refSide;
a.s.ivs{end,a.s.ivsCols.values} = [1;2];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'ref left'; 'ref right'};
a.s.ivs{end,a.s.ivsCols.useVal} = [0;0];
a.s.ivs{end,a.s.ivsCols.diffs} = [2,1];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

a.s.ivs{end+1,a.s.ivsCols.name} = 'spatial term';
a.s.ivs{end,a.s.ivsCols.style} = 'subplotColumns';
%a.s.ivs{end,a.s.ivsCols.style} = '';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.spt;
a.s.ivs{end,a.s.ivsCols.values} = [1;2;3;4];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'"links"','"rechts"','"über"','"unter"'};
a.s.ivs{end,a.s.ivsCols.useVal} = [0;0;0;0]; 
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0;0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2];[3;4]};   % usual "by spt axis"
%a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2]};   % only left&right
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

end


% -----------------------------


if 0
% Effect of COM side, overall
aTmp.superSubplotTitle = 'Effect of COM side, overall';    
a.s.relevantBalancingColumn = a.s.resCols.comVsRefVsNciSide; % for considering COM position effect
a.s.expectedBalancingValues = 1:4;

a.s.ivs{end+1,a.s.ivsCols.name } = 'COM side (rtdp)';
a.s.ivs{end,a.s.ivsCols.style } = 'lineColor';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.comSide;
a.s.ivs{end,a.s.ivsCols.values} = [1;2];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'CoM left of dir. path'; 'CoM right of dir path'};
a.s.ivs{end,a.s.ivsCols.useVal} = [1;1];
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0; 0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
end



if 0
% Effect of COM side by spatial term main axis
aTmp.superSubplotTitle = 'Effect of COM side by spatial term';
a.s.relevantBalancingColumn = a.s.resCols.comVsRefVsNciSide; % for considering position effect
a.s.expectedBalancingValues = 1:4;
    
a.s.ivs{end+1,a.s.ivsCols.name } = 'COM side (rtdp)';
a.s.ivs{end,a.s.ivsCols.style } = 'lineColor';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.comSide;
a.s.ivs{end,a.s.ivsCols.values} = [1;2];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'com left'; 'com right'};
a.s.ivs{end,a.s.ivsCols.useVal} = [1;1];
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0; 0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
 
a.s.ivs{end+1,a.s.ivsCols.name} = 'spatial term';
a.s.ivs{end,a.s.ivsCols.style} = 'subplotColumns';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.spt;
a.s.ivs{end,a.s.ivsCols.values} = [1;2;3;4];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'"links"','"rechts"','"über"','"unter"'};
a.s.ivs{end,a.s.ivsCols.useVal} = [0;0;0;0];
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0;0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2];[3;4]};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
end
   

if dtrSide_DIFF_RminL_bySptAxis
aTmp.superSubplotTitle = 'Dtr side by spatial term axis ("correct" trials)';
a.s.relevantBalancingColumn = a.s.resCols.nciVsRefVsComSide; % for considering chosen item in tgt color (dtr) position effect 
a.s.expectedBalancingValues = 1:4;

a.s.ivs{end+1,a.s.ivsCols.name } = 'dtr.side rel. to dir.path';
a.s.ivs{end,a.s.ivsCols.style } = 'lineColor';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.sideNonChosenToDirPath;
a.s.ivs{end,a.s.ivsCols.values} = [1;2];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'Distr. left of dir. path'; 'Distr. right of dir. path'};
a.s.ivs{end,a.s.ivsCols.useVal} = [0;0];
a.s.ivs{end,a.s.ivsCols.diffs} = [2,1];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

a.s.ivs{end+1,a.s.ivsCols.name} = 'spatial term';
a.s.ivs{end,a.s.ivsCols.style} = 'subplotColumns';
%a.s.ivs{end,a.s.ivsCols.style} = '';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.spt;
a.s.ivs{end,a.s.ivsCols.values} = [1;2;3;4];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'"links"','"rechts"','"über"','"unter"'};
a.s.ivs{end,a.s.ivsCols.useVal} = [0;0;0;0]; 
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0;0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2];[3;4]};   % usual "by spt axis"
%a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2]};   % only left&right
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
end


if refSide_DIFF_RminL_bySptAxis
% Effect of ref side, by spatial term main axis
aTmp.superSubplotTitle = 'Effect of ref side, by spatial term main direction';    
a.s.relevantBalancingColumn = a.s.resCols.refVsComVsNciSide; % for considering reference position effect
a.s.expectedBalancingValues = 1:4;

a.s.ivs{end+1,a.s.ivsCols.name } = 'reference side (rtdp)';
a.s.ivs{end,a.s.ivsCols.style } = 'lineColor';
%a.s.ivs{end,a.s.ivsCols.style } = '';
%a.s.ivs{end,a.s.ivsCols.style } = 'subplotRows';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.refSide;
a.s.ivs{end,a.s.ivsCols.values} = [1;2];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'ref left'; 'ref right'};
a.s.ivs{end,a.s.ivsCols.useVal} = [0;0];
a.s.ivs{end,a.s.ivsCols.diffs} = [2,1];
%a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

a.s.ivs{end+1,a.s.ivsCols.name} = 'spatial term';
a.s.ivs{end,a.s.ivsCols.style} = 'subplotColumns';
%a.s.ivs{end,a.s.ivsCols.style} = '';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.spt;
a.s.ivs{end,a.s.ivsCols.values} = [1;2;3;4];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'"links"','"rechts"','"über"','"unter"'};
a.s.ivs{end,a.s.ivsCols.useVal} = [0;0;0;0]; 
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0;0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2];[3;4]};   % usual "by spt axis"
%a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2]};   % only left&right
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

end

    
clearvars -except a e tg aTmp