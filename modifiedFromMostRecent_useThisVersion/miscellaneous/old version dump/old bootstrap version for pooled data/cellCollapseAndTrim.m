function collapsedArray = cellCollapseAndTrim(cellArr,collapseDim,catDim)
%
% "Collapses" a cell array along one of its dimensions (collapseDim). In 
% contrast to cellCollapse.m, this version of the function also trims
% arrays in the collapsed cells to the same size. Any data in the cells
% along the dimension collapseDim is concatenated with cat(catDim, data_1,
% ..., data_n) and stored in the first page of cells of collapseDim. All
% other pages are removed so that the returned array has size 1 along the
% dimension collapseDim. Apart from collapseDim, dimension sizes and overall
% dimensionality of the input array, as well as the order of dimensions are
% retained. 
%
% Trimming: Any data that is concatenated is first trimmed to the size of
% the smallest array that can be found within the set of cells that is combined.
% This is useful, e.g. , when combining column vectors of different lengths 
% and only the shared elements are of interest. Note that the size to which
% the arrays are trimmed is determined among the set of combined cells, not
% among all sets of the input array.
%
% This function works for both matrices and cell arrays as data within the
% input array. Note that the contents of cellArr must be valid inputs
% to cat(). If not specified, catDim is by default set to the same value as
% collapseDim.
%
%  Examples:
%
%  a = {[1 2],[3 4],[5 6 7 8 9];[7 8],[9 10],[11 12]}
%  a =
%       [1 2] [3 4]  [5 6 7 8 9]  % <- Note inconsistent size
%       [7 8] [9 10] [11 12]
%
%  b = cellCollapseAndTrim(a,2,2)
%  b =
%       [1 2 3 4 5 6]
%       [7 8 9 10 11 12]
%
%  c = cellCollapseAndTrim(a,2,1)
%  c =
%       [1 2
%        3 4
%        5 6]
%
%       [7 8
%        9 10
%       11 12]

if nargin < 3
   catDim = collapseDim; 
end

% make "lookup table" for conversion of linear indices to subscript indices
% in the current array (in this table, rows are linear indices, columns are
% dimensions of the input array)
for lndx = 1:numel(cellArr)
    ssndcs(lndx,:) = ind2subAll(size(cellArr),lndx);
end

% find all linear indices of cellArr where collapseDim is 1 (array will be
% collapsed onto that subarray)
collapseOntoSet_lndcs = find(ssndcs(:,collapseDim) == 1);

% loop over components of subarray onto which collapsing is done
for curTgt_num = 1:numel(collapseOntoSet_lndcs)
    
    % loop over components along collapse dim to find out minimum size for
    % each dimension of the data contained wihtin the individual cells.
    % This is later used to trim each data array to that size in order to
    % allow for collapsing cell arrays with originally differently sized
    % data.
    curDataSizes = [];
    for curSource_num = 1:size(cellArr,collapseDim)
        
        curTgt_lndx = collapseOntoSet_lndcs(curTgt_num);        
        curTgt_ssndx = ssndcs(curTgt_lndx,:);        
        curSource_ssndx = curTgt_ssndx;
        curSource_ssndx(collapseDim) = curSource_num;        
        curSource_lndx = find(ismember(ssndcs,curSource_ssndx,'rows'),1);        
        curDataSizes(end+1,:) = size(cellArr{curSource_lndx});                
        
    end
    
    curMinDataSizes = min(curDataSizes);
    
    % for preparation, trim data in first cell onto which everything else is collapsed.    
    cellArr{curTgt_lndx} = subArray(cellArr{curTgt_lndx},ones(1,numel(curMinDataSizes)),curMinDataSizes);      
    
    % loop over components along collapse dim and collapse onto first one
    % (which is part of the subarray from above)                  
    for curSource_num = 2:size(cellArr,collapseDim)
        
        curTgt_lndx = collapseOntoSet_lndcs(curTgt_num);
        curTgt_ssndx = ssndcs(curTgt_lndx,:);
        
        curSource_ssndx = curTgt_ssndx;
        curSource_ssndx(collapseDim) = curSource_num;
        
        curSource_lndx = find(ismember(ssndcs,curSource_ssndx,'rows'),1);
        
        cellArr{curTgt_lndx} = cat(catDim, cellArr{curTgt_lndx}, ...
            subArray(cellArr{curSource_lndx},ones(1,numel(curMinDataSizes)),curMinDataSizes));
        
    end
    
end

% Remove all cells but those that hold the collapsed data (dimensionality
% is retained).
ssStr = '';
for i = 1:collapseDim-1
    ssStr = [ssStr, ' :,'];
end
ssStr = [ssStr, ' 2:end'];
if collapseDim ~= numel(size(cellArr))
    for i = collapseDim+1:numel(size(cellArr))
        ssStr = [ssStr, ', :'];
    end
end
eval(['cellArr(', ssStr, ') = [];']);

collapsedArray = cellArr;


