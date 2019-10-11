% This script plots the distribution of targets and/or distracters within a
% list of trials loaded in the workspace.

% Adjust which triallist should be used:
%
triallistCols_tmp = tg.triallistCols;
triallist_tmp = tg.triallist;
%triallistCols_tmp = triallistCols;
%triallist_tmp = triallist;

% include whcih spatial term codes? (can be row vector to include multiple)
useSptTerms = [1 2 3 4]; 

plotTgts = 0;
plotDtrs = 1;
relativeToRef = 1; % coordinates relative to trial's ref or absolute
addToExistingFigure = 0; % add current plot to existing figure or make new one?

% these can be left empty...
%useXlims = [];
%useYlims = [];
% useXlims = [0 screen_mm(1)*pxPerMm(1)];
% useYlims = [0 screen_mm(2)*pxPerMm(2)];
%useXlims = [0 tg.presArea_mm(1)];
%useYlims = [0 tg.presArea_mm(2)];
useXlims = [-70 70];
useYlims = [-70 70];

% additional: histogram over positions (binning close items)
doHist = 1;
doHistFor = 'tgts'; %use dtrs or tgts
%numBin_x = 17;
numBin_x = 100;
numBin_y = numBin_x;

% Note: Adjust numBin_x & y to get a smooth histogram centered on the
% actual item "hotspots"

%% Compute

% Get rows for desired spatial terms
rowSubs = find(any(arrayfun(@(spt_is,spt_use)  spt_is==spt_use,repmat(triallist_tmp(:,triallistCols_tmp.spt),1,numel(useSptTerms)), repmat(useSptTerms,size(triallist_tmp(:,triallistCols_tmp.spt),1),1)),2));

% Get TARGET coords

% Get linear indices of target coordinates in trial matrix
tgt_colSubs_x = triallistCols_tmp.horzPosStart - 1 + triallist_tmp(:,triallistCols_tmp.tgt);
tgt_colSubs_y = triallistCols_tmp.vertPosStart - 1 + triallist_tmp(:,triallistCols_tmp.tgt);
tgt_colSubs_x =  tgt_colSubs_x(rowSubs);
tgt_colSubs_y =  tgt_colSubs_y(rowSubs);
% Get linear indices to x-positions
tgt_lndcs_x = sub2ind(size(triallist_tmp),rowSubs,tgt_colSubs_x);
% Get linear indices to y-positions
tgt_lndcs_y = sub2ind(size(triallist_tmp),rowSubs,tgt_colSubs_y);
% Get actual coordinates
tgts_x = triallist_tmp(tgt_lndcs_x);
tgts_y = triallist_tmp(tgt_lndcs_y);

% Get REF coords

% Get linear indices of target coordinates in trial matrix
ref_colSubs_x = triallistCols_tmp.horzPosStart - 1 + triallist_tmp(:,triallistCols_tmp.ref);
ref_colSubs_y = triallistCols_tmp.vertPosStart - 1 + triallist_tmp(:,triallistCols_tmp.ref);
ref_colSubs_x =  ref_colSubs_x(rowSubs);
ref_colSubs_y =  ref_colSubs_y(rowSubs);
% Get linear indices to x-positions
ref_lndcs_x = sub2ind(size(triallist_tmp),rowSubs,ref_colSubs_x);
% Get linear indices to y-positions
ref_lndcs_y = sub2ind(size(triallist_tmp),rowSubs,ref_colSubs_y);
% Get actual coordinates
refs_x = triallist_tmp(ref_lndcs_x);
refs_y = triallist_tmp(ref_lndcs_y);

% Get DTR coords

% Get linear indices of target coordinates in trial matrix
dtr_colSubs_x = triallistCols_tmp.horzPosStart - 1 + triallist_tmp(:,triallistCols_tmp.dtr);
dtr_colSubs_y = triallistCols_tmp.vertPosStart - 1 + triallist_tmp(:,triallistCols_tmp.dtr);
dtr_colSubs_x =  dtr_colSubs_x(rowSubs);
dtr_colSubs_y =  dtr_colSubs_y(rowSubs);
% Get linear indices to x-positions
dtr_lndcs_x = sub2ind(size(triallist_tmp),rowSubs,dtr_colSubs_x);
% Get linear indices to y-positions
dtr_lndcs_y = sub2ind(size(triallist_tmp),rowSubs,dtr_colSubs_y);
% Get actual coordinates
dtrs_x = triallist_tmp(dtr_lndcs_x);
dtrs_y = triallist_tmp(dtr_lndcs_y);


% Compute relative coordinates from that (if desired)
if relativeToRef
    tgts_rel_x = tgts_x - refs_x;
    tgts_rel_y = tgts_y - refs_y;
    dtrs_rel_x = dtrs_x - refs_x;
    dtrs_rel_y = dtrs_y - refs_y;
else
    tgts_rel_x = tgts_x;
    tgts_rel_y = tgts_y;
    dtrs_rel_x = dtrs_x;
    dtrs_rel_y = dtrs_y;
end


%% Sort into bins based on x and y position, compute means for each bin and plot
% then plot histogram over space

if doHist

switch doHistFor
    case 'dtrs'
        doHistFor_x = dtrs_rel_x;
        doHistFor_y = dtrs_rel_y;
    case 'tgts'
        doHistFor_x = tgts_rel_x;
        doHistFor_y = tgts_rel_y;
end
        
        
% numBin_x = 20;
% numBin_y = 20;
binStart_x = useXlims(1);
binEnd_x = useXlims(2);
binStart_y = useYlims(1);
binEnd_y = useYlims(2);
binBorders_x = linspace(binStart_x,binEnd_x,numBin_x+1);
binBorders_y = linspace(binStart_y,binEnd_y,numBin_y+1);

% Get (counts and) indices 
[bc_x, bInd_x ] = histc(doHistFor_x,binBorders_x);
[bc_y, bInd_y ] = histc(doHistFor_y,binBorders_y);

binSums = [];
for xBin = 1:numBin_x
for yBin = 1:numBin_y
   
    binSums(yBin,xBin) = sum((bInd_x == xBin) & (bInd_y == yBin));
        
end
end


figure; imagesc(binBorders_x,binBorders_y,binSums); set(gca,'ydir','normal')

end

%% Plot actual positions

hold on
if plotTgts
    scatter(tgts_rel_x,tgts_rel_y);
end
if plotDtrs
    scatter(dtrs_rel_x,dtrs_rel_y,'x');
end
axis square; grid on;
try
    set(findobj(gcf,'type','axes'),'xlim',useXlims,'ylim',useYlims);
end


