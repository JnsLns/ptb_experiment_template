% Place second item pair

% position of R1 in stim area centered reference frame (pair 1 already at tgtSlot)
r1 = prespecItems_bySptsAndTss{curSpt,curTgtSlotCode}{curR1TgtConfigNum}(1,:);
% position of T (tgt) in stim area centered reference frame (pair 1 already at tgtSlot)
tp = prespecItems_bySptsAndTss{curSpt,curTgtSlotCode}{curR1TgtConfigNum}(2,:);

% Preparation of helper function for determining item side relative to direct path
strt = start_pos_mm - array_pos_mm; % start pos in CRF centered on stim area center
% function returns 1 if p left of line from strt to tp, 2 if right or on the line
% (note that current tp and start positions are not arguments but used statically in the function definition)
lrPoint = @(px,py)  (((tp(1)-strt(1))*(py-strt(2)) - (px-strt(1))*(tp(2)-strt(2)))<0)+1;

% Determine on which side of direct path second pair has to be placed to satisfy current balancing category
% (depends on side of R1 relative to direct path in current r1/tgt-configuration)
%
% get desired sides of ref1 and CoM relative to pair 2; this is prescribed
% by the current balancing category; % 1 = same as pair 2, 2 = different
desiredR1sideRTP2 = balancingCategories(curBalancingCategory,1);
desiredCOMsideRTP2 = balancingCategories(curBalancingCategory,2);
% Get actual side of ref 1 relative to direct path
r1SideRTDP = lrPoint(r1(1),r1(2));  % 1 left, 2 right
% Determine on which side of direct path to place pair2
switch desiredR1sideRTP2
    case 1 % r1 same as pair2
        desiredPair2SideRTDP = r1SideRTDP;
    case 2 % r1 different than pair2
        desiredPair2SideRTDP = 1+mod(r1SideRTDP,2);
end
% check whether this conforms to desired relation of CoM and pair 2
% (nDesiredTrialsPerSubcondition should usually be specified such that only trials
% are constructed for which this is the case; this is not entirely true, as e.g. for horizontal spatial terms
% trials in conjunction with vertical responses not all)
comP2_sameDiff = (1-(lrPoint(0,0) == desiredPair2SideRTDP))+1; % 1 = CoM and pair 2 are on same side, 2 = diff.
if desiredCOMsideRTP2 ~= comP2_sameDiff
    warning(['Balancing category ', num2str(curBalancingCategory) ,' cannot be satisfied by current configuration of ref1 and tgt (spt: ' num2str(curSpt) ', tgtSlot:' num2str(curTgtSlotCode) ', configNum:' num2str(curR1TgtConfigNum) '). Skipping and using next one.']);
    skipCurrentItemConfig = 1;
end

