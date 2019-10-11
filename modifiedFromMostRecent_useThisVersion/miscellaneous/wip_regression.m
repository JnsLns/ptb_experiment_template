
% Result: When testing for fitDif alone, the coefficient for fitDif is
% significant, but the estimate for it (slope) is positive, meaning that
% larger fitDif (tgt fits well compared to distracter) produces larger AUC.
% This is exactly the opposite to the hypothesis that bad fitting target
% and well fitting dtr lead to larger AUC in dtr direction.
% This could mean that fitDif is confounded with something else (distance?)
% that is responsible for the higher AUC with higher fitDif

% When testting for dtrFit and tgtFit and their interactions (should be
% similar to testing for fitDif, maybe? Although they might correlate
% somewhat...), everything is significant, especially dtrFit and the
% interaction are highly significant, but coefficients for both dtrFit and
% tgtFit are negative (which conforms to hypotheses in the tgtFit case but
% not in the dtrFit case)... again, it seems as if there might be some
% confounding dependency at work.

% All significances vanish when not normalizing AUC against dtrDist!

% Note: There may be outliers...

% all results as matrix
rsAll = rsIndiv{1};

aucAll = trIndivAUC{1};

% constraint categories recoded into ref side and com side
ccatAll = rsAll(:,resCols.constraintsCategory);
% ref side: 0 = oppo, 1 = same
refSideAll = zeros(length(ccatAll),1);
refSideAll(ccatAll==1 | ccatAll==2) = 1;
% com side: 0 = oppo, 1 = same
comSideAll = zeros(length(ccatAll),1);
comSideAll(ccatAll==1 | ccatAll==3) = 1;
% fit difference tgt-dtr
dtrFit = zscore(rsAll(:,resCols.dtrFit));  % NOTE Z SCORED!!!
tgtFit = zscore(rsAll(:,resCols.tgtFit)); 
dtrDist = rsAll(:,resCols.distNonChosenToDirPath); 
fitDif = rsAll(:,resCols.tgtMinDtrFit); 
mt = rsAll(:,resCols.movementTime_pc); 

% THE CLOU!!! Note: normalizing with dtr distance may cause significance
% simply due to dtr distance being useful as predictor, not because auc
% really is a useful predictor; on the other hand, using dtrDist as a
% predictor for normalized auc does not yield significance
% normalize AUC by distracter distance (since both non-absolute, also
% rectifies AUC to denote overall bias in dtr direction)
aucAll_perDtrDist =  aucAll./dtrDist;

% make table
allTrials = table(tgtFit,dtrFit,mt,aucAll,aucAll_perDtrDist,fitDif,ccatAll,refSideAll,comSideAll,dtrDist);
allTrials.refSideAll = nominal(allTrials.refSideAll);
allTrials.comSideAll = nominal(allTrials.comSideAll);
allTrials.ccatAll = nominal(allTrials.ccatAll);

mdl = fitlm(allTrials,'aucAll_perDtrDist~tgtFit*dtrFit');
% Note: Coefficient for tgtFit is positive --> good target fit produces
% more attraction to distracter!? Maybe because good target fit means that
% distracter fit as well may be good (i.e., the distrbution of disrtacter
% fits for all good target fits is shifted to better fits). Coefficient for
% dtrFit is negative --> Better dsitracter fits lead to less attraction!?
% The explanation may be analogous to the one for the target fit
% coefficient (i.e., good distracter fits are necessarily associated with
% high target fits as otherwise the role of the objects would be reversed).
% The interaction of both is highly significant, which may be a hint toward
% the above explanations (??).
% How to go about this??? Maybe an experiment where people are free to
% select good or worse fitting item (tgt/dtr); e.g. first task: select the
% large item (may be either role) and first listen to this relational description
% then second task: select target item of relational description.

