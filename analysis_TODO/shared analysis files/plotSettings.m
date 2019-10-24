%% Plot settings

disp('Reading plot settings...');

%% For non-trajectory plots

% aTmp.plotWhat_rs           results array from which data should be plotted (only means)
% aTmp.plotWhat_rs_errors    results array from which error bars should be plotted (e.g., Std);
%                                 leave empty [] to omit error bars
% aTmp.rsYLims                    Limits of vertical axis (1-by-2)
% aTmp.plotCol                    column in aTmp.plotWhat_rs from which data should be plotted

aTmp.rsYLims = [0,1.5];
aTmp.plotWhat_rs = a.res.avg;
aTmp.plotWhat_rs_errors = a.res.std; % may also be empty [] to omit errorbars
aTmp.plotCol = a.s.resCols.movementTime_pc;


%% For trajectory plots

% aTmp.plotWhat_tr              trajectory cell array from which trajectory data should be plotted;
%                               can be means or individual trajectories
% aTmp.plotWhat_tr_errors       trajectory cell array from whcih values for error
%                               bars (e.g., SDs) should be taken; leave empty [] to omit error bars
% aTmp.plotX                    If aTmp.plotX is scalar: Interpreted as column number of
%                               within aTmp.plotWhat_tr pointing to values that should be 
%                               plotted on horizontal axis (e.g. spatial x)
%                               If aTmp.plotX is vector: This vector is used as data for 
%                               horizontal axis for all lines.
% aTmp.plotX_errors             column number of x-errors (errors along horz axis)
%                               in error array (aTmp.plotWhat_tr_errors)
% aTmp.plotY                    same as aTmp.plotX for vertical axis
% aTmp.xLims                    axis limits for horizontal axis (1-by-2)
% aTmp.yLims                    axis limits for vertical axis (1-by-2)
% aTmp.xAxLbl                   string label for horizontal axis 
% aTmp.yAxLbl                   string label for vertical axis
% aTmp.yTkLoc                   tick location for vertical axis
% aTmp.yTkLbl                   tick labels for vertical axis (same order)

% See below for some prespecified examples.

% use this to select on from below:
meanTimeWarpedMmFromDirectPath = 1;
meanAlignedMmFromDirectPath_wTcutoff = 0; % note that ylim is set by a.s.tCutoff (even if a.s.doApplyTimeCutoff == 0)
MeanTimeWarpedXPosVsYPos = 0;

% mean // time-warped // mm deviation from direct path, against perc. time
if meanTimeWarpedMmFromDirectPath 
aTmp.plotWhat_tr = a.trj.wrp.pos.avg;
aTmp.plotWhat_tr_errors = a.trj.wrp.pos.std; % std btw pts as error bars
%aTmp.plotWhat_tr_errors = []; % no error bars
aTmp.plotX = a.s.trajCols.x;
aTmp.plotX_errors = aTmp.plotX;
aTmp.xLims = [-10,10];
aTmp.xAxLbl = 'dev. from direct path [mm]';
maxYLen = max(unique(cellfun(@(pwtr) size(pwtr,1),aTmp.plotWhat_tr)));
aTmp.plotY = 1:maxYLen;
aTmp.yAxLbl = '% of total movement time';
aTmp.yLims = [0,maxYLen];
aTmp.yTkLbl = [0:10:100];
aTmp.yTkLoc = linspace(aTmp.yLims(1),aTmp.yLims(2),numel(aTmp.yTkLbl));
end

% individual // (time-warped) // x-position against y-position 
% aTmp.plotWhat_tr = a.trj.wrp.pos.ind;
% aTmp.plotWhat_tr_errors = [];
% aTmp.plotX = a.s.trajCols.x;
% aTmp.plotX_errors = aTmp.plotX;
% aTmp.xLims = [-100,100];
% aTmp.xAxLbl = 'x-pos. [mm]';
% aTmp.plotY = a.s.trajCols.y;
% aTmp.yAxLbl = 'y-pos. [mm]';
% aTmp.yLims = [0 a.s.presArea_mm(2)];
% aTmp.yTkLbl = [0:10:a.s.presArea_mm(2)];
% aTmp.yTkLoc = linspace(aTmp.yLims(1),aTmp.yLims(2),numel(aTmp.yTkLbl));
% lineWidth = 0.75;

