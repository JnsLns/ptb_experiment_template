

%% Define columns of triallist

% -- generate these here:
% trialID % unique ID for each trial RUNNING INDEX
% nItems % NEW... USE noOfItems
% type % relational, control etc. FIXED 1
% tgt % num of tgt among item columns (2)
% ref % num of ref among item columns (1)
% dtr % num of main dtr among item columns (3)
% spt % spatial term code ROW OF FULLARRAYS
% wordOrder % word order in spatial phrase FIXED
% tgtSlot % tgt slot code DETERMINE BY COMPARING TGT POS TO TGTSLOTS AND CODES
% nTgts % no of items in target color DETERMINE FROM COLOR LIST AND TGT COLOR
% colorsStart % start number of color columns
% colorsEnd % end number of color columns
% vertPosStart % start number of vert pos columns
% vertPosEnd % end number of vert pos columns
% horzPosStart % start number of horz pos columns
% horzPosEnd % end number of horz pos columns

% Assign rows
triallistCols = [];
triallistCols.trialID = 1;
triallistCols.type = max(structfun(@(x) x,triallistCols))+1;
triallistCols.nItems = max(structfun(@(x) x,triallistCols))+1;
triallistCols.tgt = max(structfun(@(x) x,triallistCols))+1;
triallistCols.ref = max(structfun(@(x) x,triallistCols))+1;
triallistCols.ref2 = max(structfun(@(x) x,triallistCols))+1;
triallistCols.dtr = max(structfun(@(x) x,triallistCols))+1;
triallistCols.spt = max(structfun(@(x) x,triallistCols))+1;
% triallistCols.additionalItemCondition:
% 1 = full second pair
% 2 = only second ref (give filler color to dtr)
% 3 = only dtr (give filler color to ref 2)
% 4 = no additional items (give filler colors to ref2 and dtr)
triallistCols.pair2VsRef1VsComSide = max(structfun(@(x) x,triallistCols))+1; % 1 = r1s/cs, 2 = r1s/cd, 3 = r1d/cs, 4 = r1d/cd (all relative to pair2)
triallistCols.additionalItemCondition = max(structfun(@(x) x,triallistCols))+1;
triallistCols.tgtSlot = max(structfun(@(x) x,triallistCols))+1;
triallistCols.nTgts = max(structfun(@(x) x,triallistCols))+1;
triallistCols.colorsStart = max(structfun(@(x) x,triallistCols))+1;
triallistCols.colorsEnd = max(structfun(@(x) x,triallistCols))+noOfItems-1;
triallistCols.vertPosStart = max(structfun(@(x) x,triallistCols))+1;
triallistCols.vertPosEnd = max(structfun(@(x) x,triallistCols))+noOfItems-1;
triallistCols.horzPosStart = max(structfun(@(x) x,triallistCols))+1;
triallistCols.horzPosEnd = max(structfun(@(x) x,triallistCols))+noOfItems-1;
triallistCols.radiiStart = max(structfun(@(x) x,triallistCols))+1;
triallistCols.radiiEnd = max(structfun(@(x) x,triallistCols))+noOfItems-1;
triallistCols.fitsStart = max(structfun(@(x) x,triallistCols))+1;
triallistCols.fitsEnd = max(structfun(@(x) x,triallistCols))+noOfItems-1;
triallistCols.temporaryPtsID = max(structfun(@(x) x,triallistCols))+1;


%% Convert arrays into rows of trial data and store in trialCell

% prepare triallist row filled with NaNs
blankRow =  nan(1,max(structfun(@(x) x,triallistCols)));

% initialize
curID = 0;
trialCell = cell(size(fullArrays_addItemConditions));
totalTrialCount = 0;
for curSpt = 1:size(fullArrays_addItemConditions,1)
    for curTs = 1:size(fullArrays_addItemConditions,2)
        for curBalCat = 1:size(fullArrays_addItemConditions,3)
            for curAddItemCondition = 1:size(fullArrays_addItemConditions,4)
                
                % iterate through arrays within this conditions and turn each into a trial data row
                curList = [];
                for curArray = 1:numel(fullArrays_addItemConditions{curSpt,curTs,curBalCat,curAddItemCondition})
                    
                    % Reset trial data
                    curTrialData = blankRow;
                    
                    % Get array (x,y,color)
                    curArrayData = fullArrays_addItemConditions{curSpt,curTs,curBalCat,curAddItemCondition}{curArray};
                    
                    % Get spatial term code corresponding to current row in fullArrays
                    curSptCode = sptCodes(curSpt);
                    
                    % Get and store relevant data
                    curID = curID + 1;
                    curTrialData(triallistCols.trialID) = curID;
                    curTrialData(triallistCols.nItems) = size(curArrayData,1);
                    curTrialData(triallistCols.type) = 1;
                    curTrialData(triallistCols.ref) = refNumFromColorAssignment;
                    curTrialData(triallistCols.tgt) = tgtNumFromColorAssignment;
                    curTrialData(triallistCols.ref2) = ref2NumFromColorAssignment;
                    curTrialData(triallistCols.dtr) = dtrNumFromColorAssignment;                    
                    curTrialData(triallistCols.spt) = curSptCode;
                    curTrialData(triallistCols.tgtSlot) = curTs; %CHECK
                    curTrialData(triallistCols.pair2VsRef1VsComSide) = curBalCat;
                    curTrialData(triallistCols.additionalItemCondition) = curAddItemCondition;
                    curTrialData(triallistCols.nTgts) = sum(curArrayData(:,3) == curArrayData(curTrialData(triallistCols.tgt),3));
                    curTrialData(triallistCols.colorsStart:triallistCols.colorsStart+size(curArrayData,1)-1) = curArrayData(:,3)';
                    curTrialData(triallistCols.vertPosStart:triallistCols.vertPosStart+size(curArrayData,1)-1) = curArrayData(:,2)';
                    curTrialData(triallistCols.horzPosStart:triallistCols.horzPosStart+size(curArrayData,1)-1) = curArrayData(:,1)';
                    curTrialData(triallistCols.radiiStart:triallistCols.radiiStart+size(curArrayData,1)-1) = stim_r_mm;
                    % Note: Fit values for all items are added in G_computeFits.m
                    
                    % trials as a normal list (trials are rows) for current
                    % combo of spt,ts,balCat,and addItem condition
                    curList(end+1,:) = curTrialData;
                    
                    totalTrialCount = totalTrialCount+1;
                    
                end
                
                % Store away
                trialCell{curSpt,curTs,curBalCat,curAddItemCondition} = curList;
                
            end
        end
    end
