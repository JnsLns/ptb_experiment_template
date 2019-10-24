% IMPORTANT NOTE 1: This script must be run AFTER prepareTrajs, as it is
% partly based on item coordinates that are transformed in the latter (and
% coordinates used to compute values here are taken from aTmp.rsTransformed,
% which are translated/rotated regardless of whether translation/rotation
% is enabled or disabled in settings (in contrast to data in a.rs which
% adheres to the settings)).



disp('Computing new results values (except max. curvature) ...');

%% Compute values for new columns

% --- vv the following depends on translation/rotation performed in prepareTrajs vv ---

% note: use aTmp.rsTransformed (made in prepareTrajs) as basis instead of 
% a.rs, to allow for computing these things even if translation and/or 
% rotation are disabled.

% loop over result rows
for curRow = 1:size(a.rs,1)
    
    % signed distance of non-chosen (non-opposite) item in target color (usually
    % main distracter) from the straight path EITHER between first data point
    % of trajectory to last data point of trajectory (if a.s.chosenItemDefinesRefDir == 0)
    % OR between first data point of trajectory and center of item chosen
    % as repsonse in this trial (if a.s.chosenItemDefinesRefDir == 1);
    % positive = right, negative = left.
    if a.rs(curRow,a.s.resCols.tgt) == a.rs(curRow,a.s.resCols.chosen) % target was chosen --> use dtr position
        a.rs(curRow,a.s.resCols.distNonChosenToDirPath) = aTmp.rsTransformed(curRow,a.s.resCols.horzPosStart-1+a.rs(curRow,a.s.resCols.dtr));
    elseif a.rs(curRow,a.s.resCols.dtr) == a.rs(curRow,a.s.resCols.chosen) % main distracter was chosen --> use tgt position
        a.rs(curRow,a.s.resCols.distNonChosenToDirPath) = aTmp.rsTransformed(curRow,a.s.resCols.horzPosStart-1+a.rs(curRow,a.s.resCols.tgt));
    else % another item was chosen -- > NaN
        a.rs(curRow,a.s.resCols.distNonChosenToDirPath) = NaN;
    end
    
    % side of non-chosen (non-opposite) item in target color (usually
    % main distracter) from the straight path between first data point of
    % trajectory to last data point of trajectory; 1 = left, 2 = right;
    if a.rs(curRow,a.s.resCols.distNonChosenToDirPath) < 0   % left
        a.rs(curRow,a.s.resCols.sideNonChosenToDirPath) = 1;
    elseif a.rs(curRow,a.s.resCols.distNonChosenToDirPath) > 0  % right
        a.rs(curRow,a.s.resCols.sideNonChosenToDirPath) = 2;
    end
    
    % reference side relative to direct path to target (1 = left, 2 = right)
    a.rs(curRow,a.s.resCols.ref1Side) = 1.5 + sign(aTmp.rsTransformed(curRow,a.s.resCols.horzPosStart-1+a.rs(curRow,a.s.resCols.ref)))/2;
    
    % reference 2 side relative to direct path to target (1 = left, 2 = right)
    a.rs(curRow,a.s.resCols.ref2Side) = 1.5 + sign(aTmp.rsTransformed(curRow,a.s.resCols.horzPosStart-1+a.rs(curRow,a.s.resCols.ref2)))/2;
    
    % Center of Mass side relative to direct Path to target (1 = left, 2 = right)
    curItemSet_xy = [aTmp.rsTransformed(curRow,a.s.resCols.horzPosStart:a.s.resCols.horzPosEnd)',aTmp.rsTransformed(curRow,a.s.resCols.vertPosStart:a.s.resCols.vertPosEnd)'];
    curComPos = round(sum(curItemSet_xy)/size(curItemSet_xy,1));
    a.rs(curRow,a.s.resCols.comSide) = 1.5 + sign(curComPos(1))/2;
    
end

% --- ^^ the above depends on translation/rotation performed in prepareTrajs ^^ ---
    
% --- stuff for balancing

% Assess relation ref, com, and ref2 (i.e. which should be same side as whole pair 2, i.e., also dtr)
% in terms of whether (1) or not (0) they are on the same side of the direct path to
% the target
% a.s.resCols.ref1Side / a.s.resCols.comSide
a.rs(:,a.s.resCols.ref1ComSame) = (a.rs(:,a.s.resCols.ref1Side) == a.rs(:,a.s.resCols.comSide));
% a.s.resCols.ref1Side / a.s.resCols.ref2Side
a.rs(:,a.s.resCols.ref1Ref2Same) = (a.rs(:,a.s.resCols.ref1Side) == a.rs(:,a.s.resCols.ref2Side));
% a.s.resCols.comSide / a.s.resCols.ref2Side
a.rs(:,a.s.resCols.comRef2Same) = (a.rs(:,a.s.resCols.comSide) == a.rs(:,a.s.resCols.ref2Side));