% mean // (time-warped) // x-position against y-position
if MeanTimeWarpedXPosVsYPos
aTmp.plotWhat_tr = a.trj.wrp.pos.avg;
aTmp.plotWhat_tr_errors = a.trj.wrp.pos.std;
aTmp.plotX = a.s.trajCols.x;
aTmp.plotX_errors = aTmp.plotX;
aTmp.xLims = [-20,20];
%aTmp.xLims = [0 a.s.presArea_mm(1)];
aTmp.xAxLbl = 'x-pos. [mm]';
aTmp.plotY = a.s.trajCols.y;
aTmp.yAxLbl = 'y-pos. [mm]';
aTmp.yLims = [0,240];
%aTmp.yLims = [0 a.s.presArea_mm(2)];
aTmp.yTkLbl = [0:10:250];
aTmp.yTkLoc = linspace(aTmp.yLims(1),aTmp.yLims(2),numel(aTmp.yTkLbl));
end

% mean // aligned // mm deviation from direct path, against abs. time since onset
% aTmp.plotWhat_tr = a.trj.alg.pos.avg;
% aTmp.plotWhat_tr_errors = a.trj.alg.pos.std;
% aTmp.plotX = a.s.trajCols.x;
% aTmp.plotX_errors = aTmp.plotX;
% aTmp.xLims = [-10,10];
% aTmp.xAxLbl = 'dev. from direct path [mm]';
% aTmp.plotY = linspace(0,a.s.padAlignedToLength*a.s.samplingPeriodForInterp,a.s.padAlignedToLength);
% %aTmp.plotY = a.s.trajCols.t;
% aTmp.yAxLbl = 'time since movement onset [s]';
% %aTmp.yLims = [0, max(cellfun(@(x) max(x(:,a.s.trajCols.t)),tr(rowSet_base)))];
% aTmp.yLims = [0, 1.2];
% aTmp.yTkLoc = aTmp.yLims(1):0.1:aTmp.yLims(2);
% aTmp.yTkLbl = aTmp.yTkLoc;
% 
% % Aligned with time cutoff
% % mean // aligned // mm deviation from direct path, against abs. time since onset
if meanAlignedMmFromDirectPath_wTcutoff
aTmp.plotWhat_tr = a.trj.alg.pos.avg;
aTmp.plotWhat_tr_errors = a.trj.alg.pos.std;
aTmp.plotX = a.s.trajCols.x;
aTmp.plotX_errors = aTmp.plotX;
aTmp.xLims = [-10,10];
aTmp.xAxLbl = 'dev. from direct path [mm]';
aTmp.plotY = linspace(0,a.s.padAlignedToLength*a.s.samplingPeriodForInterp,a.s.padAlignedToLength);
%aTmp.plotY = a.s.trajCols.t;
aTmp.yAxLbl = 'time since movement onset [s]';
%aTmp.yLims = [0, max(cellfun(@(x) max(x(:,a.s.trajCols.t)),tr(rowSet_base)))];
aTmp.yLims = [0, a.s.tCutoff];
aTmp.yTkLoc = aTmp.yLims(1):0.1:aTmp.yLims(2);
aTmp.yTkLbl = aTmp.yTkLoc;
end

% individual // time-warped // mm deviation from direct path, against perc. time
% aTmp.plotWhat_tr = a.trj.wrp.pos.ind;
% aTmp.plotWhat_tr_errors = [];
% aTmp.plotX = a.s.trajCols.x;
% aTmp.plotX_errors = aTmp.plotX;
% aTmp.xLims = [-35,35];
% aTmp.xAxLbl = 'dev. from direct path [mm]';
% aTmp.plotY = 1:151;
% aTmp.yAxLbl = '% of total movement time';
% aTmp.yLims = [0,151];
% aTmp.yTkLbl = [0:10:150];
% aTmp.yTkLoc = [0:10:150];
% a.s.lineWidth = 0.5;

% individual // (time-warped) // x-position against y-position //
% NON TRANSFORMED (translated & rotated)
% aTmp.plotWhat_tr = a.trj.wrp.pos.ind;
% aTmp.plotWhat_tr_errors = [];
% aTmp.plotX = a.s.trajCols.x;
% aTmp.plotX_errors = aTmp.plotX;
% aTmp.xLims = [0,a.s.presArea_mm(1)];
% aTmp.xAxLbl = 'x-pos. [mm]';
% aTmp.plotY = a.s.trajCols.y;
% aTmp.yAxLbl = 'y-pos. [mm]';
% aTmp.yLims = [0,a.s.presArea_mm(2)];
% aTmp.yTkLbl = [0:20:a.s.presArea_mm(2)];
% aTmp.yTkLoc = linspace(aTmp.yLims(1),aTmp.yLims(2),numel(aTmp.yTkLbl));
% lineWidth = 1;

