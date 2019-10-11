
% This script temporarily transforms all item positions by translating them
% such that the start marker lies in the origin and by rotating the items
% around the origin such that the (expected) target center lies on the
% positive y-axis. On this basis, it is computed where reference, main
% dsitracter, and center of mass of all items lie relative to the direct
% (straight) path from start marker center to target center (distance and
% discrete side, where negative/1 means left of path, positive/2 means
% right of path. Then, these are used to compute the side of the items in
% comparison to each other (balancing categories), that is, whether
% ref/dtr/com lie on the same or different side of the direct path than the
% item it is compared to. This is done from the perspective of each of
% these items, resulting in three balancing "dimensions" with four
% categories each:
%
% refVsComVsDtrSide     (for considering effects of ref side)
% 1: com same, Dtr same
% 2: com same, Dtr oppo
% 3: com oppo, Dtr same
% 4: com oppo, Dtr oppo
%
% comVsRefVsDtrSide     (for considering effects of COM side)
% 1: ref same, Dtr same
% 2: ref same, Dtr oppo
% 3: ref oppo, Dtr same
% 4: ref oppo, Dtr oppo
%
% dtrVsRefVsComSide     (for considering effects of Dtr side)
% 1: ref same, com same
% 2: ref same, com oppo
% 3: ref oppo, com same
% 4: ref oppo, com oppo
%
% IMPORTANT: The categories computed here are useful only to judge balancing
% in advance. They need to be computed anew during analysis, because the
% direct path is here defined differently then there: Here, it is the line
% from start marker center to (expected) target center; in analysis, it is
% the line from first trajectory data point to center of *chosen* item: The
% latter may also be the distracter (therefore during analysis it is not the 
% distracter side that matters (except when considering only "correct" trials)
% but that of the non-chosen item (which, in "incorrect" trials, may also
% be the target).

for curRow = 1:size(triallist,1)
    
    % --- Prepare item positions (translate/rotate)
    
    % make temporary item set
    curItemSet_xy = ...
        [triallist(curRow,triallistCols.horzPosStart:triallistCols.horzPosEnd)',...
        triallist(curRow,triallistCols.vertPosStart:triallistCols.vertPosEnd)'];
    
    % row numbers in item set matrix for the different item roles
    refRow = triallist(curRow,triallistCols.ref);
    tgtRow = triallist(curRow,triallistCols.tgt);
    dtrRow = triallist(curRow,triallistCols.dtr);
    
    % translate all items such that the start marker position is in the origin 0,0
    curItemSet_xy = curItemSet_xy - repmat(start_pos_mm,size(curItemSet_xy,1),1);
    
    % get tgt position before rotation
    tgtPos = curItemSet_xy(tgtRow,:);
    
    % rotate all items around start marker, using ideal path from center of
    % start marker to target item as reference axis, so that target lies on
    % positive y-axis afterwards.
    curItemSet_xy = cell2mat(trajRot([0 0; curItemSet_xy],2,[1 2],tgtPos,0));
    curItemSet_xy = curItemSet_xy(2:end,:); % remove start marker pos
    
    clearvars 'tgtPos'; % to avoid erroneous usage later
    
    
    % --- determine relevant positions relative to direct path
    
    % DTR
    % signed distance of main distracter from direct path;
    % positive = right, negative = left
    distDtrToDirPath = curItemSet_xy(dtrRow,1);
    % side of main distracter relative to direct path;
    % 1 = left, 2 = right;
    if distDtrToDirPath < 0   % left
        dtrSide = 1;
    elseif distDtrToDirPath > 0  % right
        dtrSide = 2;
    end
    
    % REF
    % signed distance of reference from direct path;
    % positive = right, negative = left
    distRefToDirPath = curItemSet_xy(refRow,1);
    % side of reference relative to direct path;
    % 1 = left, 2 = right;
    if distRefToDirPath < 0   % left
        refSide = 1;
    elseif distRefToDirPath > 0  % right
        refSide = 2;
    end
    
    % COM
    % signed distance of CoM from direct path;
    % positive = right, negative = left
    curCom = sum(curItemSet_xy)/size(curItemSet_xy,1);
    distComToDirPath = curCom(1);
    % side of CoM relative to direct path;
    % 1 = left, 2 = right;
    if distComToDirPath < 0   % left
        comSide = 1;
    elseif distComToDirPath > 0  % right
        comSide = 2;
    end
    
    % --- determine relevant positions compared to the other items'
    % positions relative to the direct path (same side or diff. side?)
    
    % Assess relation ref,com, and dtr in terms of whether (1) or not (0)
    % they are on the same side of the direct path to the target
    refComSame = refSide == comSide;
    refDtrSame = refSide == dtrSide;
    comDtrSame = comSide == dtrSide;
    
    % compute categories out of these relative to refSide, comSide, and dtrSide
    
    % For considering effects of reference side:
    if refComSame==1 && refDtrSame==1 % 1: com same, Dtr same
        refVsComVsDtrSide = 1;
    elseif refComSame==1 && refDtrSame==0 % 2: com same, Dtr oppo
        refVsComVsDtrSide = 2;
    elseif refComSame==0 && refDtrSame==1 % 3: com oppo, Dtr same
        refVsComVsDtrSide = 3;
    elseif refComSame==0 && refDtrSame==0 % 4: com oppo, Dtr oppo
        refVsComVsDtrSide = 4;
    end
    
    % For considering effects of COM side:
    if refComSame==1 && comDtrSame==1 % 1: ref same, Dtr same
        comVsRefVsDtrSide = 1;
    elseif refComSame==1 && comDtrSame==0 % 2: ref same, Dtr oppo
        comVsRefVsDtrSide = 2;
    elseif refComSame==0 && comDtrSame==1 % 3: ref oppo, Dtr same
        comVsRefVsDtrSide = 3;
    elseif refComSame==0 && comDtrSame==0 % 4: ref oppo, Dtr oppo
        comVsRefVsDtrSide = 4;
    end
    
    % For considering effects of Dtr side
    if refDtrSame==1 && comDtrSame==1 % 1: ref same, com same
        dtrVsRefVsComSide = 1;
    elseif refDtrSame==1 && comDtrSame==0 % 2: ref same, com oppo
        dtrVsRefVsComSide = 2;
    elseif refDtrSame==0 && comDtrSame==1 % 3: ref oppo, com same
        dtrVsRefVsComSide = 3;
    elseif refDtrSame==0 && comDtrSame==0 % 4: ref oppo, com oppo
        dtrVsRefVsComSide = 4;
    end
    
    % store results in triallist
    
    triallist(curRow,triallistCols.distDtrToDirPath) = distDtrToDirPath;
    triallist(curRow,triallistCols.distRefToDirPath) = distRefToDirPath;
    triallist(curRow,triallistCols.distComToDirPath) = distComToDirPath;    
    triallist(curRow,triallistCols.refSide) = refSide;
    triallist(curRow,triallistCols.dtrSide) = dtrSide;
    triallist(curRow,triallistCols.comSide) = comSide;    
    triallist(curRow,triallistCols.refVsComVsDtrSide) = refVsComVsDtrSide;
    triallist(curRow,triallistCols.comVsRefVsDtrSide) = comVsRefVsDtrSide;
    triallist(curRow,triallistCols.dtrVsRefVsComSide) = dtrVsRefVsComSide;
    
end