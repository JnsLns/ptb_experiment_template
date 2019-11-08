% For example plots showing individual trajectories (i.e., not mean
% trajectories)

% Run parts of code as desired after making the respective axis current.

copyfig;

% if plotted against space
axis equal 

% make lines thin
set(findobj(gcf, 'type','line'),'linewidth',0.25,'color','b')

% use for each axis to reduce number of trajectories to 50
nKeep = 50;
allLines = findobj(gca,'type','line');
try    
    delInds = [ones(1,numel(allLines)-nKeep),zeros(1,nKeep)];
    delInds = delInds(randperm(numel(delInds)));
    delete(allLines(find(delInds)));
catch
    disp('not enough lines?');
end

% plotSettings block (evaluate before running trajPlot
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