% mean // (time-warped) // x-position against y-position //
% NON TRANSFORMED (not translated & rotated)
% aTmp.plotWhat_tr = a.trj.wrp.pos.avg;
% aTmp.plotWhat_tr_errors =  a.trj.wrp.pos.std;
% aTmp.plotX = a.s.trajCols.x;
% aTmp.plotX_errors = aTmp.plotX;
% aTmp.xLims = [0,a.s.presArea_mm(1)];
% aTmp.xAxLbl = 'x-pos. [mm]';
% aTmp.plotY = a.s.trajCols.y;
% aTmp.yAxLbl = 'y-pos. [mm]';
% aTmp.yLims = [0,a.s.presArea_mm(2)];
% aTmp.yTkLbl = [0:20:a.s.presArea_mm(2)];
% aTmp.yTkLoc = linspace(aTmp.yLims(1),aTmp.yLims(2),numel(aTmp.yTkLbl));
% lineWidth = 1.5;


% % mean // time-warped // vel. PERPENDICULAR to direct path, against perc. time
% aTmp.plotWhat_tr = a.trj.wrp.vel.avg;
% aTmp.plotWhat_tr_errors = a.trj.wrp.vel.std;
% aTmp.plotX = a.s.trajCols.x;
% aTmp.plotX_errors = aTmp.plotX;
% aTmp.xLims = [-100,100];
% aTmp.xAxLbl = 'speed in x-dir. [mm/s]';
% aTmp.plotY = 1:size(aTmp.plotWhat_tr{1},1);
% aTmp.yAxLbl = '% of total movement time';
% aTmp.yLims = [0,size(aTmp.plotWhat_tr{1},1)];
% aTmp.yTkLbl = [0:10:100];
% aTmp.yTkLoc = linspace(aTmp.yLims(1),aTmp.yLims(2),numel(aTmp.yTkLbl));

% % mean // time-warped // vel. in y-direction (i.e., parallel to axis on which target lies), against perc. time
% aTmp.plotWhat_tr = a.trj.wrp.vel.avg;
% aTmp.plotWhat_tr_errors = a.trj.wrp.vel.std;
% aTmp.plotX = a.s.trajCols.y;
% aTmp.plotX_errors = aTmp.plotX;
% aTmp.xLims = [0,400];
% aTmp.xAxLbl = 'y velocity [mm/s]';
% aTmp.plotY = 1:size(aTmp.plotWhat_tr{1},1);
% aTmp.yAxLbl = '% of total movement time';
% aTmp.yLims = [0,size(aTmp.plotWhat_tr{1},1)];
% aTmp.yTkLbl = [0:10:100];
% aTmp.yTkLoc = linspace(aTmp.yLims(1),aTmp.yLims(2),numel(aTmp.yTkLbl));
% plotRefPos = 0;
% 

% mean // aligned // vel. in y-direction (i.e., parallel to axis on which target lies), against time
% aTmp.plotWhat_tr =          a.trj.alg.vel.avg;
% aTmp.plotWhat_tr_errors =   a.trj.alg.vel.std;
% aTmp.plotX = a.s.trajCols.y;
% aTmp.plotX_errors = a.s.trajCols.y;
% aTmp.xLims = [0,400];
% aTmp.xAxLbl = 'y velocity [mm/s]';
% aTmp.plotY = linspace(0,a.s.padAlignedToLength*a.s.samplingPeriodForInterp,a.s.padAlignedToLength);
% aTmp.yAxLbl = 'time since movement onset [s]';
% aTmp.yLims = [0, 1.5];
% aTmp.yTkLoc = aTmp.yLims(1):0.1:aTmp.yLims(2);
% aTmp.yTkLbl = aTmp.yTkLoc;


% inidividual // aligned // vel. in y-direction (i.e., parallel to axis from first data point target center), against perc. time
% aTmp.plotWhat_tr = a.trj.wrp.vel.ind;
% aTmp.plotWhat_tr_errors = [];
% aTmp.plotX = a.s.trajCols.y;
% aTmp.plotX_errors = aTmp.plotX;
% aTmp.xLims = [-500,500];
% aTmp.xAxLbl = 'vert. vel. [mm/s]';
% aTmp.plotY = 1:size(aTmp.plotWhat_tr{1}{1},1);
% aTmp.yAxLbl = '% of total movement time';
% aTmp.yLims = [0,size(aTmp.plotWhat_tr{1}{1},1)];
% aTmp.yTkLbl = [0:10:100];
% aTmp.yTkLoc = linspace(aTmp.yLims(1),aTmp.yLims(2),numel(aTmp.yTkLbl));


