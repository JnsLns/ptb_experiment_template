
% for this to work, trial generation has to have run until the end of
% A_makeArrayRefTgtDtr.m
%
% just uncomment desired plots and run

%horzAx_mm,vertAx_mm,fitFun

%% Show all target positions at once, cycle through tgt positions, show all dtr positions for current one
% once axis has been generated, button press will advance to next trial
tgtn = 0;
hGridFig = figure;
while 1
    tgtn = tgtn + 1;
    imagesc(horzAx_mm,vertAx_mm,fitFun);
    xlim([-70 70]); ylim([-70 70]);
    xlabel('millimeters'); ylabel('millimeters'); caxis([0 1]) ; colorbar;
    hold on
    try
        plot(actualTgts_coords(:,1),actualTgts_coords(:,2),'.','color','w','markersize',10); % all potential tgt positions
        plot(tgtsAndDtrs_coords{tgtn,1}(1),tgtsAndDtrs_coords{tgtn,1}(2),'x','color','r','markersize',10); % currently considered tgt
        plot(tgtsAndDtrs_coords{tgtn,2}(:,1),tgtsAndDtrs_coords{tgtn,2}(:,2),'o','color','k'); % dtrs
        hold off
        set(gca,'ydir','normal');
        waitforbuttonpress        
        axis square
    catch
        break
    end
end
try
    close(hGridFig);
end

%% Plot fit fun and target and general distracter regions using contour
% then cycle through target positions and dtr positions on buttonpress
% and show dtr region for each (left/right arrows = cycle through dtrs,
% up/down arrows = cycle through targets)

hRegionFig = figure;

imagesc(vertAx_mm,horzAx_mm,fitFun);
xlim([-70 70]); ylim([-70 70]);
xlabel('millimeters'); ylabel('millimeters'); caxis([0 1]) ; colorbar;

tgtRegion = tgtRegion_logical & minDistTgtRef_template;
dtrRegion = dtrRegion_logical & minDistTgtRef_template;

axis square
set(gca,'ydir','normal');

hold on;

try
    
    % after button press: add region boundaries
    waitforbuttonpress
    
    % plot tgt/dtr regions
    [hConTgt_contours, hConTgt] = contour(vertAx_mm,horzAx_mm,tgtRegion,[1 1],'LineColor','r','linewidth',3,'linestyle',':');
    [hConDtr_contours, hConDtr] = contour(vertAx_mm,horzAx_mm,dtrRegion,[1 1],'LineColor','g','linewidth',3,'linestyle',':');
    xlabel('millimeters'); ylabel('millimeters'); caxis([0 1]) ; colorbar;
    xlim([-70 70]); ylim([-70 70]);
    set(gca,'ydir','normal');
    title('potential positions of target and distracter midpoints')
    legend({'target region','distracter region'});
    % plot reference object radius
    plot(0,0,'.','color','W','markersize',25);
    rectangle('position',[-stim_r_mm -stim_r_mm stim_r_mm*2 stim_r_mm*2],'Curvature',[1 1],'edgecolor','w','linewidth',2);
    axis square
    title('fit function & item regions');
    
    % after button press... add target and dstr positions, cycling through targets
    waitforbuttonpress
    
    % Cycle through tgt and ref combinations and plot dtr regions for current tgt position
    axes;
    
    % Also cycle through distracters for each target?
    cycleThroughDtrs = 1;
    tgtn = 1; dtrn = 1; tgtChange = 0;
    while tgtn <= size(tgtsAndDtrs_coords,1)
        
        if ishandle(hRegionFig)
            % Plot fit fun, pos of current target, general target region and current distracter regions using contour
            tgtRegion = tgtRegion_logical & minDistTgtRef_template;
            % template for distance of tgt to ref
            [horzGrid, vertGrid] = meshgrid(horzAx_mm,vertAx_mm);
            horzCntr = actualTgts_coords(tgtn,1);
            vertCntr = actualTgts_coords(tgtn,2);
            regionRadius = minDistDtrTgt_mm;
            minDistDtrTgt_template = sqrt((horzGrid-horzCntr).^2+(vertGrid-vertCntr).^2) > regionRadius;
            curTgtFit = fitFun(actualTgts_lndcs(tgtn));
            dtrRegion = dtrRegion_logical & (fitFun <= curTgtFit-minFitDiffTgtDtr) & minDistDtrTgt_template & minDistTgtRef_template;
        else
            break
        end
        
        try
            
            while dtrn <= size(tgtsAndDtrs_coords{tgtn,2},1)
                
                hold off;
                
                % plot fit function
                imagesc(vertAx_mm,horzAx_mm,fitFun);
                
                hold on;
                
                % plot tgt/dtr regions
                [hConTgt_contours, hConTgt] = contour(vertAx_mm,horzAx_mm,tgtRegion,[1 1],'LineColor','r','linewidth',3,'linestyle',':');
                [hConDtr_contours, hConDtr] = contour(vertAx_mm,horzAx_mm,dtrRegion,[1 1],'LineColor','g','linewidth',3,'linestyle',':');
                
                % plot reference object
                plot(0,0,'.','color','W','markersize',25);
                rectangle('position',[-stim_r_mm -stim_r_mm stim_r_mm*2 stim_r_mm*2],'Curvature',[1 1],'edgecolor','w','linewidth',2);
                axis square
                
                % plot current target position
                plot(tgtsAndDtrs_coords{tgtn,1}(1),tgtsAndDtrs_coords{tgtn,1}(2),'.','color','r','markersize',25);
                rectangle('position',[tgtsAndDtrs_coords{tgtn,1}(1)-stim_r_mm, ...
                    tgtsAndDtrs_coords{tgtn,1}(2)-stim_r_mm, ...
                    stim_r_mm*2 stim_r_mm*2],'Curvature',[1 1],'edgecolor','r','linewidth',2);
                
                % plot distracter
                plot(tgtsAndDtrs_coords{tgtn,2}(dtrn,1),tgtsAndDtrs_coords{tgtn,2}(dtrn,2),'.','color','g','markersize',25);
                rectangle('position',[tgtsAndDtrs_coords{tgtn,2}(dtrn,1)-stim_r_mm, ...
                    tgtsAndDtrs_coords{tgtn,2}(dtrn,2)-stim_r_mm, ...
                    stim_r_mm*2 stim_r_mm*2],'Curvature',[1 1],'edgecolor','g','linewidth',2);
                
                % axes settings
                xlabel('Millimeters'); ylabel('Millimeters'); caxis([0 1]) ; colorbar;
                xlim([-70 70]); ylim([-70 70]);
                set(gca,'ydir','normal');
                legend({'target region','distracter region'});
                
                % Left/right buttons cycle through dtrs, up/down through targets
                while 1
                    waitforbuttonpress; curChar = get(gcf,'currentkey');
                    switch curChar
                        case 'rightarrow'
                            dtrn = min(dtrn+1,size(tgtsAndDtrs_coords,2));
                            break
                        case 'leftarrow'
                            dtrn = max(1,dtrn-1);
                            break
                        case 'uparrow'
                            tgtn = min(tgtn+1,size(tgtsAndDtrs_coords,1));
                            tgtChange = 1;
                            dtrn = 1;
                            break
                        case 'downarrow'
                            tgtn = max(1,tgtn-1);
                            tgtChange = 1;
                            dtrn = 1;
                            break
                        otherwise
                            continue
                    end
                end
                
                if tgtChange
                    tgtChange = 0;
                    break
                end
            end
            
        catch
            break
        end
        
    end
    
end

try
    close(hRegionFig)
end
