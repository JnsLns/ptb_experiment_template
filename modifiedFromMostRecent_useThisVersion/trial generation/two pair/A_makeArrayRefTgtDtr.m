% This script generates different configurations of reference, target, and
% distracter items based on a parametrized fit function. The output list of
% target positions includes an approximately uniform distribution of target
% positions within a certain range of fit values relative to ref (0,0) and
% outside of a certain minimum distance to ref. Then, for each tgt position
% thus obtained, a set of distracters is generated within region of fits worse
% than that of the tgt pos at hand. The distracters will as well be distri-
% buted approximately uniformely within the eligible region.
%
% The main output of this script is the cell array prespecItems, which
% holds one set of ref-tgt-dtr items in each cell as a 3-by-2 matrix, whose
% columns are x/y coordinates. Secondary outputs are fitFun, a square
% matrix holding the spatial template that was used to construct the item
% arrays, and horzAx_mm and vertAx_mm, which are vectors giving the coordinate
% values (i.e., sampling points) corresponding to the columns and rows of
% fitFun, respectively (these coordinates correspond to values in the
% experimental script).

% IMPORTANT NOTE: 
% When tuning parameters for this script, it is important to take care
% that none of the generated item position falls outside of the overall
% stimulus region (i.e., the region in which later random filler-stimuli
% will be generated). A complication is that all configurations generated
% here will be used in translated form for each target slot (potential
% on-screen target positions) and in rotated form for the opposite spatial
% term. As a conservative criterion, the distance of ref and 
% dtr to the target items should in all arrays be smaller than the minimum
% distance of any target slot (potential target positions to which the array
% will be translated) to any border of the overall stimulus-region.

disp(['Generating ref-tgt-dtr configs for "', sptStrings{curSpt}, '" (phi_0=',num2str(phi_0),')']);

%% Compute fit function

% Make polar coordinate grid
% angular range (phi_range must include a range of 2*pi (full circle) and be centered on phi_0)
phi_range = linspace(phi_0-pi,phi_0+pi,phi_res); % angle, rad
% radial range
r_range =  linspace(0,max_r,r_res); % radius, mm
% grid
[phi,r] = meshgrid(phi_range,r_range);

% Compute polar version         
fitFun_polar = fitFunPol(phi,r,r_0,sig_r,phi_0,sig_phi,phi_flex,beta);
       
% Convert to cartesian version
[fitFun,horzAx_mm,vertAx_mm] = pol2cart2dMat(fitFun_polar,phi_range,r_range,x_res,y_res);

%% Make logical matrices with zeros around ref covering distance minDistTgtRef
% and minDistDtrRef

% template for distance of tgt to ref
[horzGrid, vertGrid] = meshgrid(horzAx_mm,vertAx_mm);
horzCntr = 0;
vertCntr = 0;
regionRadius = minDistTgtRef_mm;
minDistTgtRef_template = sqrt((horzGrid-horzCntr).^2+(vertGrid-vertCntr).^2) > regionRadius;

%% get target positions

% apply cutoff to fit function -> logical matrix with ones in regions above threshold
tgtRegion_logical = fitFun >= fitCutoff_tgt;

% iteratively come up with regularly spaced point grids of decreasing
% density, intersect each with set of all potential target positions as per
% fit cutoff, get number of overlapping points. Use first grid spacing for
% which this number is same or lower than desired number of targets (that
% is, if possible we will get as many target positions as we desire, if
% impossible, we will get the next lower number of target positions that
% is possible; this block also realizes min distance of tgts to ref)
stepSz = 0;
nActualTgts = inf;
while nActualTgts > nDesiredTgtPos
    
    % make regularly spaced grid of ones (increase step size each iteration);
    % symmetric across x and y axes (origin is ref item) as long as x_res and
    % y_res are odd.
    stepSz = stepSz+1;
    horzSpacing = zeros(1,x_res);
    vertSpacing = zeros(1,y_res);
    horzSpacing([ceil(x_res/2):-stepSz:1,(ceil(x_res/2)+stepSz):stepSz:x_res]) = 1;
    vertSpacing([ceil(y_res/2):-stepSz:1,(ceil(y_res/2)+stepSz):stepSz:y_res]) = 1;
    posGrid = conv2(horzSpacing,vertSpacing');
                                
    % apply grids and templates
    actualTgts_logical = tgtRegion_logical & posGrid & minDistTgtRef_template;
    nActualTgts = sum(sum(actualTgts_logical)); % number of eligible targets
    
end

% Get and store coordinates of actual target positions
actualTgts_lndcs = find(actualTgts_logical);
actualTgts_ssndcs = [];
[actualTgts_ssndcs(:,2),actualTgts_ssndcs(:,1)] = ind2sub(size(fitFun),actualTgts_lndcs);
actualTgts_coords = [horzAx_mm(actualTgts_ssndcs(:,1))',vertAx_mm(actualTgts_ssndcs(:,2))'];


%% make cell array, each cell holding a 3-by-2 matrix, with rows
% (1) ref x,y (2) tgt x,y 

prespecItems = cell(0);
ref_coords = [0,0];
for curTgt = 1:size(actualTgts_coords,1)
    curTgt_coords = actualTgts_coords(curTgt,:);
    prespecItems{end+1,1} = [ref_coords;curTgt_coords];    
end

%% show target & distracter positions

% Plot tgt and dtr position for debug (one tgt pos and all dtrs)
if any(showTgtAndDtrPositionsForSptCodes == curSpt)
    disp(['showing tgts/dtrs for spatial term: "', sptStrings{curSpt}, '"'])
    A2_trialGenerationDebugPlots;
end


