function [tipPos_pa, trackerTime, dataGood, vzData] = getTip_pa(experimentSettingsStruct) 
%function [tipPos_pa, trackerTime, dataGood, vzData] = getTip_pa(experimentSettingsStruct) 
%
% Get tip position (tipPos_ps) in presentation-area-based coordinate frame
% (origin bottom left of presentation area, x-axis increasing to the right,
% y-axis increasing upward, z-axis increasing in viewer direction) in
% millimeters.
%
% This wraps transformedTipPosition, adding transformation from
% marker-based reference frame to presentation area frame and offset
% defined by markerCRFoffset_xyz.
%
% The sole argument experimentSettingsStruct is the struct of settings
% created in the experimental code as 'e.s'.

es = experimentSettingsStruct;

% tip pos in frame based on screen-mounted markers
[ttp, trackerTime, dataGood, vzData] = ...
transformedTipPosition(...
es.markers.coordinate_IDs, ...
es.pointer.markerIDs, ...
es.pointer.coefficients, ...
es.pointer.VelocityThreshold, ...
es.pointer.markerPairings, ...
es.pointer.expectedDistances, ...
es.pointer.DistanceThreshold);
    
% apply offset 
ttp = ttp + es.markerCRFoffset_xyz;

% Convert to presentation area frame
tipPos_pa = scrMmToPaMm_xyz(ttp, es.spatialConfig);

end