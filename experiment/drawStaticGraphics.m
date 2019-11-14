% Draw things to offscreen windows that are static across trials.

% Draw fixation cross to center of winsOff.fix.rect. 
fr_px = vaToPx(e.s.fixRadius_va, e.s.spatialConfig)*2;
flw_px = vaToPx(e.s.fixLineWidth_va, e.s.spatialConfig);
lineItem(winsOff.fix.h, [fr_px fr_px], [3 3], {[4 6],[2 8]}, flw_px, ...
         e.s.fixColor, [winsOff.fix.rect(3)/2, winsOff.fix.rect(4)/2])    

% Draw start marker to winsOff.startMarker.h
 [sm_xy_ptb_px(1), sm_xy_ptb_px(2)] = ...
    paVaToPtbPx(e.s.startPos_va(1), e.s.startPos_va(2), e.s.spatialConfig);
Screen('DrawDots', winsOff.startMarker.h, sm_xy_ptb_px, ...
        vaToPx(e.s.startMarkerRad_va, e.s.spatialConfig)*2, ...
        e.s.startMarkerColor, [], 1);