% Draw indicators to show in which direction the pointer has to be moved to
% arrive at the starting position (circle for distance, arrows for pointer
% inclination)


% To indicate distance from starting position:
% Draw circle around cursor, radius depending on distance from start,
% color changing when at starting position;
tipPos_ptb = paMmToPtbPx(tipPos_pa(1), tipPos_pa(2), e.s.spatialConfig);
if tipAtStart
    circleColor = e.s.circleColor_ok;
else
    circleColor = e.s.circleColor_notOk;
end
circleRect = ...
    rectFromPosSize([tipPos_ptb, distFromStart([1 1])*2]);
Screen('FrameOval', winOn.h, circleColor, ...
    circleRect, circleLineWidth_px, circleLineWidth_px);


% To indicate deviation from starting angle (only once tip at startpos):
% Draw arrows around start pos to show how to tilt pointer)
if tipAtStart && ~withinAngle
    
    % Preparations (could also be done outside of trial)
    c = e.s.angleArrowColor_va;
    w_px = vaToPx(e.s.angleArrowWidth_va, spatialConfig);
    h_px = vaToPx(e.s.angleArrowHeight_va, spatialConfig);
    lw_px = vaToPx(e.s.angleArrowLine_va, spatialConfig);
    startPosXy_ptb = ...
        paMmToPtbPx(e.s.startPos_mm(1), e.s.startPos_mm(2), spatialConfig);
    ecc_px = vaToPx(e.s.angleArrowEcc_va, spatialConfig);
    
    % Max angles btw markers and z-axis in planes, signed (neg. is left/down)    
    A_xz = zAngle([V(:,1),[0 0 0]',V(:,3)]);
    [A_xz, maxInd] =  max(A_xz);
    A_xz = A_xz * sign(V(maxInd,1));            
    A_yz = zAngle([[0 0 0]',V(:,2:3)]);
    [A_yz, maxInd] =  max(A_yz);
    A_yz = A_yz * sign(V(maxInd,2));
    
    % draw arrows for directions where angle is exceeded
    arrowsToDraw = {};
    if A_xz > e.s.pointerStartAngle         % left arrow (right side)
        arrPos_ptb = startPosXy_ptb + [ecc_px 0];
        arrowsToDraw{end+1} = {[7,3,9],[23,3]};
    elseif A_xz < -e.s.pointerStartAngle    % right arrow (left side)
        arrPos_ptb = startPosXy_ptb - [ecc_px 0];
        arrowsToDraw{end+1} = {[17,23,19],[23,3]};
    end    
    if A_yz > e.s.pointerStartAngle         % down arrow (above start)
        arrPos_ptb = startPosXy_ptb + [0 ecc_px];
        arrowsToDraw{end+1} = {[9,15,19],[11,15]};
    elseif A_yz < -e.s.pointerStartAngle    % up arrow (below start)
        arrPos_ptb = startPosXy_ptb - [ecc_px 0];
        arrowsToDraw{end+1} = {[7,11,17],[11,15]};
    end
    
    % draw 
    for arr = arrowsToDraw'
        lineItem(winOn.h, ...
            [w_px, h_px], [5,5], arr, lw_px, c, arrPos_ptb)
    end
    
    
end