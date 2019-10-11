

% Note: To get an idea of the screen and item region settings at work use 
% plotScreenStartMarkerItemRegionTgtSlots.m in the debug folder.

% The only positions that must be specified as absolute positions within
% the presentation area start_pos_mm and array_pos_mm; everything else is
% defined in relative ways (relative to array_pos or to each other...).

%% generate which trials?
saveAt = 's:\twoPairParadigm_allTrials_doubledAddItems.mat';

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
showTgtAndDtrPositionsForSptCodes = [];%[1 2 3 4];

% Show trial arrays in the end
showTrialArrays = 1;

% If 1, then in the "additional item conditions" 2 and 3 (i.e., onlyRef and
% onlyDtr), the removed item is replaced by a filler color.
% If 0, then the removed item is instead replaced by the color of the other
% item (e.g., if dtr is removed, it is replaced with the color of ref2)
ref2OrDtrReplacedByFillersNotDoubled = 0;

%% Settings for generating tgt-ref-dtr arrays

% Parameters for fit function

max_r = 283.08;         % maximum radius [mm] up to which fit function is computed
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
fitCutoff_tgt = 0.70; % was 0.6 in ther other paradigms
% Set desired number of target positions (actual number obtained may be
% lower depending on whether a target position grid with appropriate spacing
% fits onto eligible target region; see A_makeArrayRefTgtDtr.m for details)
nDesiredTgtPos = 40; % READ NOTE!!!!
% IMPORTANT NOTE: this should be adjusted to bsn (defined further below) such that
% bsn = nDesiredTgtPos * integer factor. This ensures that each target
% position is overall used in the same number of trials.

% DOES NOT APPLY TO TWO-PAIR PARADIGM
% Distracters
% desired number of distracters per target position (note from nDesiredTgtPos
% applies here as well)
% nDesiredDtrPos = 0;
% fit cutoff to determine distracter region (set this cutoff lower than tgt
% cutoff, such that dtr region is somewhat larger than tgt region; otherwise
% ill-fitting targets will result in very dense distracter regions)
%fitCutoff_dtr = 0.4;
% minimum difference in fit value compared to target position for distracters
%minFitDiffTgtDtr = 0.03;

% item-to-item distance constraints for non-fillers

% min euclidean distance midpoints tgt to ref (on same scale as maxRadius, defined above)
minDistTgtRef_mm = stim_r_mm*2+0.3;
% min euclidean distance midpoints dtr to tgt (on same scale as maxRadius, defined above)
minDistDtrTgt_mm = stim_r_mm*2+0.3;
% min euclidean distance midpoints dtr to ref (on same scale as maxRadius, defined above)
minDistDtrRef_mm = stim_r_mm*2+0.3;


%% Placement constraints for second pair
minDistPair2R1_mm = 6; % minimum distance of outer radius of 2nd pair items to ref1 outer radius
minDistPair2T_mm = 6;  % minimum distance of outer radius of 2nd pair items to tgt outer radius
stimAreaGridStepSz = 2; % step size [mm] of base grid within stimulus area; each grid point is a potential
% placement for the second reference object. Small values lead to finer grid
% but higher computation time (quadratic).
fitThreshAdd_dtr = 0.25; % Dtr may not be at position where it would fit current spatial term better than tgt,
% this is realized by ensuring fit(dtr,R1) < fit(tgt,R1)-fitThreshAdd_dtr
fitThreshAdd_r2 = 0.25; % Ref2 may not be at position where actual target would fit current spatial term better
% relative to ref2 than relative to ref1; this is realized by a template ensuring that
% fit(tgt,[all potential R2 placements]) < fit(tgt,R1)-fitThreshAdd_r2
minDirPathDistAdd = 3;    % minimum distance of second pair item borders (outer radius) to direct path
% maximum distance of outer stimulus radius to direct path
maxDirPathDist = 65; % maximum distance of second pair item borders (outer radius) to direct path
                     % (note that this introduces a strong constraint and may make placing certain
                     % pairs, i.e. large ones, impossible).

                     
%% Settings for random fillers

% maximum horizontal/vertical distance of items from center of array
% (this pertains not to placement of item centers, but items will be entirely
% within this region; in other word, item radius is taken into account)
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

%% balancing settings