% individual // warped // speed, against perc. time
% aTmp.plotWhat_tr = a.trj.wrp.spd.ind;
% aTmp.plotWhat_tr_errors = [];
% aTmp.plotX = a.s.trajCols.x;
% aTmp.plotX_errors = aTmp.plotX;
% aTmp.xLims = [-500,500];
% aTmp.xAxLbl = 'speed [mm/s]';
% aTmp.plotY = 1:size(aTmp.plotWhat_tr{1}{1},1);
% aTmp.yAxLbl = '% of total movement time';
% aTmp.yLims = [0,size(aTmp.plotWhat_tr{1}{1},1)];
% aTmp.yTkLbl = [0:10:100];
% aTmp.yTkLoc = linspace(aTmp.yLims(1),aTmp.yLims(2),numel(aTmp.yTkLbl));

% mean // warped // speed, against perc. time
% aTmp.plotWhat_tr = a.trj.wrp.spd.avg;
% aTmp.plotWhat_tr_errors = a.trj.wrp.spd.std;
% aTmp.plotX = a.s.trajCols.x;
% aTmp.plotX_errors = aTmp.plotX;
% aTmp.xLims = [-500,500];
% aTmp.xAxLbl = 'speed [mm/s]';
% aTmp.plotY = 1:size(aTmp.plotWhat_tr{1},1);
% aTmp.yAxLbl = '% of total movement time';
% aTmp.yLims = [0,size(aTmp.plotWhat_tr{1},1)];
% aTmp.yTkLbl = [0:10:100];
% aTmp.yTkLoc = linspace(aTmp.yLims(1),aTmp.yLims(2),numel(aTmp.yTkLbl));

% angular deviation 

% % mean // time-warped // momentary angular deviation of trajectory from line to target, against perc. time
% aTmp.plotWhat_tr = a.trj.wrp.ang.tgt.avg;
% aTmp.plotWhat_tr_errors = a.trj.wrp.ang.tgt.std; % std btw pts as error bars
% %aTmp.plotWhat_tr_errors = []; % no error bars
% aTmp.plotX = 1;
% aTmp.plotX_errors = 1;
% aTmp.xLims = [-pi/2,pi/2];
% aTmp.xAxLbl = 'ang. dev. from line to tgt [rad]';
% maxYLen = max(unique(cellfun(@(pwtr) size(pwtr,1),aTmp.plotWhat_tr)));
% aTmp.plotY = 1:maxYLen;
% aTmp.yAxLbl = '% of total movement time';
% aTmp.yLims = [0,maxYLen];
% aTmp.yTkLbl = [0:10:100];
% aTmp.yTkLoc = linspace(aTmp.yLims(1),aTmp.yLims(2),numel(aTmp.yTkLbl));
% 
% % mean // time-warped // momentary angular deviation of trajectory from line to reference, against perc. time
% aTmp.plotWhat_tr = a.trj.wrp.ang.ref.avg;
% aTmp.plotWhat_tr_errors = a.trj.wrp.ang.ref.std; % std btw pts as error bars
% %aTmp.plotWhat_tr_errors = []; % no error bars
% aTmp.plotX = 1;
% aTmp.plotX_errors = 1;
% aTmp.xLims = [-pi/2,pi/2];
% aTmp.xAxLbl = 'ang. dev. from line to ref [rad]';
% maxYLen = max(unique(cellfun(@(pwtr) size(pwtr,1),aTmp.plotWhat_tr)));
% aTmp.plotY = 1:maxYLen;
% aTmp.yAxLbl = '% of total movement time';
% aTmp.yLims = [0,maxYLen];
% aTmp.yTkLbl = [0:10:100];
% aTmp.yTkLoc = linspace(aTmp.yLims(1),aTmp.yLims(2),numel(aTmp.yTkLbl));
% 
% % mean // time-warped // momentary angular deviation of trajectory from line to reference, against perc. time
% aTmp.plotWhat_tr = a.trj.wrp.ang.dtr.avg;
% aTmp.plotWhat_tr_errors = a.trj.wrp.ang.dtr.std; % std btw pts as error bars
% %aTmp.plotWhat_tr_errors = []; % no error bars
% aTmp.plotX = 1;
% aTmp.plotX_errors = 1;
% aTmp.xLims = [-pi/2,pi/2];
% aTmp.xAxLbl = 'ang. dev. from line to dtr [rad]';
% maxYLen = max(unique(cellfun(@(pwtr) size(pwtr,1),aTmp.plotWhat_tr)));
% aTmp.plotY = 1:maxYLen;
% aTmp.yAxLbl = '% of total movement time';
% aTmp.yLims = [0,maxYLen];
% aTmp.yTkLbl = [0:10:100];
% aTmp.yTkLoc = linspace(aTmp.yLims(1),aTmp.yLims(2),numel(aTmp.yTkLbl));





