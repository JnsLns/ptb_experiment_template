function [tipPos_pa, trackerTime, dataGood, vzData] = getTip_pa(experimentSettingsStruct) 
%function [tipPos_pa, trackerTime, dataGood, vzData] = getTip_pa(experimentSettingsStruct) 
%
% Get tip position (tipPos_pa) in presentation-area-based coordinate frame
% (origin bottom left of presentation area, x-axis increasing to the right,
% y-axis increasing upward, z-axis increasing in viewer direction) in
% millimeters.
%
% This wraps transformedTipPosition (part of pti_mocap_functions pack),
% adding transformation from marker-based reference frame to presentation
% area frame and applies an offset to the frame as defined by
% markerCRFoffset_xyz_mm.
%
% The sole argument experimentSettingsStruct is the struct of settings
% created in the experimental code as 'e.s'. IMPORTANTLY, it has to have
% the following fields (see settings of experiment for more info):
%
% e.s.markers.coordinate_IDs      IDs of markers that define coord. frame
% e.s.pointer.markerIDs           IDs of markers on the pointer
% e.s.pointer.coefficients        Coefficients determined during calibration
% e.s.pointer.velocityThreshold   threshold for marker jump check
% e.s.pointer.markerPairings      marker pairings for distance checks
% e.s.pointer.expectedDistances   expected distances between pointer markers
% e.s.pointer.distanceThreshold   threshold for marker distance check
% e.s.markerCRFoffset_xyz_mm      offset of marker CRF from physical markers
% e.s.convert                     allows conversion between CRFs / units


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

% Check that no accidental array broadcasting took place.
assert(all(size(ttp) == [1,3]), ['Assertion failed.', ...
    ' Maybe size(e.s.markerCRFoffset_xyz_mm) is not [1 3]?']);

% Convert to presentation area frame (z-coordinate is not converted since
% pa-frame does not have a z-axis or, in other words, shares the z-axis of
% the screen-based frame)
tipPos_pa = [es.convert.scrMm2PaMm(ttp(1), ttp(2))', ttp(3)];

end