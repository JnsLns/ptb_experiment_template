
% add colors

% source array
arr_tmp = fullArrays{curSpt,curTs,curBalancingCategory}{curArray};

% Make and shuffle color pool
colorPool = colorCodes(randperm(numel(colorCodes)));

% Assign colors to items (this also
refColor = colorPool(1);
tgtColor = colorPool(2);
arr_tmp(refNumFromColorAssignment,3) = refColor ; %ref1
arr_tmp(tgtNumFromColorAssignment,3) = tgtColor; %tgt
arr_tmp(ref2NumFromColorAssignment,3) = arr_tmp(1,3); %ref2
arr_tmp(dtrNumFromColorAssignment,3) = arr_tmp(2,3); %dtr
colorPool(1:2) = [];
% other items: pick colors randomly from pool
for curItem = 5:size(arr_tmp,1)
    arr_tmp(curItem,3) = colorPool(ceil(rand*numel(colorPool)));
end

% Realize the different additional item conditions by turning certain items into fillers

% !!!!!!!!!!!!!!!

nAddItemConditions = 4; % IMPORTANT !!!! Adjust this if adding or removing addItem conditions

%!!!!!!!!!!!!!!!!

if ref2OrDtrReplacedByFillersNotDoubled
    
    switch curAddItemCondition
        case 1 % 1 = full second pair (code 1)
            makeFillerRows = [];
        case 2 % 2 = only second ref (make dtr filler)
            makeFillerRows = 4;
        case 3 % 3 = only dtr (make ref2 filler)
            makeFillerRows = 3;
        case 4 % 4 = no additional items (make ref2 and dtr fillers)
            makeFillerRows = [3 4];
        otherwise
            error('Additional item condition code not recognized.')
    end
    for curItem = makeFillerRows
        arr_tmp(curItem,3) = colorPool(ceil(rand*numel(colorPool)));
    end
    
elseif ~ref2OrDtrReplacedByFillersNotDoubled
        
    switch curAddItemCondition
        case 1 % 1 = full second pair (do nothing)
            %...
        case 2 % 2 = only second ref (change dtr-color to that of ref and ref2)            
            arr_tmp(4,3) = refColor;
        case 3 % 3 = only dtr (change ref2 color to that of dtr and tgt)
            arr_tmp(3,3) = tgtColor;
        case 4 % 4 = no additional items (make ref2 and dtr fillers)
            for curItem = [3 4]
                arr_tmp(curItem,3) = colorPool(ceil(rand*numel(colorPool)));
            end
        otherwise
            error('Additional item condition code not recognized.')
    end
            
end

% Determine number of items in target color
nTgts = sum(arr_tmp(:,3) == arr_tmp(2,3));



