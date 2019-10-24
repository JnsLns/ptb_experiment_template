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
    %a.s.ivs{end,a.s.ivsCols.useVal} = [1 1 1]';
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
% a.s.ivs{end,a.s.ivsCols.style } = 'subplotColumns';
% a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.curvatureBin;
% a.s.ivs{end,a.s.ivsCols.values} = (1:numel(a.s.curvatureBinsUpperBounds))';
% a.s.ivs{end,a.s.ivsCols.valLabels} = cellfun(@(numLabel) num2str(numLabel), num2cell(a.s.curvatureBinsUpperBounds), 'uniformoutput',0)';
% a.s.ivs{end,a.s.ivsCols.useVal} = ones(1,numel(a.s.curvatureBinsUpperBounds));
% a.s.ivs{end,a.s.ivsCols.diffs} = [];
% a.s.ivs{end,a.s.ivsCols.doMirror} = zeros(1,numel(a.s.curvatureBinsUpperBounds))';
% a.s.ivs{end,a.s.ivsCols.joinVals} = {};
% a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

% exclude trials that were aborted due to exceeding allowed movement time
% a.s.ivs{end+1,a.s.ivsCols.name } = 'aborted due to exceeding max. MT';
% a.s.ivs{end,a.s.ivsCols.style } = '';
% a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.maxMTExceeded;
% a.s.ivs{end,a.s.ivsCols.values} = [0;1];
% a.s.ivs{end,a.s.ivsCols.valLabels} = {'within max MT';'exceeded max MT'};
% a.s.ivs{end,a.s.ivsCols.useVal} = [1;0];
% a.s.ivs{end,a.s.ivsCols.diffs} = [];
% a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
% a.s.ivs{end,a.s.ivsCols.joinVals} = {};
% a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

% DELETE THIS!!!!!!!! (BELOW)
% %second pair side (i.e., ref2 side) by addItem condition
% a.s.relevantBalancingColumn = a.s.resCols.pair2VsRef1VsComSide_ana; 
% a.s.expectedBalancingValues = 1:4;
% a.s.balancingLegendEntries = {'r1s/cs','r1s/co','r1o/cs','r1o/co'};
% 
% a.s.ivs{end+1,a.s.ivsCols.name } = 'pair2 side rel. to dir.path';
% a.s.ivs{end,a.s.ivsCols.style } = '';
% a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.ref2Side;
% a.s.ivs{end,a.s.ivsCols.values} = [1;2];
% a.s.ivs{end,a.s.ivsCols.valLabels} = {'Pair2 left of dir. path'; 'Pair2 right of dir. path'};
% a.s.ivs{end,a.s.ivsCols.useVal} = [0;0];
% a.s.ivs{end,a.s.ivsCols.diffs} = [2,1]; 
% a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
% a.s.ivs{end,a.s.ivsCols.joinVals} = {};
% a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
% 
% a.s.ivs{end+1,a.s.ivsCols.name} = 'add. item condition';
% a.s.ivs{end,a.s.ivsCols.style} = 'lineColor';
% a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.additionalItemCondition;
% a.s.ivs{end,a.s.ivsCols.values} = [1;2;3;4];
% a.s.ivs{end,a.s.ivsCols.valLabels} = {'fullPair2','onlyRef2','onlyDtr','onlyPair1'};
% a.s.ivs{end,a.s.ivsCols.useVal} = [1;1;1;1]; 
% a.s.ivs{end,a.s.ivsCols.diffs} = [];
% a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0;0;0];
% a.s.ivs{end,a.s.ivsCols.joinVals} = {};
% a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
% DELETE THIS!!!!! (ABOVE)

% basic 2 pair analysis
if 0
% second pair side (i.e., ref2 side) by addItem condition
aTmp.superSubplotTitle = 'Pair2 side by addItemCondition ("correct" trials)';
a.s.relevantBalancingColumn = a.s.resCols.pair2VsRef1VsComSide_ana; 
a.s.expectedBalancingValues = 1:4;
a.s.balancingLegendEntries = {'r1s/cs','r1s/co','r1o/cs','r1o/co'};

a.s.ivs{end+1,a.s.ivsCols.name } = 'pair2 side rel. to dir.path';
a.s.ivs{end,a.s.ivsCols.style } = 'lineColor';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.ref2Side;
a.s.ivs{end,a.s.ivsCols.values} = [1;2];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'Pair2 left of dir. path'; 'Pair2 right of dir. path'};
a.s.ivs{end,a.s.ivsCols.useVal} = [0;0];
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.diffs} = [2,1]; 
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
%a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2]};
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

