


% TODO The current implementation of adding a non-fitting third distracter
% results in only a third of all trials on average having a third
% distracter, because the 50/50 chance is applied only to trials where
% there is any item on the wrong side of the reference.

% Note: To get an idea of the screen and item region settings at work use 
% plotScreenStartMarkerItemRegionTgtSlots.m in the debug folder.

% The only positions that must be specified as absolute positions within
% the presentation area start_pos_mm and array_pos_mm; everything else is
% defined in relative ways (relative to array_pos or to each other...).

%% generate which trials?
saveAt = 's:\tmp.mat';

%% experimental screen settings
% note: all these are stored in the trial file and loaded in the experiment

% size of presentation area on experimental screen; this may not be larger
% than the actual screen extent (visible picture)
presArea_mm = [475 297]; % screen extent of PC leo35

% radius of start marker in millimeters
start_r_mm = 3.4;


% USE THIS FOR VERTICAL RESPONSES
% start marker position
screenHorzHalfSize_mm = presArea_mm(1)/2;
start_pos_mm = [screenHorzHalfSize_mm, 4.2];
% array position (position of the center of rectangular stimulus region 
% defined further below by maxDistFromCenterHorz_all_mm and
% maxDistFromCenterVert_all_mm)
array_pos_mm = [screenHorzHalfSize_mm, 205];


% % HORIZONTAL RESPONSES (LEFT TO RIGHT)
% % start marker position
% start_pos_mm(1) = (presArea_mm(1)-presArea_mm(2))/2 + 4.2; % position equivalent to horz exp
% start_pos_mm(2) = presArea_mm(2)/2; 
% % array position (position of the center of rectangular stimulus region 
% % defined further below by maxDistFromCenterHorz_all_mm and
% % maxDistFromCenterVert_all_mm)
% array_pos_mm(1) = (presArea_mm(1)-presArea_mm(2))/2 + 205;
% array_pos_mm(2) = presArea_mm(2)/2;


% stimulus radius in millimeters
stim_r_mm = 8.2;

% Plot tgt and dtr position for debug; enter spatial codes (defined further 
% below) for which fit function, tgt, and dtr positions should be plotted
% (one after the other).
showTgtAndDtrPositionsForSptCodes = [1 2 3 4];

% Show trial arrays in the end
showTrialArrays = 1;

%% Settings for generating tgt-ref-dtr arrays

% Parameters for fit function

max_r = 283.08;         % maximum angle [mm] up to which fit function is computed
                        % (fit values over cartesian space are computed later
                        % for a grid of coordinates ranging from -max_r to
                        % max_r; the number and spacing of points in that
                        % grid is determined by x_res and y_res, which are
                        % defined below)
r_0 = 0;                % mean of Gaussian over radius [mm]
sig_r = 46.66;          % width (SD) of Gaussian over radius [mm]
phi_0 = 0;              % mean of Gaussian function over angle [rad]
                        % NOTE: THIS SETTING HAS NO EFFECT because phi_0 is
                        % determined based on spatial term and taken from
                        % phi_0_bySptCode defined below.
sig_phi = pi/3;         % width (SD) of Gaussian over angle [mm]                        
beta = 25;              % steepness of sigmoid over radius (sets extreme angles to near zero)                     
phi_flex = pi/2-pi/25;  % distance of sigmoid inflection point from mean of Gaussian over angle (phi)
                        % (should normally be pi/2 or somewhat less
                        % than that, to cover about 180° of the angle
                        % opposite of the spatial term's main direction)
x_res = 801;            % horizontal resolution of cartesian version of fit
                        % function (should be odd number in order to get
                        % maximum precision symmetry across x-axis w.r.t
                        % target and dtr placements; also works with even
                        % numbers, though)
y_res = 801;            % vertical resolution of cartesian version of fit
                        % function (should be odd number in order to get
                        % maximum precision symmetry across y-axis w.r.t
                        % target and dtr placements; also works with even
                        % numbers, though)
phi_res = 500;          % resolution of polar function along angular dimension
                        % (number of points over interval [-pi,pi])
r_res = 500;            % resolution of polar function along radial dimension
                        % (number of points over interval [0,max_r])

                        
% phi_0 (orientation of the directed main axis of spatial term in radians,
% with zero = positive x-axis)) for the different spatial terms provided
% in sptCodes (below). These values are used both to generate ref-tgt-dtr
% configurations and to later determine fit of all items in the full array.
phi_0_bySptCode = [pi,0,pi/2,1.5*pi]; %left right above below    

