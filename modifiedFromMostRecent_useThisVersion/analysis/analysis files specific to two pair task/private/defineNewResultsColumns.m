
disp('Defining new results columns ...');

%% Define new columns in a.rs
% (these are mostly created/filled later in prepareResults.m, because trajectories
% must already be transformed for some)

% participants (already filled with participant tags above)
if ~isfield(a.s.resCols,'pts')
    a.s.resCols.pts = max(structfun(@(x) x,a.s.resCols))+1;
end
% distance of non-chosen item in target color from "ideal path" (neg: left, pos: right)
if ~isfield(a.s.resCols,'distNonChosenToDirPath')
    a.s.resCols.distNonChosenToDirPath = max(structfun(@(x) x,a.s.resCols))+1;
end
% side non-chosen item in target color relative to "ideal path" (1: left, 2: right)
if ~isfield(a.s.resCols,'sideNonChosenToDirPath')
    a.s.resCols.sideNonChosenToDirPath = max(structfun(@(x) x,a.s.resCols))+1;
end

% reference side relative to direct path to chosen item (0 = left, 1 = right)
if ~isfield(a.s.resCols,'ref1Side')
    a.s.resCols.ref1Side = max(structfun(@(x) x,a.s.resCols))+1;
end
% Center of Mass side relative to direct Path to chosen item (0 = left, 1 = right)
if ~isfield(a.s.resCols,'comSide')
    a.s.resCols.comSide = max(structfun(@(x) x,a.s.resCols))+1;
end
% reference 2 side relative to direct path to chosen item (0 = left, 1 = right)
if ~isfield(a.s.resCols,'ref2Side')
    a.s.resCols.ref2Side = max(structfun(@(x) x,a.s.resCols))+1;
end

% Relation ref,com, and non chosen item in target color in terms of
% whether (1) or not (0) they are on the same side of the direct path to
% the target:
if ~isfield(a.s.resCols,'ref1ComSame')
    a.s.resCols.ref1ComSame = max(structfun(@(x) x,a.s.resCols))+1;
end
if ~isfield(a.s.resCols,'ref1Ref2Same')
    a.s.resCols.ref1Ref2Same = max(structfun(@(x) x,a.s.resCols))+1;
end
if ~isfield(a.s.resCols,'comRef2Same')
    a.s.resCols.comRef2Same = max(structfun(@(x) x,a.s.resCols))+1;
end
% Computed from the above, categories denoting whether relevant positions are
% on the same or opposite side of the direct path compared to the position
% denoted first in the column label
if ~isfield(a.s.resCols,'pair2VsRef1VsComSide_ana')
    a.s.resCols.pair2VsRef1VsComSide_ana = max(structfun(@(x) x,a.s.resCols))+1; % For considering effects of pair 2 side
end
if ~isfield(a.s.resCols,'comVsRef1VsPair2Side')
    a.s.resCols.comVsRef1VsPair2Side = max(structfun(@(x) x,a.s.resCols))+1; % For considering effects of COM side
end
if ~isfield(a.s.resCols,'ref1VsPair2VsComSide')
    a.s.resCols.ref1VsPair2VsComSide = max(structfun(@(x) x,a.s.resCols))+1; % For considering effects of NCI (non-chosen item in target color) side
end

% below/above median coding for fit of main distracter 1 = below/same; 2 = above
if ~isfield(a.s.resCols,'dtrFitMedianSplit')
    a.s.resCols.dtrFitMedianSplit = max(structfun(@(x) x,a.s.resCols))+1;
end
% below/above median coding for fit of chosen item 1 = below/same; 2 = above
if ~isfield(a.s.resCols,'tgtFitMedianSplit')
    a.s.resCols.tgtFitMedianSplit = max(structfun(@(x) x,a.s.resCols))+1;
end
% relative fit (fit_dtr/fit_tgt) above/below median coding 1 = below/same; 2 = above
if ~isfield(a.s.resCols,'relFitMedianSplit')
    a.s.resCols.relFitMedianSplit = max(structfun(@(x) x,a.s.resCols))+1;
end
% fit difference [fit_tgt - fit_dtr] above/below median coding 1 = below/same; 2 = above
if ~isfield(a.s.resCols,'fitDifMedianSplit')
    a.s.resCols.fitDifMedianSplit = max(structfun(@(x) x,a.s.resCols))+1;
end
% note: the median used for splitting is across all trajectories loaded into
% the analysis (and at this point there's nothing excluded yet, this makes
% sense, though, as the fits are not a dependent measure).

% maximum curvature in the trajectory
if ~isfield(a.s.resCols,'maxCurvature')
    a.s.resCols.maxCurvature = max(structfun(@(x) x,a.s.resCols))+1;
end
% maximum curvature threshold exceeded (1) or not (0)
if ~isfield(a.s.resCols,'exceedsCurveThresh')
    a.s.resCols.exceedsCurveThresh = max(structfun(@(x) x,a.s.resCols))+1;
end

% balancing categories denoting this trial's combination of
% pair2 * refSide * comSide (see prepareResults for codes);
% should be used for balancing in analysis across all these factors (e.g.,
% for pure "kinematic" effect).
if ~isfield(a.s.resCols,'absSideCategoryPair2Ref1Com')
    a.s.resCols.absSideCategoryPair2Ref1Com = max(structfun(@(x) x,a.s.resCols))+1;
end

% curvature bin
if ~isfield(a.s.resCols,'curvatureBin')
    a.s.resCols.curvatureBin = max(structfun(@(x) x,a.s.resCols))+1;
end

% target slot, derived from target position in a.rawDatBAK.rs
if ~isfield(a.s.resCols,'tgtSlotDerived')
    a.s.resCols.tgtSlotDerived = max(structfun(@(x) x,a.s.resCols))+1;
end

clearvars -except a e tg aTmp