% Use nDesiredTrialsPerSubcondition to specify the desired number of trials within
% each combination of spatial term (rows), target slot (columns), and
% balancing category (pages). It is usally sufficient to just set bsn and
% not alter nDesiredTrialsPerSubcondition directly.
%
% The idea is to force the same number of trials within each combination of
% spatial term × tgt slot × balancing category to facilitate balancing
% already during trial generation.
%
% A complication is that some of these combinations are impossible. This
% is because (for horizontal spatial terms in conjunction with vertical
% responses) the combination of spatial term and tgtSlot prescribes whether
% r1 and CoM are both on the same side of the direct path or not. If they
% are, "mixed" balancing categories for the second pair are impossible to
% form (i.e., r1s/cd and r1d/cs) and if they are not, then "same"-categories
% are impossible (i.e., r1s/cs and r1d/cd).
%
% Because of this, full balancing (i.e., including the approx. same number
% of trials from each balancing category in a mean trajectory) can only be
% achieved *across* spatial terms and target slots, that is, by considering
% "left" and "right" trials as one condition, as well as the left and
% right target slots. 
%
% (For vertical responses) This problem does not apply to the
% vertical spatial terms, as the combination of vertical terms and target
% slots does not correlate as severely with reference1 side relative to the
% the direct path. Thus, for vertical terms, balancing categories can each
% have the same number of trials (bsn, defined below).
%
% In the end, we want to have the same overall number of trials for the
% across-term analysis of vertical and horizontal terms, respectively. Since
% for the horizontal terms each combination of conditions and balancing
% categories exists for only one of the two combined spatial terms, the
% number of trials in each of these should be double the number of trials
% in each individual vertical term condition (i.e., bsn*2).
%
% If bsn is larger than the (actually obtained) number of target positions,
% then the script will go through the list of target positions available for
% the spatial term / tgtslot combination at hand (should be equal for all of
% these), starting over when the end of the list is reached. That is, tgt
% positions may be used multiple times. Note, however, that if bsn is not
% an exact multiple of the number of tgt positions it is not guaranteed
% that each position is used the same number of times (i.e., some may be
% used one time less)! 
%
% Furthermore, (for vertical responses) there will be vertical term trials
% in which certain balancing categories cannot be realized (e.g. rs/cs when
% ref1 and CoM are already on different sides of the direct path). In this
% case, the respective configuration will be skipped for the balancing
% category at hand. The actual number of usages for each ref1/tgt
% configuration and each combination of spatial term, target slot, and
% balancing category is recorded in nTimesConfigsUsedPerSubcond (4d matrix
% where dim 1 = spt, 2 = tgtSlot, 3 = balCat, 4 = configs).
%
%
% define balancing categories (row numbers correspond to balancing category
% codes used elsewhere); column 1 = ref 1 side, column 2 = CoM side; 1 =
% same side as second pair, 2 = different side than second pair.
% (row 1 = r1s/cs, 2 = r1s/cd, 3 = r1d/cs, 4 = r1d/cd)
balancingCategories = [1 1; 1 2; 2 1; 2 2];

% Strcture of matrix nDesiredTrialsPerSubcondition:
% rows = spatial terms (1 links, 2 rechts, 3 über, 4 unter)
% cols = tgt slots (1 top right, 2 top left, 3 bottom right, 4 bottom left)
% pages = balancing categories for pair2 (page number corresponds to balancing
% category codes and to row number of matrix 'balancing categories')
bsn = 40; % base number of trials in each combination 

% spt 1 ("links") , ts 1 (top right) 
nDesiredTrialsPerSubcondition(1,1,:) = [0 bsn*2 bsn*2 0];
% spt 2 ("rechts"), ts 1 (top right) 
nDesiredTrialsPerSubcondition(2,1,:) = [bsn*2 0 0 bsn*2];
% spt 3 ("über"), ts 1 (top right) 
nDesiredTrialsPerSubcondition(3,1,:) = [bsn bsn bsn bsn];
% spt 4 ("unter"), ts 1 (top right) 
nDesiredTrialsPerSubcondition(4,1,:) = [bsn bsn bsn bsn];
% spt 1 ("links") , ts 2 (top left) 
nDesiredTrialsPerSubcondition(1,2,:) = [bsn*2 0 0 bsn*2];
% spt 2 ("rechts"), ts 2 (top left) 
nDesiredTrialsPerSubcondition(2,2,:) = [0 bsn*2 bsn*2 0];
% spt 3 ("über"), ts 2 (top left) 
nDesiredTrialsPerSubcondition(3,2,:) = [bsn bsn bsn bsn];
% spt 4 ("unter"), ts 2 (top left) 
nDesiredTrialsPerSubcondition(4,2,:) = [bsn bsn bsn bsn];
% numbers in columns 1 and 2 apply analogously to columns 3 and 4 (lower
% target slots), therefore just replicate the former
nDesiredTrialsPerSubcondition(:,[3 4],:) = nDesiredTrialsPerSubcondition(:,[1 2],:);

%% Participant splitting
% Number of trials per participant (the last participant file may include
% fewer trials if total number not divisible by this number).
nTrialsPerPts = 512; % IMPORTANT: must be divisible without remainder by number of
                     % additional item conditions (usually 4) to enable
                     % all additional item variants of a given trial to be
                     % assigned to the same participant.

                     
%% run computations
BASE_trialGeneration; % this script file calls all other scripts and saves generated data
