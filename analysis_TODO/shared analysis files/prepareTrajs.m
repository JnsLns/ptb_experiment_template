% Preparation of trajectory data
%
% The final result here is that all trajectories start at 0,0 and end on
% positive y-axis (both transformations are performed for all relevant
% spatial results data).
%
% --Brief description of steps:
%
% (1) Trim trajectories based on move on- and offset times
% (2) Make trajectory timestamps relative to movement onset
% (3) Transform each trajectory to start at 0,0 and end on positive y-axis
%     (same for item positions and start positions in matrix a.rs)
%
% --Details:
%
% (1) Trims trajectories based on movement onset and offset times (where
% movement onset is defined as first data after crossing velocity threshold
% and movement offset is defined as last data after crossing the outer
% radius of the ultimately chosen item).
%
% (3) Rectifies individual trajectories in cell array
% a.tr, i.e., translates and rotates trajectories to be parallel
% to y-axis and such that first data point lies in the coordinate
% origin (if a.s.doRotation and/or a.s.doTranslation == 1; exact rotation
% depends on how reference directions are determined, see
% setting a.s.chosenItemDefinesRefDir). This step is also done for the
% data about start marker position in matrix a.rs (columns
% a.s.resCols.startPosX and a.s.resCols.startPosY) as well as for all
% item positions in the results matrix.
%
% Togther: What's transfromed and thus usable in analysis from now on (and
% all other position data IS NOT):
%
% - Trajectories 
%       - a.tr
% - Stimulus item positions in results matrix
%       - a.rs(:,a.s.resCols.horzPosStart:a.s.resCols.horzPosEnd)
%       - a.rs(:,a.s.resCols.vertPosStart:a.s.resCols.vertPosEnd)
% - Start position in results matrix
%       - a.rs(:,[a.s.resCols.startPosX,a.s.resCols.startPosY])
%
%               !!!!AND NOTHING ELSE!!!!

disp('Rotating/translating trajectories...');

%% Cut trajs btw move on- and offset times
fromToTime = [a.rs(:,a.s.resCols.moveOnset_pc),a.rs(:,a.s.resCols.moveOffset_pc)];
a.tr = trajCut(a.tr,0,fromToTime,3);

%% Convert trajectory timestamps

% from [seconds since system startup] to [relative to movement onset times]
a.tr = cellfun(@(x) [x(:,1), x(:,2), x(:,3)-x(1,3)],a.tr,'uniformoutput',0);

%% Rotation and translation of each trajectory

% determine reference directions for rotation as vector between first point
% of each trajectory and the center of the *chosen* stimulus in
% that trial. (else: reference directions are the lines btw.
% 1st and last point of each traj).
trajStarts_xy = cell2mat(cellfun(@(x) x(1,[a.s.trajCols.x, a.s.trajCols.y]), a.tr,'uniformoutput',0)); 
if a.s.chosenItemDefinesRefDir                                                  

    % Get position of chosen item for each trial
    chosen_xy = zeros(size(a.rs,1),2);
    for curRow = 1:size(a.rs,1)
        chosen_xy(curRow,:) = [a.rs(curRow,a.s.resCols.horzPosStart - 1 + a.rs(curRow,a.s.resCols.chosen)), ...
            a.rs(curRow,a.s.resCols.vertPosStart - 1 + a.rs(curRow,a.s.resCols.chosen))];
    end
            
    a.s.refDirs_xy = chosen_xy - trajStarts_xy;
else
    a.s.refDirs_xy = 0;
end  

% rectify trajectories: translate and rotate trajectories to be parallel to
% y-axis and such that first data point lies in the coordinate origin; exact
% rotation depends on how reference directions are determined, see above.

if a.s.doRotation     
    a.tr = trajRot(a.tr,2,[a.s.trajCols.x,a.s.trajCols.y],a.s.refDirs_xy,0);                    
else
    warning('rectification disabled!');
end

if a.s.doTranslation
   a.tr = trajShift(a.tr,1,[0 0],[a.s.trajCols.x,a.s.trajCols.y]);   
else
   warning('translation disabled!');   
end


% Item positions stored in matrix a.rs as well as start marker coordinates
% stored there are transformed accordingly as well (so that they are at the
% same position, relative to the trajectory, as before).
%
% use trajectories' first data points as axes (same as above) and use the
% same refDirs as above (thus, overall rotation is equivalent to whatever is
% done above and what is set in settings, a.s.chosenItemDefinesRefDir 0 or 1)
aTmp.rsTransformed = a.rs; %<-this is explained further below
for curRow = 1:size(a.rs,1)        
%     %Construct trajectory-like matrix out of values that need to be
%     %transformed, use first data point of respective traj' as hinge...
    posData_tmp = [trajStarts_xy(curRow,:); ...
        [a.rs(curRow,a.s.resCols.horzPosStart:a.s.resCols.horzPosEnd)',...
        a.rs(curRow,a.s.resCols.vertPosStart:a.s.resCols.vertPosEnd)'];...
        a.rs(curRow,[a.s.resCols.startPosX,a.s.resCols.startPosY])];
    % (see explanation for tmpPos below (*))
    tmpPos = cell2mat(trajRot(posData_tmp,2,[1 2],a.s.refDirs_xy(curRow,:),1));                    
    % ...then rotate & translate that grotesque thing                        
    if a.s.doRotation
        posData_tmp = cell2mat(trajRot(posData_tmp,2,[1 2],a.s.refDirs_xy(curRow,:),0));                
    end
    if a.s.doTranslation           
        posData_tmp = cell2mat(trajShift(posData_tmp,1,[0 0],[1 2]));
    end                        
    % remove trajectory start in first row
    posData_tmp = posData_tmp(2:end,:);           
    tmpPos = tmpPos(2:end,:); 
    % Put back to columns in a.rs
    a.rs(curRow,[a.s.resCols.horzPosStart:a.s.resCols.horzPosEnd,a.s.resCols.startPosX,...
        a.s.resCols.vertPosStart:a.s.resCols.vertPosEnd,a.s.resCols.startPosY]) ...
        = posData_tmp(1:end);    
    
    % (*) regardless of whether rotation/translation are enabled, always
    % make and temporarily store a version of results matrix with translated
    % and rotated coordinates, to enable computation of new results values
    % in prepareResults.m that depend on translation/rotation:         
    aTmp.rsTransformed(curRow,[a.s.resCols.horzPosStart:a.s.resCols.horzPosEnd,a.s.resCols.startPosX,...
        a.s.resCols.vertPosStart:a.s.resCols.vertPosEnd,a.s.resCols.startPosY]) ...
        = tmpPos(1:end);    
    
end



clearvars -except a e tg aTmp

