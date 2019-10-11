
% add colors 
for curSpt = 1:size(fullArrays,1)
    for curTs = 1:size(fullArrays,2)
        for curArray = 1:numel(fullArrays{curSpt,curTs})
            
            arr_tmp = fullArrays{curSpt,curTs}{curArray};
            
            % Make and shuffle color pool
            colorPool = colorCodes(randperm(numel(colorCodes)));
            
            % Assign colors to items
            arr_tmp(1,3) = colorPool(1); %ref
            arr_tmp(2,3) = colorPool(2); %tgt
            arr_tmp(3,3) = arr_tmp(2,3);  %dtr                                              
            colorPool(1:2) = [];
            % other items: pick colors randomly from pool
            for curItem = 4:size(arr_tmp,1)                           
                arr_tmp(curItem,3) = colorPool(ceil(rand*numel(colorPool)));                
            end            
            % then, if there are items on opposite side of spatial term, 
            % pick one and color it in target color; do this with .5 probability                       
            potOppoDtrs = [];
            switch curSpt
                case 1 % left (find items that are right)
                    potOppoDtrs = find(arr_tmp(:,1)-arr_tmp(1,1)>minDistRefOppoDtr_mm);
                case 2 % right (find items that are left)
                    potOppoDtrs = find(arr_tmp(:,1)-arr_tmp(1,1)<-minDistRefOppoDtr_mm);
                case 3 % above (find items that are below)
                    potOppoDtrs = find(arr_tmp(1,2)-arr_tmp(:,2)>minDistRefOppoDtr_mm);
                case 4 % below (find items that are above)
                    potOppoDtrs = find(arr_tmp(1,2)-arr_tmp(:,2)<-minDistRefOppoDtr_mm);
            end
            if ~isempty(potOppoDtrs) && round(rand)                                             
                arr_tmp(potOppoDtrs(ceil(rand*numel(potOppoDtrs))),3) = arr_tmp(2,3);                
            end                                                
            
            % Determine number of items in target color 
            nTgts = sum(arr_tmp(:,3) == arr_tmp(2,3));            
            
            fullArrays{curSpt,curTs}{curArray} = arr_tmp;
            
        end
    end
end