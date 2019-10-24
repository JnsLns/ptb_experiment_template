
function str = colStruct(fieldname, nCols, str)
% function str = colStruct(fieldname, nCols, str)
%
% Create/extend a struct that in each of its fields holds a column number
% which addresses into data matrices generated in the context of
% experiments (e.g., triallists, results lists). (This then allows to
% address that column through a field name, which makes addressing into
% those data matrices easier, i.e., you don't have to recall which column
% holds what data).
%
% __For instance: 
%
% s = colStruct('itemsize', 5)  % Omitting argument str creates new struct!
% 
% s = colStruct('nItems', 1, s) % Adds nItems as new field
%
% __Outcome :
%
% s = 
%
%  struct with fields:
%
%    itemsizeStart: 1
%      itemsizeEnd: 5
%           nItems: 6


if nargin < 3 || numel(fieldnames(str)) == 0
    str = struct;
    maxCol = 0;
else
    % Get max column value already in use
    maxCol = max(structfun(@(x) x, str));
end

if nCols > 1
    
    fname1 = [fieldname, 'Start'];
    fname2 = [fieldname, 'End'];
    
    if ismember(fname1, fieldnames(str))
        error(['Field ' fname1 ' already exists.']);        
    end        
    
    str.(fname1) = maxCol + 1;
    str.(fname2)   = maxCol + nCols;
    
elseif nCols == 1
    
    if ismember(fieldname, fieldnames(str))
        error(['Field ' fieldname ' already exists.']);
    end
    
    str.(fieldname) = maxCol + 1;
    
end

end