a.s.ivs{end+1,a.s.ivsCols.name} = 'add. item condition';
a.s.ivs{end,a.s.ivsCols.style} = 'subplotColumns';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.additionalItemCondition;
a.s.ivs{end,a.s.ivsCols.values} = [1;2;3;4];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'fullPair2','onlyRef2','onlyDtr','onlyPair1'};
a.s.ivs{end,a.s.ivsCols.useVal} = [1;1;1;1]; 
a.s.ivs{end,a.s.ivsCols.diffs} = [];
%a.s.ivs{end,a.s.ivsCols.diffs} = [1,3;2,4]; % interaction ref*dtr presence (effect of ref for dtr pres and abs)
%a.s.ivs{end,a.s.ivsCols.diffs} = [1,2;3,4]; % interaction ref*dtr presence (effect of dtr for ref pres and abs)
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0;0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
%a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;3];[2;4]}; % distractor main effect
%a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2];[3;4]}; % reference main effect
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

end

% for computing overall movement time (i.e., across pair B side, as reported in 2019 paper)
% Also used for movement time 2x2 RM ANOVA 
% mean movement time over pair B left/right
if 1
% second pair side (i.e., ref2 side) by addItem condition
aTmp.superSubplotTitle = 'Pair2 side by addItemCondition ("correct" trials)';
a.s.relevantBalancingColumn = a.s.resCols.pair2VsRef1VsComSide_ana; 
a.s.expectedBalancingValues = 1:4;
a.s.balancingLegendEntries = {'r1s/cs','r1s/co','r1o/cs','r1o/co'};

% a.s.ivs{end+1,a.s.ivsCols.name } = 'pair2 side rel. to dir.path';
% a.s.ivs{end,a.s.ivsCols.style } = 'lineColor';
% a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.ref2Side;
% a.s.ivs{end,a.s.ivsCols.values} = [1;2];
% a.s.ivs{end,a.s.ivsCols.valLabels} = {'Pair2 left of dir. path'; 'Pair2 right of dir. path'};
% a.s.ivs{end,a.s.ivsCols.useVal} = [0;0];
% a.s.ivs{end,a.s.ivsCols.diffs} = [];
% a.s.ivs{end,a.s.ivsCols.diffs} = []; 
% a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
% %a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2]};
% a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2]};
% a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

a.s.ivs{end+1,a.s.ivsCols.name} = 'add. item condition';
a.s.ivs{end,a.s.ivsCols.style} = 'subplotColumns';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.additionalItemCondition;
a.s.ivs{end,a.s.ivsCols.values} = [1;2;3;4];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'fullPair2','onlyRef2','onlyDtr','onlyPair1'};
a.s.ivs{end,a.s.ivsCols.useVal} = [1;1;1;1]; 
a.s.ivs{end,a.s.ivsCols.diffs} = [];
%a.s.ivs{end,a.s.ivsCols.diffs} = [1,3;2,4]; % interaction ref*dtr presence (effect of ref for dtr pres and abs)
%a.s.ivs{end,a.s.ivsCols.diffs} = [1,2;3,4]; % interaction ref*dtr presence (effect of dtr for ref pres and abs)
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0;0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
%a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;3];[2;4]}; % distractor main effect
%a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2];[3;4]}; % reference main effect
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

end

% TEMPORARY 
if 0
aTmp.superSubplotTitle = 'Effect of ref1 side, overall';   
aTmp.superSubplotTitle = 'Effect of ref1 side, overall';   

a.s.relevantBalancingColumn = a.s.resCols.ref1VsPair2VsComSide; % for considering reference position effect
a.s.expectedBalancingValues = 1:4;
a.s.balancingLegendEntries = {'rs/cs','rs/co','ro/cs','ro/co'};

%a.s.relevantBalancingColumn = a.s.resCols.ref1ComSame;
%a.s.expectedBalancingValues = 0:1;
%a.s.balancingLegendEntries = {'cs','cd'};

a.s.ivs{end+1,a.s.ivsCols.name } = 'reference 1 side (rtdp)';
a.s.ivs{end,a.s.ivsCols.style } = 'lineColor';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.ref1Side;
a.s.ivs{end,a.s.ivsCols.values} = [1;2];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'ref left'; 'ref right'};
a.s.ivs{end,a.s.ivsCols.useVal} = [1;1];
%a.s.ivs{end,a.s.ivsCols.diffs} = [2,1];
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
 