end

%% Assign trials to participants (in a balanced way)

% Determine how many trials to take from each subcondition
% (spt × target slots × balCat) to achieve the desired number of trial per 
% participant while retaining an approximately equal proportion of
% conditions for each participant (this hopefully will minimize zero case
% conditions due to misses in the experiment).
%
% Total number of different trials (not taking into account multiplication
% by number of addItem conditions, as these will be balanced below)
nTrials_SptTssBal = sum(nDesiredTrialsPerSubcondition(:));
% Proportion of trial number within each subcondition to the total number of trials
propTPS = nDesiredTrialsPerSubcondition./nTrials_SptTssBal;
% Compute required numbers from each subcondition for each pts.
nTrialsPerSubcondition_eachPts = propTPS.*nTrialsPerPts/nAddItemConditions;
nTrialsPerSubcondition_eachPts = ceil(nTrialsPerSubcondition_eachPts);

nPts = ceil(totalTrialCount/nTrialsPerPts);
    
% loop over participants
triallist = [];
for curPts = 1:nPts

% % THIS DOES NOT REALLY WORK AS INTENDED (but is not needed as long as the
% % number of trials desired per pts fits the sum of
% % nTrialsPerSubcondition_eachPts)
% %
%     % Reduce case numbers to achieve desired trial number for this participant:
%     % If current total is larger than required, stepwise decrease random case
%     % numbers within condition combinations (returning to first decreased only
%     % after all others have been decreased as well)
    ntps_curPts = nTrialsPerSubcondition_eachPts;
%     elements = 1:numel(ntps_curPts);
%     elements = elements(randperm(numel(elements)));
%     curEle = 1;
%     while sum(ntps_curPts(:))*nAddItemConditions > nTrialsPerPts
%         if ntps_curPts(elements(curEle)) > 0
%             ntps_curPts(elements(curEle)) = ntps_curPts(elements(curEle))-1;
%         end
%         curEle = curEle + 1;
%         if curEle > numel(elements)
%             curEle = 1;
%         end
%     end
    
    % For the current participant, take RANDOMLY from the overall trial list a number of
    % trials from each condition combination as now specified in ntps_curPts.
    % Delete each trial row after taking it
    % For each case take THE SAME ROW from each addItem condition 
    
    % Linearly iterate over condition combinations
    for curCond = 1:numel(ntps_curPts)
                
        % subscript index of cell in 3d array (case number array)
        curSubs3D = ind2subAll(size(ntps_curPts),curCond);
        
        % Loop over cases
        noMoreTrials = 0;
        for curCaseNum = 1:ntps_curPts(curCond)
            
            % Grab one trial out of each addItem condition for each case
            for curAddItemCond = 1:nAddItemConditions                                
                
                if noMoreTrials 
                    break
                end
                
                % linear index of cell in 4D array for current addItemCondition
                curInd4D = sub2indAll(size(trialCell),[curSubs3D curAddItemCond]);
                
                % randomly select which trial to take
                % (this is used for first and subsequent addItem conditions)
                if curAddItemCond == 1
                    takeRowNum = ceil(rand*size(trialCell{curInd4D},1));                                                                                    
                end
                
                % For last participant, allow missing trials 
                if takeRowNum == 0 && curPts == nPts
                    noMoreTrials = 1;
                    break
                end
                
                % get the trial data
                curDataRow = trialCell{curInd4D}(takeRowNum,:);
                
                % Remove trial from pool
                trialCell{curInd4D}(takeRowNum,:) = [];
                
                % tag with pts tag
                curDataRow(1,triallistCols.temporaryPtsID) = curPts;
                
                % append to overall triallist
                triallist(end+1,:) = curDataRow;
                
            end
        end
    end
end