% --------- Which means/trajectories to plot?

% aTmp.plotWhat_tr = a.trj.wrp.pos.ind;

% aTmp.plotWhat_tr = a.trj.alg.pos.avg;
% aTmp.plotWhat_tr_errors = a.trj.alg.pos.std;

% aTmp.plotWhat_tr = a.trj.wrp.pos.avg;
% aTmp.plotWhat_tr_errors = a.trj.wrp.pos.std;

% aTmp.plotWhat_tr = a.trj.wrp.acc.avg;
% aTmp.plotWhat_tr_errors = a.trj.wrp.acc.std;

% aTmp.plotWhat_tr = a.trj.wrp.vel.avg;
% aTmp.plotWhat_tr_errors = a.trj.wrp.vel.std;

% aTmp.plotWhat_tr = cellfun(@(tr) tr.*1000, a.trj.wrp.vel.avg, 'uniformoutput', 0);
% aTmp.plotWhat_tr_errors = cellfun(@(tr) tr.*1000, a.trj.wrp.vel.std, 'uniformoutput', 0);

% aTmp.plotWhat_tr_errors = [];
 

% --------- Which data from these? 

% --- X - Axis

% - shortest euclidean distance from "ideal path"
%
% aTmp.plotX = a.s.trajCols.x;
% aTmp.plotX_errors = aTmp.plotX;
% aTmp.xLims = [-35,35];
% aTmp.xLims = [-100,100];
% aTmp.xAxLbl = 'dev. from direct path [mm]';
%
%
% - vertical position (toward tgt)
%
% aTmp.plotX = a.s.trajCols.y;
% aTmp.plotX_errors = aTmp.plotX;
% aTmp.xLims = [0,300];


% --- Y - Axis

% - percentual time, for time-warped position data MEAN
%
% aTmp.plotY = 1:size(aTmp.plotWhat_tr{1},1);
% aTmp.yAxLbl = '% of total movement time';
% aTmp.yLims = [0,size(aTmp.plotWhat_tr{1},1)];
% aTmp.yTkLbl = [0:10:100];
% aTmp.yTkLoc = linspace(aTmp.yLims(1),aTmp.yLims(2),numel(aTmp.yTkLbl));

% - percentual time, for time-warped position data INDIVIDUAL TRAJS
%
% aTmp.plotY = 1:size(aTmp.plotWhat_tr{1}{1},1);
% aTmp.yAxLbl = '% of total movement time';
% aTmp.yLims = [0,size(aTmp.plotWhat_tr{1}{1},1)];
% aTmp.yTkLbl = [0:10:100];
% aTmp.yTkLoc = linspace(aTmp.yLims(1),aTmp.yLims(2),numel(aTmp.yTkLbl));

% - absolute time, for aligned mean trajectories 
%
% aTmp.plotY = a.s.trajCols.t;
% aTmp.yAxLbl = 'movement time [s]';
% aTmp.yLims = [0, max(cellfun(@(x) max(x(:,a.s.trajCols.t)),tr(rowSet_base)))];
% aTmp.yTkLoc = aTmp.yLims(1):0.1:aTmp.yLims(2);
% aTmp.yTkLbl = aTmp.yTkLoc;

% - space
%
% aTmp.plotY = a.s.trajCols.y;
% aTmp.yAxLbl = 'vertical position [mm]';
% aTmp.yLims = [min(cellfun(@(x) min(x(:,a.s.trajCols.y)),tr(rowSet_base))), max(cellfun(@(x) max(x(:,a.s.trajCols.y)),tr(rowSet_base)))];
% aTmp.yTkLoc = floor(aTmp.yLims(1)/10)*10:20:floor(aTmp.yLims(2)/10)*10;
% aTmp.yTkLbl = aTmp.yTkLoc;




clearvars -except a e tg aTmp



