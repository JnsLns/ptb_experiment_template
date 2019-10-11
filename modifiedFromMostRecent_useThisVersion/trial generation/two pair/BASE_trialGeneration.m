% this script file calls all other scripts and saves generated data

% use startAndSettings_trialGeneration.m to start trial generation

% steps:

% (1) Generate ref1-tgt configurations for each spatial term.
%     --> prespecItems_bySpts{curSpt}

% (2) Make second pairs for each pair from (1) by mirroring horizontally
%     for horizontal spatial terms or vertically for vertical term trials.
%     --> prespecPair2_bySpts{curSpt}

% (3) Translate each configuration from (1) such that tgt is in target
%     slot; each configuration is used once in each target slot.
%     --> prespecItems_bySptsAndTss{curSpt,curTgtSlotCode}

% (4) Place second pair from (2) in ref1/tgt arrays from (3); each second pair
%     is placed once for each balancing category
%     --> prespecItems_bySptsTssBalcat{curSpt,curTgtSlotCode,curBalancingCategory}

% (5) Add filler items to each array in prespecItems_bySptsTssBalcat
%     --> fullArrays{curSpt,curTs,curBalancingCategory}

% (6) Translate each array to actual position in presentation area
%     --> fullArrays{curSpt,curTs,curBalancingCategory}

% (7) Assign colors to items according to their roles as ref1, tgt, ref2,
%     dtr, and fillers; also realize "additional item conditions" (full 2nd
%     pair, only ref2, only dtr, only pair 1) by giving a filler color to
%     only fillers, ref2, dtr, or ref2 & dtr.
%     --> fullArrays_addItemConditions{curSpt,curTs,curBalancingCategory,curAddItemCondition}

% (8) Make triallist, assigning individual trials to participants at random 
%     by tagging each trial with temporary pts code. All "additional item
%     condition" variants of the otherwise equivalent trial are assigned to
%     the same participant. 

% (9) Compute fits for all items and add fit values to triallist.


%% Compute arrays

% Generate ref1-tgt configurations for each spatial term
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

% Make second pairs in an array equivalent in structure to prespecItems_bySpts
%
% currently, this is done by flipping tgt position in prespecItems_bySpts
% across either the y-axis (for spt-codes 1 or 2, i.e. left/right) or
% across the x-axis (for spt-codes 3 or 4, i.e. above/below); note that
% this works properly only if all coordinates are still centered on the
% reference item at [0,0].
%
% Although untested, using not mirrored but otherwise altered pairs should
% as well work with the rest of the code (as long as the form of the output
% of this step is retained)
prespecPair2_bySpts = cell(0);
for curSpt = 1:numel(prespecItems_bySpts)    
    for curTgt = 1:numel(prespecItems_bySpts{curSpt})                       
        prespecPair2_bySpts{curSpt}{curTgt,1} = prespecItems_bySpts{curSpt}{curTgt,1};       
        switch curSpt
            case {1,2}
                prespecPair2_bySpts{curSpt}{curTgt,1}(:,1) = prespecPair2_bySpts{curSpt}{curTgt,1}(:,1)*-1;
            case {3,4}
                prespecPair2_bySpts{curSpt}{curTgt,1}(:,2) = prespecPair2_bySpts{curSpt}{curTgt,1}(:,2)*-1;
        end
    end       
    
end

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


