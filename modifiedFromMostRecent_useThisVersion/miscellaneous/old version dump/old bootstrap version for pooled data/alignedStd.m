% function [alignedStds, numVals] = alignedStd(data,useCols,denominatorFlag,alignRows,outputLength)
%
% Computes standard deviations over corresponding elements in multiple
% matrices that are supplied as elements of the cell array data. The matrices
% must have the same number of columns, but may differ in row number. The
% matrices are aligned at a row number that is supplied for each matrix in
% alignRows. Valid stds are computed across the values available in each row.
% IMPORTANT: When using this function to obtain stds of time series
% data, such as multiple movement trajectories, to produce meaningful stds
% the data needs to be interpolated first (if not sampled at congruent time
% intervals anyway), to ensure that across the included matrices corres-
% ponding row numbers will contain data from the same time points.
% (Use trajInterMatch to do interpolation that results in all trajectories
% being interpolated over a consistent grid of query points.)
% Output alignedStds is an n-by-m matrix, where n is determined by the
% combination of matrix lengths and aligment rows. M is equal to
% numel(useCols), if useCols is specified, or to the number of columns of
% the matrices in data. Output numVals is a column vector giving the
% number of values that were taken into account when computing the values
% in the corresponding row of alignedStds. 
%
% data: n-by-m cell array holding a matrix in each element with each
% matrix having the same number of columns (whereas differing column numbers
% are permitted).
%
% useCols (optional, default 0): row vector of column numbers that refer
% to the matrices in data and specify which columns of these should be used when
% computing the stds. The output matrix alignedStds will have the same number of
% columns as specified here. If all(useCols == 0), the number of columns will be
% extracted from the matrix in the first element of data.
%
% denominatorFlag (optional, default 1): specifies which denominator is 
% used to calculate stds. If 1, n-1 is used, thus computing the sample
% standard deviations. If 0, n is used, computing the population standard
% deviations. 
%
% alignRows (optional, default alignment is at first row): column vector
% providing for each matrix in data the row number at which it should be
% aligned with the other matrices before the stds are computed across the
% matrices. When passing [1] (or nothing) as alignRows, the matrices are
% aligned at their first rows. When passing [0] as alignRows, the matrices
% are aligned at their last rows. 
%
% outputLength (optional, default 0, i.e., no effect): Scalar value
% defining a desired row number for the output matrices (alignedStds
% and numVals). If the row number of the output matrices is below that
% value, they are padded to this row number using NaNs, if it is higher,
% the argument has no effect.



function [alignedStds, numVals] = alignedStd(data,useCols,denominatorFlag,alignRows,outputLength)

if nargin < 2  || all(useCols == 0)
    useCols = 1:size(data{1},2);
end

if nargin < 3
    denominatorFlag = 1;
end

if any(cellfun(@isempty, data))
    error('Cell array must not have empty cells')
end

if ~isa(data,'cell')  || numel(data) < 2
    error('Input data must be a cell array with at least two non-empty elements')
end

% ensure that data has only one column (avoids problems with permute function)
data = reshape(data,numel(data),1);

if nargin < 4 || all(alignRows == 1)
    alignRows = ones(numel(data),1);
elseif alignRows == 0;    
    alignRows = cellfun(@(x) size(x,1),data);
elseif size(alignRows,2) > 1    
    alignRows = alignRows';
end

if nargin < 5
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
tmpData_3d = cell2mat(permute(tmpData,[3 2 1]));
tmpOnes_3d = cell2mat(permute(tmpOnes,[3 2 1]));
tmpData_sum = sum(tmpData_3d,3);
tmpOnes_sum = sum(tmpOnes_3d,3);
means = tmpData_sum./tmpOnes_sum;

% Compute standard deviation
means_3d = repmat(means,1,1,size(tmpData_3d,3));
deviations_3d = (tmpData_3d - means_3d);
deviations_3d(~logical(tmpOnes_3d)) = 0;
sumOfSquares = sum(deviations_3d.^2,3);
if denominatorFlag
    subDf = 1;
else
    subDf = 0;
end
alignedStds = sqrt(sumOfSquares./(tmpOnes_sum-subDf));
%if any(isnan(alignedStds))
%    warning('Some NaN elements returned by alignedStd, probably due to denominatorFlag==1 in conjunction with at least one row having only one data point (leading to division by zero: [SumOfSquares/(n-1)] with n==1). This need not be a problem.');
%end

% pad result matrix with as many zero rows as needed to achieve desired output length
if outputLength > 0   
    alignedStds = [alignedStds;NaN(outputLength-size(alignedStds,1),size(alignedStds,2))];
end

if nargout > 1    
    % output how many data points were averaged for each row
    numVals = tmpOnes_sum(:,1);
    % as for stds pad to desired output length
    if outputLength > 0
        numVals = [numVals;NaN(outputLength-size(numVals,1),size(numVals,2))];
    end
end


end

