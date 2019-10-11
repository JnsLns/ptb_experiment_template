
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
triallistCols.dtr = max(structfun(@(x) x,triallistCols))+1;
triallistCols.spt = max(structfun(@(x) x,triallistCols))+1;
triallistCols.wordOrder = max(structfun(@(x) x,triallistCols))+1;
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
triallistCols.distDtrToDirPath = max(structfun(@(x) x,triallistCols))+1;
triallistCols.distRefToDirPath = max(structfun(@(x) x,triallistCols))+1;
triallistCols.distComToDirPath = max(structfun(@(x) x,triallistCols))+1;
triallistCols.refSide = max(structfun(@(x) x,triallistCols))+1;
triallistCols.dtrSide = max(structfun(@(x) x,triallistCols))+1;
triallistCols.comSide = max(structfun(@(x) x,triallistCols))+1;
triallistCols.refVsComVsDtrSide = max(structfun(@(x) x,triallistCols))+1;
triallistCols.comVsRefVsDtrSide = max(structfun(@(x) x,triallistCols))+1;
triallistCols.dtrVsRefVsComSide = max(structfun(@(x) x,triallistCols))+1;

% prepare triallist row filled with NaNs
blankRow =  nan(1,max(structfun(@(x) x,triallistCols)));

% initialize
curID = 0;
triallist = [];            

for curSpt = 1:size(fullArrays,1)
    for curTs = 1:size(fullArrays,2)
        for curArray = 1:numel(fullArrays{curSpt,curTs})
                       
           % Reset trial data
           curTrialData = blankRow;            

           % Get array (x,y,color)
           curArrayData = fullArrays{curSpt,curTs}{curArray};
           
           % Get spatial term code corresponding to current row in fullArrays
           curSptCode = sptCodes(curSpt);
           
           % Get and store relevant data
           curID = curID + 1; 
           curTrialData(triallistCols.trialID) = curID;           
           curTrialData(triallistCols.nItems) = size(curArrayData,1);           
           curTrialData(triallistCols.type) = 1;
           curTrialData(triallistCols.ref) = 1;
           curTrialData(triallistCols.tgt) = 2;
           curTrialData(triallistCols.dtr) = 3;
           curTrialData(triallistCols.wordOrder) = 1;                                           
           curTrialData(triallistCols.spt) = curSptCode; 
           curTrialData(triallistCols.tgtSlot) = curTs; %CHECK                             
           curTrialData(triallistCols.nTgts) = sum(curArrayData(:,3) == curArrayData(curTrialData(triallistCols.tgt),3));           
           curTrialData(triallistCols.colorsStart:triallistCols.colorsStart+size(curArrayData,1)-1) = curArrayData(:,3)';           
           curTrialData(triallistCols.vertPosStart:triallistCols.vertPosStart+size(curArrayData,1)-1) = curArrayData(:,2)';           
           curTrialData(triallistCols.horzPosStart:triallistCols.horzPosStart+size(curArrayData,1)-1) = curArrayData(:,1)';
           curTrialData(triallistCols.radiiStart:triallistCols.radiiStart+size(curArrayData,1)-1) = stim_r_mm;           
           
           % Note: Fit values for all items are added in G_computeFits.m          
           
           triallist(end+1,:) = curTrialData;
           
        end
    end
end