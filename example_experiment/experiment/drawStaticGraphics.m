% Draw graphics that remain unchanged over trials to offscreen windows.
% Use the window pointers stored in struct 'winsOff.myWindow.h'.
% The coordinate frame for drawing is of course the Psychtoolbox frame,
% units are pixels. Use functions 'vaToPx' and 'paVaToPtbPx' to convert
% from visual angle to that frame. See folder 'common_functions' for these
% functions documentations and other conversion functions you may use.

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