% From the above, compute categories out of the relevant columns for the
% purpose of considering isolated effect of either ref, com, or dtr side:
% For considering effects of pair 2:
a.rs(a.rs(:,a.s.resCols.ref1Ref2Same)==1 & a.rs(:,a.s.resCols.comRef2Same)==1, a.s.resCols.pair2VsRef1VsComSide_ana) = 1; % 1: ref1 same, com same
a.rs(a.rs(:,a.s.resCols.ref1Ref2Same)==1 & a.rs(:,a.s.resCols.comRef2Same)==0, a.s.resCols.pair2VsRef1VsComSide_ana) = 2; % 2: ref1 same, com oppo
a.rs(a.rs(:,a.s.resCols.ref1Ref2Same)==0 & a.rs(:,a.s.resCols.comRef2Same)==1, a.s.resCols.pair2VsRef1VsComSide_ana) = 3; % 3: ref1 oppo, com same
a.rs(a.rs(:,a.s.resCols.ref1Ref2Same)==0 & a.rs(:,a.s.resCols.comRef2Same)==0, a.s.resCols.pair2VsRef1VsComSide_ana) = 4; % 4: ref1 oppo, com oppo
% For considering effects of COM side:
a.rs(a.rs(:,a.s.resCols.ref1ComSame)==1 & a.rs(:,a.s.resCols.comRef2Same)==1, a.s.resCols.comVsRef1VsPair2Side) = 1; % 1: ref1 same, pair2 same
a.rs(a.rs(:,a.s.resCols.ref1ComSame)==1 & a.rs(:,a.s.resCols.comRef2Same)==0, a.s.resCols.comVsRef1VsPair2Side) = 2; % 2: ref1 same, pair2 oppo
a.rs(a.rs(:,a.s.resCols.ref1ComSame)==0 & a.rs(:,a.s.resCols.comRef2Same)==1, a.s.resCols.comVsRef1VsPair2Side) = 3; % 3: ref1 oppo, pair2 same
a.rs(a.rs(:,a.s.resCols.ref1ComSame)==0 & a.rs(:,a.s.resCols.comRef2Same)==0, a.s.resCols.comVsRef1VsPair2Side) = 4; % 4: ref1 oppo, pair2 oppo
% For considering effects of ref1 side
a.rs(a.rs(:,a.s.resCols.ref1Ref2Same)==1 & a.rs(:,a.s.resCols.ref1ComSame)==1, a.s.resCols.ref1VsPair2VsComSide) = 1; % 1: ref2 same, com same
a.rs(a.rs(:,a.s.resCols.ref1Ref2Same)==1 & a.rs(:,a.s.resCols.ref1ComSame)==0, a.s.resCols.ref1VsPair2VsComSide) = 2; % 2: ref2 same, com oppo
a.rs(a.rs(:,a.s.resCols.ref1Ref2Same)==0 & a.rs(:,a.s.resCols.ref1ComSame)==1, a.s.resCols.ref1VsPair2VsComSide) = 3; % 3: ref2 oppo, com same
a.rs(a.rs(:,a.s.resCols.ref1Ref2Same)==0 & a.rs(:,a.s.resCols.ref1ComSame)==0, a.s.resCols.ref1VsPair2VsComSide) = 4; % 4: ref2 oppo, com oppo
    
% balancing categories denoting this trial's combination of 
% sideNonChosenToDirPath * ref1Side * comSide;
% should be used for balancing in analysis across all these factors (e.g.,
% for pure "kinematic" effect).
% codes: 
% 0: occurs only for trials where item other than dtr or tgt were chosen
% 1: r2l, r1l, cl
% 2: r2r, r1l, cl
% 3: r2l, r1r, cl 
% 4: r2r, r1r, cl
% 5: r2l, r1l, cr
% 6: r2r, r1l, cr
% 7: r2l, r1r, cr 
% 8: r2r, r1r, cr
confusionAbsSidesCodes_tmp = zeros(2,2,2);
for curCodeVal = 1:numel(confusionAbsSidesCodes_tmp)
    subsNdx_tmp = ind2subAll(size(confusionAbsSidesCodes_tmp),curCodeVal);
    a.rs(a.rs(:,a.s.resCols.ref2Side)==subsNdx_tmp(1) & ...
         a.rs(:,a.s.resCols.ref1Side)==subsNdx_tmp(2) & ...
         a.rs(:,a.s.resCols.comSide)==subsNdx_tmp(3), ...
         a.s.resCols.absSideCategoryPair2Ref1Com) = curCodeVal;
