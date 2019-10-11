
% compute distance of all tgtSlots from stimulus region borders defined by
% maxDistFromCenterHorz_all_mm and maxDistFromCenterVert_all_mm.

prespecFailNdcs = [];

for curRow = 1:size(prespecItems_bySptsAndTss,1) % spatial terms
    for curCol = 1:size(prespecItems_bySptsAndTss,2) % target slots
        
        curSetOfConfigs = prespecItems_bySptsAndTss{curRow,curCol};
        
        for curPrespecItems = 1:size(curSetOfConfigs,1)
            
            curPrespecItems_xy = curSetOfConfigs{curPrespecItems};
            
            cpi_backup = curPrespecItems_xy;
            prespecFail = 0;            
            for curPrespecItem = 1:size(curPrespecItems_xy,1)
                
                curPrespecItems_xy = cpi_backup;
                curPrespecItem_xy = curPrespecItems_xy(curPrespecItem,:);
                curPrespecItems_xy(curPrespecItem,:) = [];
                                    
                % horz and vert distance from origin of array coordinates
                if abs(curPrespecItem_xy(1))+stim_r_mm > maxDistFromCenterHorz_all_mm || abs(curPrespecItem_xy(2))+stim_r_mm > maxDistFromCenterVert_all_mm;
                    prespecFail = 1;
                end
                
                if prespecFail
                    
                    % store index of problematic set (for later debug plotting)
                    prespecFailNdcs(end+1,1:3) = [curRow,curCol,curPrespecItems];
                    
                    warning(['The position of at least one prespecified item is incompatible with the current placement constraints. ',...
                        'Spatial term (row of prespecItems_bySptsAndTss): ' num2str(curRow) ', ' ...
                        'Target slot (column of prespecItems_bySptsAndTss): ' num2str(curCol) ', '...
                        'Item set number (cell number of cell array found at that index): ' num2str(curPrespecItems)]);                                        
                end
                
            end            
            curPrespecItems_xy = cpi_backup;
            
        end
    end
end