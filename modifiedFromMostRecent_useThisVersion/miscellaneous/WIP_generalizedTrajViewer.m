

% colors is n-by-3 matrix holding color vectors; can be [], then uses 6 matlab default
% colors (in this case, this works only with a max of six color codes in the data!)


% showData =  {'correct', 'exceedsCurveThresh', 'movementTime_pc', 'additionalItemCondition', 'condition', 'tgtNumResponse'};
% dataNames =    {'correct', 'curved', 'MT', 'pair condition', 'condition', 'resp.n tgts'};
% % Label items based on item numbers stored in results 
% labelBy = {'tgt', 'ref', 'dtr', 'ref2'};
% labels = {'T', 'R', 'D', 'Rb'};
% %labelBy = {'tgt', 'tgt2'};
% %labels = {'T1', 'T2'};
% 
% trajViewer(a.tr, a.rs, [-a.s.presArea_mm(1)/2 a.s.presArea_mm(1)/2], [0 a.s.presArea_mm(2)], ...
%     a.s.resCols, a.s.trajCols, [], showData, dataNames, labelBy, labels)


function trajViewer(tr, rs, xAxLims, yAxLims, resCols, trajCols, colors, showData, dataNames, labelBy, labels, defaultRadius)
%
% ___Example___
%
%   showData =  {'correct', 'exceedsCurveThresh', 'movementTime_pc'};
%   dataNames = {'correct', 'curved'            , 'MT'             };
%   labelBy = {'tgt', 'ref', 'dtr', 'ref2'};
%   labels =  {'T'  , 'R'  , 'D'  , 'Rb'  };
%
%   trajViewer(a.tr, a.rs, ...
%              [-a.s.presArea_mm(1)/2 a.s.presArea_mm(1)/2], [0 a.s.presArea_mm(2)], ...
%              a.s.resCols, a.s.trajCols, [], showData, dataNames, labelBy, labels)
%
%
% ___Arguments___
%
% tr :  one dimensional cell array with one trajectory in each cell,
%       e.g., a.tr or a.rawDatBAK.tr 
%
% rs :  results matrix with one trial in each row, same order as tr, 
%       e.g., a.rs or a.rawDatBAK.rs
%
% xAxLims :  limits for x axis, 2-element vector. Should be adjusted to 
%            data coordinate frame. Can be taken, e.g. from
%            a.s.presArea_mm.
%
% yAxLims :  limits for y axis, 2-element vector. See xAxLims.
%
% resCols :  struct with fields holding results columns, e.g. a.s.resCols.
%
% trajCols :  struct with fields holding trajectory columns, e.g. a.s.trajCols.
%
% colors :  n-by-3 matrix holding RGB vectors; can be [], then uses 6 matlab default
%           colors (in this case, a max of six color codes are allowed in the data!)
%           Rows in the passed matrix should correspond to color codes provided
%           in rs(:,resCols.colorsStart:resCols.colorsEnd) in order to plot
%           items in the colors used during the experiment.
%
% showData :  cell array of strings referring to field names in resCols. The
%             corresponding data will be displayed in the status bar.
%
% dataNames :  cell array of strings, same length as showData. Each cell
%              corresponds to one cell in showData. The strings specify how
%              the data in showData will be labeled in the status bar.
%
% labelBy :  cell array of strings referring to field names in resCols. The 
%            data at the results column numbers stored in those fields will
%            be used to label items according to their roles.
%
% labels :  cell array of strings whose structure is the same as that of 
%           labelBy. It holds the labels that will be displayed over items
%           specified through labelBy.
%
% defaultRadius :  Item radius in mm. Optional, default 5. If not passed,
%                  the item radiuses provided in
%                  rs(:,resCols.itemRadiiStart:resCols.itemRadiiEnd) will
%                  be used. If left empty and these fields do not exist in
%                  resCols, the default (5) will be used.
%


defaultRadius = 5; % [mm] only used if no item radiuses stored in data

if nargin < 8 || isempty(colors)
    colors = get(groot,'DefaultAxesColorOrder');
end

nTrajs = numel(tr);
nItems = resCols.horzPosEnd-resCols.horzPosStart+1;

% figure size depending on screen size
ss = get(0,'screenSize');
fHeight = round(ss(4)*0.85);
fWidth = 0.72 * fHeight;
fPosHorz = round(ss(3)/2-fWidth/2);
fPosVert = ss(4)-fHeight-ss(4)*0.05;
trajPlots = figure('position',[fPosHorz fPosVert fWidth fHeight],'color', 'w', ...
                    'DockControls','off','MenuBar','none','Name', ...
                    'Trajectory Viewer', 'ResizeFcn', @fig_do_resize);
nextButton = uicontrol('style','pushbutton','string','next','position',[75 25 75 50],'callback',@pb_next_callback);
backButton = uicontrol('style','pushbutton','string','prev.','position',[0 25 75 50],'callback',@pb_back_callback);
IDsearch = uicontrol('style','edit','string','enter trial ID','position',[150 25 75 50],'callback',@ed_IDsearch_callback);