end


% --- fit-related stuff

% below/above median coding for fit of main distracter 1 = below/same; 2 = above
allDtrFits = a.rs(sub2ind(size(a.rs),1:size(a.rs,1), a.s.resCols.fitsStart-1+a.rs(:,a.s.resCols.dtr)'));
a.rs(:,a.s.resCols.dtrFitMedianSplit) = (allDtrFits > median(allDtrFits)) + 1;

% below/above median coding for fit of target 1 = below/same; 2 = above
allTgtFits = a.rs(sub2ind(size(a.rs),1:size(a.rs,1), a.s.resCols.fitsStart-1+a.rs(:,a.s.resCols.tgt)'));
a.rs(:,a.s.resCols.tgtFitMedianSplit) = (allTgtFits > median(allTgtFits)) + 1;

% below/above median coding for relative fit of main distracter (fit_dtr/fit_tgt)
% (uncomment fit extraction if removing above code lines)
%allDtrFits = a.rs(sub2ind(size(a.rs),1:size(a.rs,1), a.s.resCols.fitsStart-1+a.rs(:,a.s.resCols.dtr)'));
%allTgtFits = a.rs(sub2ind(size(a.rs),1:size(a.rs,1), a.s.resCols.fitsStart-1+a.rs(:,a.s.resCols.tgt)'));
allRelFits = allDtrFits./allTgtFits;
a.rs(:,a.s.resCols.relFitMedianSplit) = (allRelFits > median(allRelFits)) + 1;

% below/above median coding for fit difference target minus dtr fit; 1 = below/same; 2 = above
allFitDiffs = allTgtFits-allDtrFits;
a.rs(:,a.s.resCols.fitDifMedianSplit) = (allFitDiffs > median(allFitDiffs)) + 1;

% maximum curvature threshold exceeded? 1: exceeded 0: not exceeded
a.rs(:,a.s.resCols.exceedsCurveThresh) = a.rs(:,a.s.resCols.maxCurvature) > a.s.curvatureCutoff;

% sort trajectories into curvature bins based on max curvature in each
% trajectory. curvature sizes depend on a.s.curvatureBinsUpperBounds. The
% first bin (code 1) holds trajectories with max curvature <= the first
% bin's upper bound, the second bin (code 2) those with max curvature > the
% first bound and <= the second bound, and so on...
for curBinNo = 1:numel(a.s.curvatureBinsUpperBounds)    
    curBinUpper = a.s.curvatureBinsUpperBounds(curBinNo);
    if curBinNo > 1
        curBinLower = a.s.curvatureBinsUpperBounds(curBinNo-1);
    else
        curBinLower = 0;
    end
    a.rs((a.rs(:,a.s.resCols.maxCurvature)<=curBinUpper & a.rs(:,a.s.resCols.maxCurvature)>curBinLower),a.s.resCols.curvatureBin) = curBinNo;
end

% target slot, derived from target position in a.rawDatBAK.rs
% (this is based on comparing trial IDs! ID duplicates should not hurt as long 
% as both trials have the same target position)
% Target slots are numbered left to right, top to bottom (e.g. with four slots, 
% upper left is 1, upper right is 2)
horzTgtSlots = sortrows(unique(a.rawDatBAK.rs(:,a.s.resCols.horzPosStart-1+a.rawDatBAK.rs(1,a.s.resCols.tgt))));
vertTgtSlots = sortrows(unique(a.rawDatBAK.rs(:,a.s.resCols.vertPosStart-1+a.rawDatBAK.rs(1,a.s.resCols.tgt))),-1);
a.s.tgtSlotCodes = zeros(numel(horzTgtSlots),numel(vertTgtSlots));
a.s.tgtSlotCodes(1:end) = 1:numel(a.s.tgtSlotCodes);
a.s.tgtSlotCodes = a.s.tgtSlotCodes';
for curRow = 1:size(a.rs,1)
        
    % horizontal target pos in current trial
    curHorz = a.rawDatBAK.rs(curRow,a.s.resCols.horzPosStart-1+a.rawDatBAK.rs(curRow,a.s.resCols.tgt));
    % vertical target pos in current trial
    curVert = a.rawDatBAK.rs(curRow,a.s.resCols.vertPosStart-1+a.rawDatBAK.rs(curRow,a.s.resCols.tgt));
    % get code and store in results column        
    a.rs(a.rawDatBAK.rs(:,a.s.resCols.trialID)==a.rs(curRow,a.s.resCols.trialID),a.s.resCols.tgtSlotDerived) = ...
    a.s.tgtSlotCodes(find(vertTgtSlots==curVert),find(horzTgtSlots==curHorz));

end

clearvars -except a e tg aTmp