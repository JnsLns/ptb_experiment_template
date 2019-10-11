% This script starts out with a n-by-2 matrix with x/y coordinates in its
% rows and generates additional items within the boundaries and constraints
% set in global settings such that the center of mass of the overall item 
% array is at 0,0 (+/- tolerance_mm setting).

% "Input" is
% curPrespecItems_xy

% make arrays until COM position is within tolerance_mm 
curCom = inf;
while norm(curCom - com_desired_mm) > tolerance_mm
    
    % Put prespecified items into list of items 
    items_xy = curPrespecItems_xy;            
    
    % loop over remaining items, filling item list
    nFailedPlacements = 0;            
    while size(items_xy,1)<noOfItems
        
        % if placing item failed too often, trash array and restart     
        failure = 0;
        if nFailedPlacements > resetCrit_basicArray            
            curCom = inf;
            break;
        end                        
        
        % --Randomly place item:        
                
        % Place with random horizontal/vertical distance from 0,0 (yields
        % rectangular array border)                      
        x_tmp = (-maxDistFromCenterHorz_all_mm+stim_r_mm) + rand*(maxDistFromCenterHorz_all_mm-stim_r_mm)*2;
        y_tmp = (-maxDistFromCenterVert_all_mm+stim_r_mm) + rand*(maxDistFromCenterVert_all_mm-stim_r_mm)*2;
                
        % Current items position in cartesian coordinates
        curItem_xy = [x_tmp, y_tmp];        
        
        % --Check placement constraints for newly placed item (redo if not satisfied)
                        
        % distance to center horizontally and vertically (separately)
        % (legacy; should not need to be checked, as items are generated
        % accroding to these constraints)
        if abs(curItem_xy(1))+stim_r_mm > maxDistFromCenterHorz_all_mm || abs(curItem_xy(2))+stim_r_mm > maxDistFromCenterVert_all_mm;            
            failure = 1;        
        end
        
        % Check distance of new item to all other items        
        itemDists = sqrt(sum((items_xy-repmat(curItem_xy, size(items_xy,1),1)).^2,2));                        
        % below minDist_mm for any item? If so, redo current placement
        if any(itemDists < minDist_mm)            
            failure = 1;            
        end
        
        if failure
            nFailedPlacements = nFailedPlacements+1;
            failure = 0;
            continue;
        end
        
        % If placement satisfies constraints, store item and go to next one
        items_xy(end+1,:) = [x_tmp, y_tmp];        
        
    end % loop over items
    
    curCom = sum(items_xy)/size(items_xy,1);
    
end % loop will end when COM position is within tolerance_mm

