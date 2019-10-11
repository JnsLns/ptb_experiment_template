% function [alignedMeans, numVals] = alignedMean(data,useCols,alignRows,outputLength)
%
% Computes means over corresponding elements in multiple matrices that are
% supplied as elements of the cell array data. The matrices must have the
% same number of columns, but may differ in row number. The matrices are
% aligned at a row number that is supplied for each matrix in alignRows.
% Valid means are computed across the values available in each row.
% IMPORTANT: When using this function to obtain averages of time series
% data, such as multiple movement trajectories, to produce meaningful means
% the data needs to be interpolated first (if not sampled at congruent time
% intervals anyway), to ensure that across the averaged matrices corres-
% ponding row numbers will contain data from the same time points.
% (Use trajInterMatch to do interpolation that results in all trajectories
% being interpolated over a consistent grid of query points.)
% Output alignedMeans is an n-by-m matrix, where n is determined by the
% combination of matrix lengths and aligment rows. M is equal to
% numel(useCols), if useCols is specified, or to the number of columns of
% the matrices in data. Output numVals is a column vector giving the
% number of values that were taken into account when computing the values
% in the corresponding row of alignedMeans. 
%
% data: n-by-m cell array holding a matrix in each element with each
% matrix having the same number of columns (whereas differing column numbers
% are permitted).
%
% useCols (optional, default 0): row vector of column numbers that refer
% to the matrices in data and specify which columns of these should be used when
% computing the means. The output matrix alignedMeans will have the same number of
% columns as specified here. If all(useCols == 0), the number of columns will be
% extracted from the matrix in the first element of data.
%
% alignRows (optional, default alignment is at first row): column vector
% providing for each matrix in data the row number at which it should be
% aligned with the other matrices before the average is computed across the
% matrices. When passing [1] (or nothing) as alignRows, the matrices are
% aligned at their first rows. When passing [0] as alignRows, the matrices
% are aligned at their last rows. 
%
% outputLength (optional, default 0, i.e., no effect): Scalar value
% defining a desired row number for the output matrices (alignedMeans
% and numVals). If the row number of the output matrices is below that
% value, they are padded to this row number using NaNs, if it is higher,
% the argument has no effect.


function [alignedMeans, numVals] = alignedMean(data,useCols,alignRows,outputLength)

if nargin < 2  || all(useCols == 0)
    useCols = 1:size(data{1},2);
end

if any(cellfun(@isempty, data))
    error('Cell array must not have empty cells')
end

if ~isa(data,'cell')  || numel(data) < 2
    error('Input data must be a cell array with at least two non-empty elements')
end

% ensure that data has only one column (avoids problems with permute function)
data = reshape(data,numel(data),1);

if nargin < 3 || all(alignRows == 1)
    alignRows = ones(numel(data),1);
elseif alignRows == 0;    
    alignRows = cellfun(@(x) size(x,1),data);
elseif size(alignRows,2) > 1    
    alignRows = alignRows';
end

if nargin < 4
    outputLength = 0;   
end
    

% Working copy of relevant data columns
tmpData = cellfun(@(x) x(:,useCols),data, 'uniformoutput',0);

% Determine required padding for each matrix at start and end to achieve
% total length of overall mean matrix
padRowsPre = num2cell(max(alignRows) - alignRows);
lengthsPost = cellfun(@(tr,ar) size(tr,1)-ar,tmpData,num2cell(alignRows));
padRowsPost = num2cell(max(lengthsPost)-lengthsPost);   
padCols = numel(useCols);

% Construct matrices that have ones where input matrices actually have values,
% pad each matrix to size of final mean matrix using zeros
tmpOnes = cellfun(@(dat,pre,post) [zeros(pre,padCols); dat.^0; zeros(post,padCols)] ...
    ,tmpData, padRowsPre, padRowsPost, 'uniformoutput', 0);

% same padding as above, for actual data
tmpData = cellfun(@(dat,pre,post) [zeros(pre,padCols); dat; zeros(post,padCols)], ...
    tmpData, padRowsPre, padRowsPost, 'uniformoutput',0);

% determine means
tmpData = sum(cell2mat(permute(tmpData,[3 2 1])),3);
tmpOnes = sum(cell2mat(permute(tmpOnes,[3 2 1])),3);
alignedMeans = tmpData./tmpOnes;

% pad result matrix with as many zero rows as needed to achieve desired output length
if outputLength > 0   
    alignedMeans = [alignedMeans;NaN(outputLength-size(alignedMeans,1),size(alignedMeans,2))];
end

if nargout > 1    
    % output how many data points were averaged for each row
    numVals = tmpOnes(:,1);       
    % as for means pad to desired output length
    if outputLength > 0
        numVals = [numVals;NaN(outputLength-size(numVals,1),size(numVals,2))];
    end    
end

end