% a.s.ivs{end+1,a.s.ivsCols.name } = 'ref1Ref2Same';
% a.s.ivs{end,a.s.ivsCols.style } = 'figures';
% a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.ref1Ref2Same;
% a.s.ivs{end,a.s.ivsCols.values} = [0;1];
% a.s.ivs{end,a.s.ivsCols.valLabels} = {'ref1Ref2Diff'; 'ref1Ref2Same'};
% a.s.ivs{end,a.s.ivsCols.useVal} = [1;1];
% a.s.ivs{end,a.s.ivsCols.diffs} = [];
% a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
% a.s.ivs{end,a.s.ivsCols.joinVals} = {};
% a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;

a.s.ivs{end+1,a.s.ivsCols.name} = 'add. item condition';
a.s.ivs{end,a.s.ivsCols.style} = 'subplotColumns';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.additionalItemCondition;
a.s.ivs{end,a.s.ivsCols.values} = [1;2;3;4];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'fullPair2','onlyRef2','onlyDtr','onlyPair1'};
a.s.ivs{end,a.s.ivsCols.useVal} = [1;1;1;1]; 
%a.s.ivs{end,a.s.ivsCols.diffs} = [1,4;2,4;3,4];
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0;0;0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};   
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
end
% TEMPORARY ----


% --- Specific comparisons
% (these are added to what has been specified above; activate only one block here)


if 0
% All trajectories
aTmp.superSubplotTitle = 'All trajectories (target selected)';   
a.s.relevantBalancingColumn = a.s.resCols.absSideCategoryPair2Ref1Com; % for overall balancing / comparisons against zero
a.s.expectedBalancingValues = 1:8;
%
end



if 0
% All trajectories by SPT axis
aTmp.superSubplotTitle = 'All trajectories (target selected)';   
a.s.relevantBalancingColumn = a.s.resCols.absSideCategoryPair2Ref1Com; % for overall balancing / comparisons against zero
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


if 0
% Effect of ref side, overall
aTmp.superSubplotTitle = 'Effect of ref1 side, overall';   
a.s.relevantBalancingColumn = a.s.resCols.ref1VsPair2VsComSide; % for considering reference position effect
a.s.expectedBalancingValues = 1:4;

a.s.ivs{end+1,a.s.ivsCols.name } = 'reference 1 side (rtdp)';
a.s.ivs{end,a.s.ivsCols.style } = 'lineColor';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.ref1Side;
a.s.ivs{end,a.s.ivsCols.values} = [1;2];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'ref left'; 'ref right'};
a.s.ivs{end,a.s.ivsCols.useVal} = [1;1];
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0; 0];
a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
end


if 0
% Effect of ref side, by spatial term main axis
aTmp.superSubplotTitle = 'Effect of ref1 side, overall';   
a.s.relevantBalancingColumn = a.s.resCols.ref1VsPair2VsComSide; % for considering reference position effect
a.s.expectedBalancingValues = 1:4;

a.s.ivs{end+1,a.s.ivsCols.name } = 'reference 1 side (rtdp)';
a.s.ivs{end,a.s.ivsCols.style } = 'lineColor';
a.s.ivs{end,a.s.ivsCols.rsCol} = a.s.resCols.ref1Side;
a.s.ivs{end,a.s.ivsCols.values} = [1;2];
a.s.ivs{end,a.s.ivsCols.valLabels} = {'ref left'; 'ref right'};
a.s.ivs{end,a.s.ivsCols.useVal} = [1;1];
a.s.ivs{end,a.s.ivsCols.diffs} = [];
a.s.ivs{end,a.s.ivsCols.doMirror} = [0;0];
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
%a.s.ivs{end,a.s.ivsCols.joinVals} = {};
a.s.ivs{end,a.s.ivsCols.joinVals} = {[1;2];[3;4]};
a.s.ivs{end,a.s.ivsCols.subtractOverallMean} = 0;
end



if 0
% Effect of COM side, overall
aTmp.superSubplotTitle = 'Effect of COM side, overall';    
a.s.relevantBalancingColumn = a.s.resCols.comVsRef1VsPair2Side; % for considering COM position effect
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
aTmp.superSubplotTitle = 'Effect of COM side, overall';    
a.s.relevantBalancingColumn = a.s.resCols.comVsRef1VsPair2Side; % for considering COM position effect
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
   
    
clearvars -except a e tg aTmp