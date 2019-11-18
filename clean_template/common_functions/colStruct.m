
function str = colStruct(fieldname, nCols, str)
% function str = colStruct(fieldname, nCols, str)
%
% Create/extend a struct that in each of its fields holds a column number
% which addresses into data matrices generated in the context of
% experiments (e.g., trial lists, results lists). (This then allows to
% address that column through a field name, which makes addressing into
% those data matrices easier, i.e., you don't have to recall which column
% holds what data).
%
% __Example__ 
%
% s = colStruct('itemsize', 5)  % Omitting argument str creates new struct!
%                               % If nCols is larger than 1, two fields
%                               % will be created holding the start and end
%                               % column numbers for the given span and the
%                               % given field name will be prefixed with
%                               % 'Start' and 'End', respectively.
%
% s = colStruct('nItems', 1, s) % Including an existing struct name as argument
%                               % 's' adds a new field to the specified
%                               % struct.
%
% --> Result:
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
