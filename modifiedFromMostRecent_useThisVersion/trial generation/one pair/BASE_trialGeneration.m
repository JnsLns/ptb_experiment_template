% this script file calls all other scripts and saves generated data

% use startAndSettings_trialGeneration.m to start trial generation

%% Compute arrays

% Generate ref-tgt-dtr configurations for each spatial term
% (note: the script called in this loop also calls A2_trialGenerationDebugPlots
% for each spatial term enabled in showTgtAndDtrPositionsForSptCodes)
for curSpt = sptCodes    
    phi_0 = phi_0_bySptCode(curSpt); % this defines the template for current term
    A_makeArrayRefTgtDtr; % main output: cell array prespecItems with one ref-tgt-dtr configuration
                          % in each cell, ref at [0,0]    
    prespecItems_bySpts{curSpt} = prespecItems;
    clearvars 'prespecItems'
    fitFuns_bySpts{curSpt} = fitFun;
    clearvars 'fitFun'
end


% NOTE: For multi-ref paradigm possible array combination here (next
% modification needed at color assignment)


% Translate base arrays to tgtSlot 
% new cell array is 2-dimensional with rows representing spatial terms and
% columns representing target slots. Each cell holds a full set of tgt item
% configurations, that is, all targets and all distracters (these are
% contained within another cell array).
for curSpt = 1:numel(prespecItems_bySpts)
    for curTgtSlotCode = tgtSlotCodes
        curTgtSlot_xy = tgtSlots_xy_mm(curTgtSlotCode,:);       
        % to tgt slot
        prespecItems_bySptsAndTss{curSpt,curTgtSlotCode} = cellfun(@(psis) psis+repmat(curTgtSlot_xy-psis(2,:),size(psis,1),1),prespecItems_bySpts{curSpt}, 'uniformoutput',0);        
        disp(['Translating base arrays to target slot.']);
    end
end

% Check whether any of the items in the genrated ref-tgt-dtr arrays fall
% outside of the overall stimulus region; if so, issue warning.
B_checkConstraintsRefTgtDtr;

% generate filler-items 
for curSpt = 1:size(prespecItems_bySptsAndTss,1)
    for curTs = 1:size(prespecItems_bySptsAndTss,2)
        for curArray = 1:numel(prespecItems_bySptsAndTss{curSpt,curTs})
            curPrespecItems_xy = prespecItems_bySptsAndTss{curSpt,curTs}{curArray};
            C_addRandomFillerItems;
            fullArrays{curSpt,curTs}{curArray} = items_xy;                        
            disp(['Generating fillers (spt: ' num2str(curSpt) ', tgtSlot: ' num2str(curTs) ', arrNum: ' num2str(curArray) ]);
        end
    end
end

% (Note: D has been removed as it was not needed anymore)

% translate entire arrays to final array position specified by array_pos_mm
for curRow = 1:size(fullArrays,1)
    for curCol = 1:size(fullArrays,2)
        for curArr = 1:numel(fullArrays{curRow,curCol})
            fullArrays{curRow,curCol}{curArr} = fullArrays{curRow,curCol}{curArr} + repmat(array_pos_mm,size(fullArrays{curRow,curCol}{curArr},1),1);             
        end
    end
end

% Assign colors to items and convert to trial list format that can be used
% by experimental script.
E_assignColorsToItems;

% convert to trial list format usable by experiment script
F_makeTrialList;

% Determine fit values for all items and add to triallist
G_computeFits;

% Determine balancing categories for each trial (ref,dtr,com sides relative
% to direct path and relativ to each other)
H_getBalancingCategories;

% Convert tgtSlots_xy_mm to absolute positions within the presentation
% area
tgtSlots_xy_mm(:,1) = array_pos_mm(1)+tgtSlots_xy_mm(:,1);
tgtSlots_xy_mm(:,2) = array_pos_mm(2)+tgtSlots_xy_mm(:,2);


%% save relevant variables

% first put all relevant variables into struct tg (trial generation); those
% that are not needed in the actual experiment are stored in the sub struct
% tg.gen (relevant only for generation) the others directly in tg.

tg.gen.fitFuns_bySpts = fitFuns_bySpts;          % These are just stored for information
tg.gen.horzAx_mm =horzAx_mm;
tg.gen.vertAx_mm  = vertAx_mm;
tg.gen.max_r =max_r;
tg.gen.r_0 =r_0;
tg.gen.sig_r = sig_r;
tg.gen.phi_0_bySptCode = phi_0_bySptCode;
tg.gen.sig_phi = sig_phi;
tg.gen.beta =beta;
tg.gen.phi_flex = phi_flex;
tg.gen.x_res  =x_res;
tg.gen.y_res  =y_res;
tg.gen.phi_res =phi_res;
tg.gen.r_res =r_res;
tg.gen.fitCutoff_tgt =fitCutoff_tgt;
tg.gen.nDesiredTgtPos =nDesiredTgtPos;
tg.gen.nDesiredDtrPos =nDesiredDtrPos;
tg.gen.nActualTgts    =nActualTgts;
tg.gen.nDtrPerTgt     =nDtrPerTgt;
tg.gen.fitCutoff_dtr =fitCutoff_dtr;
tg.gen.tgtRegion_logical =tgtRegion_logical;
tg.gen.dtrRegion_logical =dtrRegion_logical;
tg.gen.minFitDiffTgtDtr =minFitDiffTgtDtr;
tg.gen.minDistTgtRef_mm =minDistTgtRef_mm;
tg.gen.minDistDtrTgt_mm =minDistDtrTgt_mm;
tg.gen.minDistDtrRef_mm =minDistDtrRef_mm;
tg.gen.com_desired_mm =com_desired_mm ;
tg.gen.tolerance_mm =tolerance_mm;
tg.gen.minDistRefOppoDtr_mm =minDistRefOppoDtr_mm;
tg.gen.noOfItems =noOfItems;
tg.gen.maxDistFromCenterHorz_all_mm =maxDistFromCenterHorz_all_mm;
tg.gen.maxDistFromCenterVert_all_mm =maxDistFromCenterVert_all_mm;
tg.gen.minDist_mm =minDist_mm;
tg.gen.tgtSlots_xy_mm =tgtSlots_xy_mm;
tg.gen.tgtSlotCodes =tgtSlotCodes;
tg.gen.colorCodes =colorCodes;
tg.gen.stim_r_mm =stim_r_mm;
tg.gen.sptCodes = sptCodes;

tg.presArea_mm =presArea_mm;            % These are actually used in task script
tg.start_pos_mm =start_pos_mm;
tg.array_pos_mm =array_pos_mm;
tg.triallistCols =triallistCols;
tg.triallist =triallist;
tg.start_r_mm =start_r_mm;
tg.white =white;
tg.black =black;
tg.grey =grey;
tg.stimColors =stimColors;
tg.bgColor =bgColor;
tg.startColor =startColor;
tg.phraseColor = phraseColor;
tg.textColor =textColor;
tg.colStrings =colStrings;
tg.sptStrings =sptStrings;

save(saveAt, 'tg');

%% show trials
if showTrialArrays
    trialViewer(saveAt);
end



