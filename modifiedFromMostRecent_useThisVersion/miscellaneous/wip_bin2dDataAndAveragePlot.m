% use with untransformed trajectories

%useTrials_logical = logical(ones(size(rsIndiv{1},1),1));

useTrials_logical = rsIndiv{1}(:,resCols.spt) == 2; %| rsIndiv{1}(:,resCols.spt) == 3;

useTrials = rsIndiv{1}(useTrials_logical,:);

% Get target position relative to reference
hp = useTrials(:,resCols.horzPosStart-1+2)-useTrials(:,resCols.horzPosStart);
vp = useTrials(:,resCols.vertPosStart-1+2)-useTrials(:,resCols.vertPosStart);

% Flip/rotate all to be congruent with left of
for curSpt = 2:4
    switch curSpt
        case 2 % right of
            hp(useTrials(:,resCols.spt)==curSpt) = -hp(useTrials(:,resCols.spt)==curSpt);            
        case 3 % above
            hp(useTrials(:,resCols.spt)==curSpt) = -vp(useTrials(:,resCols.spt)==curSpt);            
            vp(useTrials(:,resCols.spt)==curSpt) = hp(useTrials(:,resCols.spt)==curSpt);            
        case 4 % below
            hp(useTrials(:,resCols.spt)==curSpt) = vp(useTrials(:,resCols.spt)==curSpt);            
            vp(useTrials(:,resCols.spt)==curSpt) = -hp(useTrials(:,resCols.spt)==curSpt);            
    end    
end


mt = useTrials(:,resCols.movementTime_pc);
auc = trIndivAUC{1}(useTrials_logical);

% % scatter3(hp,vp,mt)
% % scatter3(hp,vp,auc)
% % xlim([-100 100])
% % ylim([-100 100])
% 
% % absolute distance from direct patch
dttdp = useTrials(:,resCols.distNonChosenToDirPath);

%% Sort into bins based on x and y position, compute means for each bin and plot

% which value to use?
allVals = abs(auc./dttdp);

numBin_x = 10;
numBin_y = 10;
binStart_x = -60;
binEnd_x = 60;
binStart_y = -60;
binEnd_y = 60;
binBorders_x = linspace(binStart_x,binEnd_x,numBin_x+1);
binBorders_y = linspace(binStart_y,binEnd_y,numBin_y+1);

% Get (counts and) indices 
[bc_x, bInd_x ] = histc(hp,binBorders_x);
[bc_y, bInd_y ] = histc(vp,binBorders_y);


for xBin = 1:numBin_x
for yBin = 1:numBin_y   
    binMeans(yBin,xBin) = mean(allVals((bInd_x == xBin) & (bInd_y == yBin)));        
end
end


% % Make grids out of binborders
% binGrid_x = repmat(binBorders_x,numel(binBorders_y),1);
% binGrid_y = repmat(binBorders_y,numel(binBorders_x),1)';
% 
% for curCol = 1:size(binGrid_x,2)
%     for curRow = 1:size(binGrid_y,1)
%    
%         curInds = (hp == binGrid_x(curRow,curCol) & vp == binGrid_y(curRow,curCol));
%         binMeans(curRow,curCol) = mean(allVals(curInds));
%         
%     end
% end

figure; imagesc(binMeans);


