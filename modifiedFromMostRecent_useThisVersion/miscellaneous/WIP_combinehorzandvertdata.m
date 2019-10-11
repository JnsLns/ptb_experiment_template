
% Combine data from horizontal and vertical experiments

% Load vertical data and run this to backup that data 
a_vert.rs = a.rs;
a_vert.tr = a.tr;
a_vert.s.files = a.s.files;
a_vert.trials = a.trials;
aTmp_vert.rsTransformed = aTmp.rsTransformed;

% Load horizontal data and run this to recode as denoted below
% (this effectively changes plots by spatial term axis to plots by spatial
% term axis in relation to principal movement axis)
rsHorzTmp = a.rs;
a.rs(rsHorzTmp(:,a.s.resCols.spt) == 1,a.s.resCols.spt) = 3; % left to above
a.rs(rsHorzTmp(:,a.s.resCols.spt) == 2,a.s.resCols.spt) = 4; % right to below
a.rs(rsHorzTmp(:,a.s.resCols.spt) == 3,a.s.resCols.spt) = 1; % above to left
a.rs(rsHorzTmp(:,a.s.resCols.spt) == 4,a.s.resCols.spt) = 2; % below to right
% Note: rsTransformed not recoded!

% then run this to concatenate data
a.rs = [a.rs;a_vert.rs];
a.tr = [a.tr;a_vert.tr];
a.s.files = cat(2,a.s.files,a_vert.s.files);
a.trials = [a.trials;a_vert.trials];
aTmp.rsTransformed  = [aTmp.rsTransformed ;aTmp_vert.rsTransformed ];