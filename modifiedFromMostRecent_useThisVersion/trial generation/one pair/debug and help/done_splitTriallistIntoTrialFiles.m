
% This script takes a triallist from tg.triallist in the input file,
% shuffles the list, then goes through a loop for each desired output file;
% in the loop, from the beginning of the shuffled list a batch of trials is
% used for the current file/participant (and removed from the original
% list); this batch is copied, and in the copied version one column of codes is
% replaced by a specified value (see settings); also, the trialIDs in the
% copied version are adjusted and made unique by adding to each the total
% number of trials in the original list from the input file; then the old
% batch and the copied version are concatenated and re-shuffled (i.e., within
% participant). This mixed list is then saved in a new file holding trials
% for one participant. The effect of the above is that each participant
% gets a fixed number of randomly chosen trials from the input list, but
% each participant sees the same trial twice, once with the original code
% and once with the replaced code (i.e., trial pairs are in theory directly
% comparable within each participant).
%
% The replacement stuff can be disabled below. In this case, this script
% just randomly splits up the trials from the input list onto several trial
% files.
%
% (Note that the replacement code can be easily modified to allow for
% duplication and replacement based on mutliple columns)

% source file
sourceFile = ['S:\vertResponseTrials26_04_2017.mat'];
load(sourceFile)

% no of desired files (pts)
nPts = 24;

% total number of trials in input list
nTrialsTotal = size(tg.triallist,1);

% Column replacement
doDuplicateAndReplacement = 1; % do duplication and replacement?
replaceColumn = tg.triallistCols.wordOrder; % which codes (column number) are to be replaced in the copy of the list
replacementValue = 2; % value by which everything in that column is replaced



% trials (from the original list) per output file (the actual number will
% be double that value in case doDuplicateAndReplacement is true)
trialsPerFile = floor(nTrialsTotal/nPts);
remainderTrials = nTrialsTotal - trialsPerFile * nPts;

% Shuffle trials
tlShuffled = tg.triallist(randperm(nTrialsTotal),:);

% loop over participants
for curSet = 1:nPts         
    
    if curSet == nPts
        tg.triallist = tlShuffled(1:end,:);
        tlShuffled(1:end,:) = [];
    else        
        tg.triallist = tlShuffled(1:trialsPerFile,:);
        tlShuffled(1:trialsPerFile,:) = [];
    end
    
    if doDuplicateAndReplacement
        % DUPLICATE LIST AND CHANGE ONE COLUMN-----------
        % duplicate trials within participant but replace word order for the
        % new trials
        triallistCopy = tg.triallist;
        % replace word order code
        triallistCopy(:,replaceColumn) = replacementValue;
        % add new trial IDs by adding total number of trials in original list
        % to the existing ones.
        triallistCopy(:,tg.triallistCols.trialID) = triallistCopy(:,tg.triallistCols.trialID)+nTrialsTotal;
        % concatenate old & new list
        tg.triallist = [tg.triallist;triallistCopy];
        % re-shuffle within participant
        tg.triallist = tg.triallist(randperm(size(tg.triallist,1)),:);
        %-------------------------------------------------
    end
    
    save(['\trials_' num2str(curSet)], '-regexp', '^(?!(nPts|nTrialsTotal|trialsPerFile|remainderTrials|tlShuffled|curSet)$).')
end









