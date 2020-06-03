% After each trial, go through all fields of 'out' and add those fields
% to e.s.resCols that weren't present on previous trials.
for fName = fieldnames(out)'
    
    fn = fName{1};
    
    % Check that object in the field is integer or row vector
    sz = size(out.(fn));
    if numel(sz)>2 || sz(1) > 1
        error(['Output objects in fields of struct ''out'' must ', ...
            'be integers or row vectors but ''out.', fn, ...
            ''' has size [', num2str(sz), '].']);
    end        
        
    % If that field does not exist in e.s.resCols yet, add it.
    % If it exists, check that the object in 'out' has the correct numel.
    if ~isfield(e.s.resCols, fn)    
        e.s.resCols = colStruct(fn, numel(out.(fn)), e.s.resCols);            
    else        
        if numel(e.s.resCols.(fn)) ~= numel(out.(fn))             
            error(['Number of elements of output object in ', ...
                '''out.', fn ,''' does not match number', ...
                ' of columns specified in ''e.s.resCols''.']);
        end        
    end        
    
end