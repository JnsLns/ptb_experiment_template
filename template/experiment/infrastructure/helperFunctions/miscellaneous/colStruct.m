
function str = colStruct(fieldname, nCols, str)
% function str = colStruct(fieldname, nCols, str)
%
% Create/extend a struct that in each of its fields holds a column number,
% or a row vector of column numbers, that address into a data matrix. In
% context of experiments these data matrices would be things like trial
% lists, results lists, etc.. 
% Having a "column struct" (colStruct) allows to address into columns
% through a field name, which makes addressing into those data matrices
% easier, i.e., you don't have to recall which column holds what data.
% Also, addressing by name means you don't have to hardcode column numbers,
% so that code can be more flexibly reused. All you have to do is to carry
% along the column struct.
%
%
%                              ___Input___
%
% fieldname        string. Name of the new field to be added to the struct.
%
% nCols            integer. Number of column indices into the target data
%                  matrix that the field should hold.
%
% str              struct. The struct that you want to extend with the nre
%                  field. If this argument is ommitted, a new struct will
%                  be created.
%
%
%                             ___Output___
%
% str              Column struct.
%
%
%                       ___Examples and notes___
%
%
% For instance, if you have a column struct
%
%     s = 
% 
%       struct with fields:
% 
%          trialNumber: 1
%          stimulusPositions: [2 3 4]
%
% then, to retrieve stimulus positions from a matrix, instead of doing 
%
%     stimPositions = triallist(row, [1,2,3]);
%
% you can do
%
%     stimPositions = triallist(row, s.stimulusPositions);
%
% The current function is for automatically creating or automatically
% extending a column struct with a new field. To create a new column
% struct, omit the last argument. To extend an existing one, supply it as
% the last argument. For instance:
% 
%        s = colStruct('foo', 1);     % create new column struct 
%        s = colStruct('bar', 2, s)   % and extend it
%
%        s = 
%
%          struct with fields:
%
%            foo: 1
%            bar: [2 3]
%
% Note that the column numbers will be automatically chosen and low numbers
% are chosen first. Thus, if in an existing column struct non-contiguous
% numbers are used and then a new multi-column field is added, the column
% numbers may not be contiguous (this is not a problem):
%
%        s = colStruct('foo', 1);
%        s.bar = 3;                % skipping column 2
%        s = colStruct('baz', 2, s)
%
%        s = 
%
%          struct with fields:
%
%            foo: 1
%            bar: 3
%            baz: [2 4]

% new struct
if nargin < 3 || numel(fieldnames(str)) == 0

    str = struct;
    newCols = 1:nCols;

% existing struct    
else
    
    % Check that field does not exist already
    if ismember(fieldname, fieldnames(str))
        error(['Field ' fieldname ' already exists.']);
    end
    
    % Gather column numbers already in use
    usedColNums = [];
    for fname = fieldnames(str)'
        usedColNums = [usedColNums, str.(fname{1})];
    end
    
    % find the 'nCols' lowest unused column numbers.
    newCols = find(~ismember(1:max(usedColNums)+nCols, usedColNums), nCols);
    
end

str.(fieldname) = newCols;