% Place second pair according to balancing category constraints
% For this, iterate over spt, targetslots, balancing categories,
% and the number of trials desired for current combination of the former.
% The output is prespecItems_bySptsTssBalcat. This cell arrays dimensions
% correspond to spt, tgtslots, and balancing categories, in this order. 
% Each of its cells holds another (row) cell array, which hold one
% configuration of ref1,tgt,ref2,and dtr in each of its cells, in the form
% of a 4-by-2 matrix, where rows correspond to said items in the order as
% mentioned and columns correspond to x and y coordinates (CRF centered on
% center of stimulus area).
% output cell array for second pair placement; same structure as prespecItems_bySptsAndTss
% plus balancing categories as third third dimension.
prespecItems_bySptsTssBalcat = cell(size(prespecItems_bySptsAndTss,1),size(prespecItems_bySptsAndTss,2),size(balancingCategories,1));
% iterate through prespecItems_bySptsAndTss (spts and tgtSlots) and through
% balancing categories. Use r1/tgt configurations from current cell of
% prespecItems_bySptsTssBalcat and complete each by adding a second pair at 
% a position such that balancing category is satisfied(*).
% If nDesiredTrialsPerSubcondition specifies that more trials are desired for
% subcondition at hand than r1/tgt configurations are available in
% prespecItems_bySptsAndTss, the list of configs is cycled through again.
% (*) In case the balancing category at hand cannot be satisfied based on
% the current r1/tgt configuration, the configuration is skipped and the
% next one is tried, so that not all configurations may actually be used
% (or not the same number of times). nTimesConfigsUsedPerSubcond records how many
% times each r1/tgt configuration is used in each subcondition.
pair2Counter = 1;
nTimesConfigsUsedPerSubcond = zeros(size(prespecItems_bySptsAndTss,1), size(prespecItems_bySptsAndTss,2), size(balancingCategories,1), nActualTgts);
nSkippedItemConfigs = zeros(size(prespecItems_bySptsAndTss,1),size(prespecItems_bySptsAndTss,2),size(balancingCategories,1));
nSkippedItemConfigsNumbers = cell(size(prespecItems_bySptsAndTss,1),size(prespecItems_bySptsAndTss,2),size(balancingCategories,1));
for curSpt = 1:size(prespecItems_bySptsAndTss,1)
    for curTgtSlotCode = 1:size(prespecItems_bySptsAndTss,2)       
        for curBalancingCategory = 1:size(balancingCategories,1)
            
            curR1TgtConfigNum = 1; % reset number of used item placement from prespecItems (ref & tgt).                        
            curTrial = 1; % reset trial counter
            
            % iterate through item configuration available for this condition combination
            % and place 2nd pair, until desired number of trials is achieved
            while curTrial <= nDesiredTrialsPerSubcondition(curSpt,curTgtSlotCode,curBalancingCategory)                                                                
                
               skipCurrentItemConfig = 0; % this is used within placeSecondPair to skip item configs
                                          % for which current balancing category cannot be satisfied
               placeSecondPair;
               
               % Count skipped item configs for each combination of spatial term, tgt slot, and balCat
               if skipCurrentItemConfig                   
                   
                   %DEBUG
                   if  any(curSpt == [1 2])
                       disp('BUT WHY!!?');
                   end
                   
                   nSkippedItemConfigs(curSpt,curTgtSlotCode,curBalancingCategory) = nSkippedItemConfigs(curSpt,curTgtSlotCode,curBalancingCategory) + 1;                                
                   if ~any(nSkippedItemConfigsNumbers{curSpt,curTgtSlotCode,curBalancingCategory} == curR1TgtConfigNum)
                       nSkippedItemConfigsNumbers{curSpt,curTgtSlotCode,curBalancingCategory}(end+1) = curR1TgtConfigNum;
                   end
               end
                                
               % if pair 2 placed successfully increment while-index of while loop
               if ~skipCurrentItemConfig                  
                  disp(['Placed pair2 ' num2str(pair2Counter) ' of ' num2str(sum(sum(sum(nDesiredTrialsPerSubcondition))))]);                  
                  curTrial = curTrial + 1;
                  pair2Counter = pair2Counter + 1;
               end
               
               % Use next item configuration on next loop iteration in any case
               % (roll around and restart config list when all r1/tgt configurations have been used)
               curR1TgtConfigNum = curR1TgtConfigNum+1;               
               if curR1TgtConfigNum > numel(prespecItems_bySptsAndTss{curSpt,curTgtSlotCode})
                    curR1TgtConfigNum = 1;
               end                                                
               
            end
            
        end        
    end
end



% TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO 
%
% this currently still operates on prespecItems_bySptsAndTss but should
% operate on prespecItems_bySptsTssBalcat; change that and make sure the
% additional items are included in the constraint check.
%
% Check whether any of the items in the generated ref-tgt-dtr arrays fall
% outside of the overall stimulus region; if so, issue warning.
% B_checkConstraintsRefTgtDtr;