if ~skipCurrentItemConfig
    
    % make coordinate grid with extent of and centered on stimulus area
    xStimArea = -maxDistFromCenterHorz_all_mm:stimAreaGridStepSz:maxDistFromCenterHorz_all_mm;
    yStimArea = -maxDistFromCenterVert_all_mm:stimAreaGridStepSz:maxDistFromCenterVert_all_mm;
    [xg,yg] = meshgrid(xStimArea,yStimArea);
    
    % --- Make templates that realize placement constraints for second pair
    
    % Logical template for distance to borders of stimulus area (taking into
    % account stimulus radius)
    templ_margins = abs(xg) < maxDistFromCenterHorz_all_mm-stim_r_mm  &  abs(yg) < maxDistFromCenterVert_all_mm-stim_r_mm;
    
    % Logical template for min distance to R1 position
    templ_r1Dist = sqrt((xg-r1(1)).^2+(yg-r1(2)).^2) > (minDistPair2R1_mm+2*stim_r_mm);
    
    % Logical template for min distance to T position
    templ_tDist = sqrt((xg-tp(1)).^2+(yg-tp(2)).^2) > (minDistPair2T_mm+2*stim_r_mm);
    
    % Logical template for grid point being on desired side of direct path
    templ_side = arrayfun(lrPoint,xg,yg)==desiredPair2SideRTDP;
    
    % Logical template for minimum distance to direct path (center-to-direct path
    % distance of at least stim_r_mm)
    distsToDp = abs((tp(2)-strt(2))*xg - (tp(1)-strt(1))*yg + tp(1)*strt(2) - tp(2)*strt(1)) / sqrt((tp(2)-strt(2))^2+(tp(1)-strt(1))^2);
    templ_dirPathDistMin = distsToDp > stim_r_mm + minDirPathDistAdd;
    
    % NEW
    % Logical template for maximum distance (of outer stim radius) to direct path
    templ_dirPathDistMax = distsToDp < maxDirPathDist - stim_r_mm;
    
    % Logical template for potential distracter (target of r2) placement, i.e.,
    % all positions where, relative to r1, distracter would fit spatial term
    % worse (plus margin) than actual target.
    relTPos = tp-r1; % position of current tgt relative to r1
    tgtFit =  fitFunCrt(relTPos(1),relTPos(2),r_0,sig_r,phi_0_bySptCode(curSpt),sig_phi,phi_flex,beta); % fit value of tgt to R1
    templ_dFitR1 = fitFunCrt(xg-r1(1),yg-r1(2),r_0,sig_r,phi_0_bySptCode(curSpt),sig_phi,phi_flex,beta) < tgtFit-fitThreshAdd_dtr;
    
    % For each position in stimulus area as a potential placement of r2,
    % compute the relative position of target (t1) to that position (i.e., subtract
    % coordinate grid from target), then assess fit of these positions.
    templ_tFitR2 = fitFunCrt(tp(1)-xg,tp(2)-yg,r_0,sig_r,phi_0_bySptCode(curSpt),sig_phi,phi_flex,beta) < tgtFit-fitThreshAdd_r2;
    
    % overall template for distracter placement (all potential distracter positions)
    templ_dtr = templ_margins & templ_dirPathDistMin & templ_dirPathDistMax & templ_r1Dist & templ_tDist & templ_side & templ_dFitR1;
    % overall template for ref2 placement (all potential ref2 positions)
    templ_r2 = templ_margins & templ_dirPathDistMin & templ_dirPathDistMax & templ_r1Dist & templ_tDist & templ_side & templ_tFitR2;
    
    
    % --- Find potential positions for R2 and D and place second pair at one of them
    
    % dtr pos relative to r2
    d = prespecPair2_bySpts{curSpt}{curR1TgtConfigNum}(2,:);
    % non-discrete coordinates of distracter under assumption that r2 were placed at the respective grid point
    dGrid_x = xg + d(1);
    dGrid_y = yg + d(2);
    % for each point in this grid (i.e., each r2 placement), check whether the resulting distracter
    % position (closest grid point coordinate) is 1 in distracter template; if so, mark 1 in final
    % r2 placement template (i.e., r2 may be placed at this grid point and dtr
    % may be as prescribed by current configuration).
    templ_r2Final = zeros(size(templ_r2));
    %for curGridPoint = 1:numel(templ_r2Final)
    for curGridPoint = find(templ_r2)' % only test grid points where basic r2 template is 1
        posIsEligible = 0;
        % check that neither x nor y coordinate of distracter is outside of stimulus area
        if  ~(abs(dGrid_x(curGridPoint)) > maxDistFromCenterHorz_all_mm || ...
                abs(dGrid_y(curGridPoint)) > maxDistFromCenterVert_all_mm)
            
            lowestLogical_x = abs(xg-dGrid_x(curGridPoint)) == min(min(abs(xg-dGrid_x(curGridPoint))));
            lowestLogical_y = abs(yg-dGrid_y(curGridPoint)) == min(min(abs(yg-dGrid_y(curGridPoint))));
            % in case distracter placement for r2 at current grid point
            % would be within region prescribed by dtr template, this grid
            % point is an eligible placement for r2
            if templ_dtr(lowestLogical_y & lowestLogical_x)
                posIsEligible = 1;
            end
            
        end
        templ_r2Final(curGridPoint)=posIsEligible;
    end
    
    % Select one of the potential r2 positions from the grid at random
    lndcsEligible = find(templ_r2Final);
    if isempty(lndcsEligible)
        error('Current template for ref2 placement has no eligible entries. This likely stems from overly restrictive placement constraints and the second pair (ref2/dtr) being too large to fit anywhere.');
    end
    useLndx = lndcsEligible(ceil(rand*numel(lndcsEligible)));
    r2(1) = xg(useLndx);
    r2(2) = yg(useLndx);
    % Compute respective distracter position
    d_abs = r2+d;
    
    % store in output array
    if isempty(prespecItems_bySptsTssBalcat{curSpt,curTgtSlotCode,curBalancingCategory})
        prespecItems_bySptsTssBalcat{curSpt,curTgtSlotCode,curBalancingCategory} = cell(0);
    end
    prespecItems_bySptsTssBalcat{curSpt,curTgtSlotCode,curBalancingCategory}{end+1}(1,:) = r1;
    prespecItems_bySptsTssBalcat{curSpt,curTgtSlotCode,curBalancingCategory}{end}(2,:) = tp;
    prespecItems_bySptsTssBalcat{curSpt,curTgtSlotCode,curBalancingCategory}{end}(3,:) = r2;
    prespecItems_bySptsTssBalcat{curSpt,curTgtSlotCode,curBalancingCategory}{end}(4,:) = d_abs;    
    
    % Increment number of usages for this config    
    nTimesConfigsUsedPerSubcond(curSpt,curTgtSlotCode,curBalancingCategory,curR1TgtConfigNum) = ...
    nTimesConfigsUsedPerSubcond(curSpt,curTgtSlotCode,curBalancingCategory,curR1TgtConfigNum) + 1;
 
    % DEBUG PLOT
    disp(['spt: ' num2str(curSpt) ' tgtSlot: ' num2str(curTgtSlotCode) ' balcat: ' num2str(curBalancingCategory)]);
    imagesc(xStimArea,yStimArea,templ_r2Final); set(gca,'ydir','normal');
    hold on; axis equal;
    plot(r2(1),r2(2),'marker','o','color','r')
    plot(d_abs(1),d_abs(2),'marker','o','color','g')
    plot(r1(1),r1(2),'marker','x','color','r')
    plot(tp(1),tp(2),'marker','x','color','g')
    hold off
    drawnow
    
end