% Codes corresponding to spatial templates (defined above by phi_0_bySptCode)
% and spatial terms (defined below by sptStrings). These codes are the
% linear indices addressing into the respective elements of these arrays
% and will be written to triallist column triallistCols.spt. IT IS
% EXTREMELY IMPORTANT THAT THE ORDER HERE CORRESPONDS TO THAT IN
% phi_0_bySptCode AND sptStrings!
sptCodes = [1,2,3,4];         

% Define spatial term strings
sptStrings{1} = ' links vom ';
sptStrings{2} = ' rechts vom ';
sptStrings{3} = ' über dem ';
sptStrings{4} = ' unter dem ';
               
               
% Parameters for choice of targets and distracters

% Targets

% fit value cutoff for target region
fitCutoff_tgt = 0.6;
% Set desired number of target positions (actual number obtained may be
% lower depending on whether a target position grid with appropriate spacing
% fits onto eligible target region; see A_makeArrayRefTgtDtr.m for details)
nDesiredTgtPos = 16;

% Distracters

% desired number of distracters per target position (note from nDesiredTgtPos
% applies here as well)
nDesiredDtrPos = 24;
% fit cutoff to determine distracter region (set this cutoff lower than tgt
% cutoff, such that dtr region is somewhat larger than tgt region; otherwise
% ill-fitting targets will result in very dense distracter regions)
fitCutoff_dtr = 0.4;
% minimum difference in fit value compared to target position for distracters
minFitDiffTgtDtr = 0.03;

% item-to-item distance constraints for non-fillers

% min euclidean distance midpoints tgt to ref (on same scale as maxRadius, defined above)
minDistTgtRef_mm = stim_r_mm*2+0.3;
% min euclidean distance midpoints dtr to tgt (on same scale as maxRadius, defined above)
minDistDtrTgt_mm = stim_r_mm*2+0.3;
% min euclidean distance midpoints dtr to ref (on same scale as maxRadius, defined above)
minDistDtrRef_mm = stim_r_mm*2+0.3;

%% Settings for random fillers

maxDistFromCenterHorz_all_mm = 92; 
maxDistFromCenterVert_all_mm = 92;
tgtSlots_xy_mm = [28.28 , 28.28; -28.28, 28.28; 28.28, -28.28; -28.28, -28.28];
tgtSlotCodes = [1,2,3,4];
noOfItems = 12;  % total number of Items, including prespecified ones (ref,tgt,main dtr)
minDist_mm = stim_r_mm*2+0.3; % minimum distance btw item centers
resetCrit_basicArray = 20; 

% desired position of center of mass of final array (ALL items) relative to
% the center of the rectangular stimulus region defined above by
% maxDistFromCenterHorz_all_mm and maxDistFromCenterVert_all_mm; note that
% this is done brute-force and thus eccentric positions are hard to get.
com_desired_mm = [0,0]; % mm
% max deviation of center of mass from desired position in either direction
tolerance_mm = 0.85; % mm

% minimum distance of opposite distracter (on "wrong" side of reference)
% from reference item along the main axis of the spatial term (midpoint distance).
% This determines not initial placement of that item, but only whether or
% not an item may be considered as an opposite distracter.
minDistRefOppoDtr_mm = 28.28;

%% item color settings

% Codes for colors assigned to items (these gain meaning from color-to-row
% assignment in stimColors, see below).
colorCodes = [1,2,3,4,5,6];

% Define colors
white = [1 1 1];
black = [0 0 0];
grey = [.5 .5 .5];
stimColors(1,:) = [1 0 0]; % red
stimColors(2,:) = [0 1 0]; % green
stimColors(3,:) = [0 0 1]; % blue
stimColors(4,:) = [1 1 0]; % yellow
stimColors(5,:) = [0 0 0]; % black
stimColors(6,:) = [1 1 1]; % white
bgColor = grey; % background
startColor = black; % color of start marker
phraseColor = black;
textColor = black;

% Define color words (should correspond to order of colors defined above)
colStrings{1,1} = 'Rote';  colStrings{1,2} = 'Roten';
colStrings{2,1} = 'Grüne'; colStrings{2,2} = 'Grünen';
colStrings{3,1} = 'Blaue'; colStrings{3,2} = 'Blauen';
colStrings{4,1} = 'Gelbe'; colStrings{4,2} = 'Gelben';
colStrings{5,1} = 'Schwarze'; colStrings{5,2} = 'Schwarzen';
colStrings{6,1} = 'Weiße'; colStrings{6,2} = 'Weißen';


%% run computations
BASE_trialGeneration; % this script file calls all other scripts and saves generated data