% generate filler-items for each configuration of ref,tgt,ref2,dtr.
fullArrays = cell(size(prespecItems_bySptsTssBalcat));
for curSpt = 1:size(prespecItems_bySptsTssBalcat,1)
    for curTs = 1:size(prespecItems_bySptsTssBalcat,2)
        for curBalancingCategory = 1:size(prespecItems_bySptsTssBalcat,3)        
        for curArray = 1:numel(prespecItems_bySptsTssBalcat{curSpt,curTs,curBalancingCategory})            
            curPrespecItems_xy = prespecItems_bySptsTssBalcat{curSpt,curTs,curBalancingCategory}{curArray};
            C_addRandomFillerItems;
            fullArrays{curSpt,curTs,curBalancingCategory}{curArray} = items_xy;                        
            disp(['Generating fillers (spt: ' num2str(curSpt) ', tgtSlot: ' num2str(curTs) ', balCat: ' num2str(curBalancingCategory) ', arrNum: ' num2str(curArray) ')']);        
        end        
        end 
    end
end

% translate entire arrays to final array position specified by array_pos_mm
for curRow = 1:size(fullArrays,1)
    for curCol = 1:size(fullArrays,2)
        for curPage = 1:size(fullArrays,3)
            for curArr = 1:numel(fullArrays{curRow,curCol,curPage})
               fullArrays{curRow,curCol,curPage}{curArr} = fullArrays{curRow,curCol,curPage}{curArr} + repmat(array_pos_mm,size(fullArrays{curRow,curCol,curPage}{curArr},1),1);
            end            
        end
    end
end

% Assign colors to items and realize the different "additional item
% conditions " by turning certain items into filler; the output array holding item
% configurations is fullArrays_addItemConditions, which gains an additional
% (fourth) dimension for the different addItem conditions. Codes for these 
% conditions (and pages in fourth array dimension) are:
% 1 = full second pair 
% 2 = only second ref (give filler color to dtr)
% 3 = only dtr (give filler color to ref 2)
% 4 = no additional items (give filler colors to ref2 and dtr)
useItemConditions = [1 2 3 4];
% Define number/placement of different items in the color (and other) lists
refNumFromColorAssignment = 1;
tgtNumFromColorAssignment = 2;
ref2NumFromColorAssignment = 3;
dtrNumFromColorAssignment = 4;
fullArrays_addItemConditions = cell(size(fullArrays,1),size(fullArrays,2),size(fullArrays,4),numel(useItemConditions));
for curSpt = 1:size(fullArrays,1)
    for curTs = 1:size(fullArrays,2)
        for curBalancingCategory = 1:size(fullArrays,3)            
            for curArray = 1:numel(fullArrays{curSpt,curTs,curBalancingCategory})
                for curAddItemCondition = useItemConditions
                    E_assignColorsToItems;                    
                    fullArrays_addItemConditions{curSpt,curTs,curBalancingCategory,curAddItemCondition}{curArray} = arr_tmp;
                end
            end
        end
    end
end

% convert to trial list format usable by experiment script
F_makeTrialList;

% Determine fit values for all items and add to triallist
G_computeFits;

% Convert tgtSlots_xy_mm to absolute positions within the presentation
% area
tgtSlots_xy_mm(:,1) = array_pos_mm(1)+tgtSlots_xy_mm(:,1);
tgtSlots_xy_mm(:,2) = array_pos_mm(2)+tgtSlots_xy_mm(:,2);


%% save relevant variables

% Varibales not needed in the two-pair paradigm are replaced by nan.
if ~exist('nDtrPerTgt','var'); nDtrPerTgt = nan; end
if ~exist('nDesiredDtrPos','var'); nDesiredDtrPos = nan; end    
if ~exist('fitCutoff_dtr','var'); fitCutoff_dtr = nan; end    
if ~exist('dtrRegion_logical','var'); dtrRegion_logical = nan; end    
if ~exist('minFitDiffTgtDtr','var'); minFitDiffTgtDtr = nan; end    


%clearvars nDtrPerTgt nDesiredTgtPos fitCutoff_dtr

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