trajNumBox = uicontrol('style','text','string','','position',[0 0 fWidth 20],'fontsize',10);

xAxLabel = 'millimeters';
yAxLabel = 'millimeters';

curTraj = 1;
replot = 1;

while 1
    
    pause(0.0001);
    
    if ~ishandle(trajPlots)
        return
    end
    
    if replot
        
        
        % Get and display trajectory properties in status bar
        ID = num2str(rs(curTraj,resCols.trialID));        
        datStr = '';
        for datNum = 1:numel(showData)            
            try
                val = rs(curTraj,resCols.(showData{datNum}));
            catch
                val = 'n/a';
            end
            name = dataNames{datNum};            
            datStr = [datStr, ' | ', name, ': ', num2str(val)];
        end                
        set(trajNumBox,'string',['traj.#: ', num2str(curTraj), ' / ', num2str(nTrajs), ...
            ' |  trial ID: ', ID, datStr]);
                
        
        % Center of mass
        comCoords = sum([rs(curTraj,resCols.horzPosStart:resCols.horzPosEnd)',rs(curTraj,resCols.vertPosStart:resCols.vertPosEnd)'])/(nItems+1);
                
        
        % Delete everything from all axes
        allAxes = findobj(trajPlots,'type','axes');
        for axnum = 1:numel(allAxes)
            delete(allchild(allAxes(axnum)));
        end

        
        % Plot all items
        if isfield(resCols, 'itemRadiiStart')
            radii = rs(curTraj,resCols.itemRadiiStart:resCols.itemRadiiEnd)';
        else
            radii = defaultRadius*ones(nItems,1);
        end        
        curItems_xyr = [rs(curTraj,resCols.horzPosStart:resCols.horzPosEnd)', ...
            rs(curTraj,resCols.vertPosStart:resCols.vertPosEnd)', ...
            radii];
        
        
        % Set item colors
        curItems_colcodes = rs(curTraj,resCols.colorsStart:resCols.colorsEnd);                
        for curItem = 1:size(curItems_xyr,1)                        
            curFaceColor = colors(curItems_colcodes(curItem),:);
            curEdgeColor = [0 0 0];            
            rectangle('position',[curItems_xyr(curItem,1)-curItems_xyr(curItem,3), ...
                                  curItems_xyr(curItem,2)-curItems_xyr(curItem,3), ...
                                  curItems_xyr(curItem,3)*2, curItems_xyr(curItem,3)*2], ...
                                  'curvature',[1,1],'facecolor',curFaceColor,'edgeColor',curEdgeColor);                                                        
        end
        
        
        % Item labels
        for curLbl = 1:numel(labelBy)        
            try
                iNum = rs(curTraj, resCols.(labelBy{curLbl}));        
                tmpTxt = text(curItems_xyr(iNum,1), curItems_xyr(iNum,2), labels{curLbl}, 'HorizontalAlignment', 'Center');                        
            end
        end                                                                        
        
        
        set(gca,'nextplot','add');
        
        
        % mark center of mass of all items
        plot(comCoords(1),comCoords(2),'marker','d','markersize',10,...
            'markeredgecolor','k','markerfacecolor','y');
        
        
        % add time markers on trajectory
        tmStart = 0.1; % every 100 ms
        tmStep = 0.1;
        timePoints = tmStart:tmStep:max(tr{curTraj}(:,trajCols.t));
        lndcs = [];
        for i = 1:numel(timePoints)
            curTp = timePoints(i);
            [~,lndcs(end+1)] = min(abs(tr{curTraj}(:,trajCols.t)-curTp));
        end
        plot(tr{curTraj}(lndcs,trajCols.x),tr{curTraj}(lndcs,trajCols.y),'o',...
            'MarkerEdgeColor',[.25 .25 .25],'MarkerFaceColor','none','markersize',6);
        
                        
        % plot trajectory        
        plot(tr{curTraj}(:,trajCols.x),tr{curTraj}(:,trajCols.y),'linewidth',2,'color','b');
        axis equal; xlim(xAxLims); ylim(yAxLims); grid on; box on; xlabel(xAxLabel); ylabel(yAxLabel);
                                        
        set(gca,'nextplot','replacechildren');        
                
        replot = 0;
        
    end
    
end



    function fig_do_resize(hObject,varargin)        
        if exist('trajNumBox')           
            trajNumBox.Position(3) = hObject.Position(3);
        end
    end


    function pb_next_callback(~, callbackdata)
        
        if curTraj < nTrajs
            curTraj = curTraj + 1;
            replot = 1;
        end
        
    end

    function pb_back_callback(~, callbackdata)
        
        if curTraj > 1
            curTraj = curTraj - 1;
            replot = 1;
        end
        
    end

    function ed_IDsearch_callback(hObject, callbackdata)
        rowNum = [];
        rowNum = find(rs(:,resCols.trialID) == str2num(hObject.String));
        if ~isempty(rowNum)
            curTraj = rowNum;
            replot = 1;
        end
        set(IDsearch,'string','enter trial ID');
    end

end


