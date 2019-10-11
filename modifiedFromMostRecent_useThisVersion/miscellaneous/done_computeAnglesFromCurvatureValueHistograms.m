%% Compute curvature table for different angles

% s = 15; % [mm] segment length
% p1 = [s 0];
% p2 = [0 0]; % first segment goes from right to origin
% angles = linspace(pi,0,100000); % lefthanded angle starting from right x-axis determining where second segment points (start is origin)
%                               % note: currently covers only 0 to pi 
% for i = 1:numel(angles)
% 
%     alpha = angles(i);
%     p3(1) = cos(alpha)*s;
%     p3(2) = sin(alpha)*s;
%     curve = curvatureOsc([p1;p2;p3],0);    
%     result(i,1) = curve(2);
%     result(i,2) = alpha; % lefthanded angle starting from right x-axis determining where second segment points (start is origin)
%     result(i,3) = abs(pi-alpha); % That's the curvature value. Absolute deviation of second segment from formin a straight line with first segment straight line (i.e. absolute angle btw second segment and left x-axis)     
%     
% end
%plot(result(:,3),result(:,1));
%h = gca;
%h.XLim = [0 pi];
%h.XTick = [0 pi/2 pi];
%h.XTickLabels = {'0' 'pi/2' 'pi'};
%h.XLabel.String = 'pi - [angle between first and second segment]'; % that's the curvature measure

%% based on table from above
% anonymous function taking curvature as input and returning deviation
% angle from straightness
getAngl = @(x) result(abs(x-result(:,1))==min(abs(x-result(:,1))),3);

% for all values in current figures' a histogram
cf = gcf;
ch = findobj(cf,'type','histogram');
crvVals = ch.Data;

devVals = arrayfun(getAngl,crvVals);
cutoffDevAngle = 0.9335;
devValsNoncurve = devVals; devValsNoncurve(devValsNoncurve>cutoffDevAngle)=[];

[dip_all,p_all] = HartigansDipSignifTest(devVals,250) % curved and noncurved included
[dip_nc,p_nc] = HartigansDipSignifTest(devValsNoncurve,250) % only noncurved

%% make new histogram using same code as for old histogram
nf = figure; 
hh = histogram(devVals,100);
set(hh, 'edgecolor', 'none', 'facecolor','b')
xlabel('max. deviation from straightness [rad]');
close(cf)
%% 

