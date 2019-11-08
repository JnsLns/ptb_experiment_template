
% This script determines the distance of the first data points (after
% trajectory trimming) from the start marker (relevant because this is the
% data point on the basis of which the direct path is computed).
%
% This has to be run after having preprocessed trajectories with
% rotation and translation (the former might not even matter though) but with
% trimming.

% NOTE: currently, incorrect responses and curved trajectories are excluded


smDia = 6.8; % start marker diamater in mm (only for plot)
smYPos = 4.2;

eucDistFromSM  = [];
coordsRelToSM  = [];
 actualCoords = [];
for i = 1:numel(a.tr)
    % skip incorrects
    if ~a.rs(i,a.s.resCols.correct) 
        continue
    end
    % skip curved
    if a.rs(i,a.s.resCols.exceedsCurveThresh) 
        continue
    end
    
    actualCoords(i,:) = a.tr{i}(1,[a.s.trajCols.x,a.s.trajCols.y]); 
    coordsRelToSM(i,:) = actualCoords(i,:) - [a.rs(i,a.s.resCols.startPosX),a.rs(i,a.s.resCols.startPosY)];
    eucDistFromSM(i) = norm(coordsRelToSM(i,:));
end

%min(eucDistFromSM)
%max(eucDistFromSM)
mean(eucDistFromSM)
std(eucDistFromSM)
% figure; plot(actualCoords(:,1),actualCoords(:,2),'x');
% rectangle('position',[a.rs(1,a.s.resCols.startPosX)-smDia/2,a.rs(1,a.s.resCols.startPosY)-smDia/2,smDia,smDia],'Curvature',[1 1]);
figure; plot(coordsRelToSM(:,1),coordsRelToSM(:,2),'x');
rectangle('position',[0-smDia/2,0-smDia/2,smDia,smDia],'Curvature',[1 1]);
axis equal
hax = gca;
hax.XLim = [-a.s.presArea_mm(1)/2,a.s.presArea_mm(1)/2]; 
hax.YLim = [-smYPos,a.s.presArea_mm(2)-smYPos]; 

figure; hist(eucDistFromSM,100)