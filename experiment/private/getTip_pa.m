function [tipPos_pa, trackerTime, dataGood, vzData] = getTip_pa(experimentSettingsStruct) 
%function [tipPos_pa, trackerTime, dataGood, vzData] = getTip_pa(experimentSettingsStruct) 
%
% Get tip position (tipPos_pa) in presentation-area-based coordinate frame
% (origin bottom left of presentation area, x-axis increasing to the right,
% y-axis increasing upward, z-axis increasing in viewer direction) in
% millimeters.
%
% This wraps transformedTipPosition, adding transformation from
% marker-based reference frame to presentation area frame and applies an
% offset to the frame as defined by markerCRFoffset_xyz_mm.
%
% The sole argument experimentSettingsStruct is the struct of settings
% created in the experimental code as 'e.s'.

es = experimentSettingsStruct;

% tip pos in coordinate frame based on screen-mounted markers
[ttp, trackerTime, dataGood, vzData] = ...
transformedTipPosition(...
es.markers.coordinate_IDs, ...
es.pointer.markerIDs, ...
es.pointer.coefficients, ...
es.pointer.velocityThreshold, ...
es.pointer.markerPairings, ...
es.pointer.expectedDistances, ...
es.pointer.distanceThreshold);
    
% apply offset 
ttp = ttp + es.markerCRFoffset_xyz_mm;

% Convert to presentation area frame
tipPos_pa = scrMmToPaMm_xyz(ttp, es.spatialConfig);

end