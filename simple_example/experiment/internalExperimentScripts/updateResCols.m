% After each trial, go through all fields of 'out' and add those fields
% to e.s.resCols that weren't present on previous trials.
for fName = fieldnames(out)'
    
    % Check that object in the field is integer or row vector
    sz = size(out.(fName{1}));
    if numel(sz)>2 || sz(1) > 1
        error(['Output objects in fields of struct ''out'' must ', ...
            'be integers or row vectors but ''out.', fName{1}, ...
            ''' has size [', num2str(sz), '].']);
    end        
        
    % for the first trial where current field of 'out' is used (i.e., does
    % not exist in e.s.resCols yet): add field (or start/end fields) to
    % e.s.resCols
    if ~isfield(e.s.resCols, fName{1})
    
        e.s.resCols = colStruct(fName{1}, sz(2), e.s.resCols);
        
    % if current field of 'out' already exists in 'e.s.resCols', check that 
    % the size of the object in 'out' matches number of elements specified
    % in 'e.s.resCols'.
    else
        
        if isfield(e.s.resCols, ([fName{1}, 'Start']))  % multiple elements
            if e.s.resCols.([fName{1}, 'End']) - ...
               e.s.resCols.([fName{1}, 'Start']) + 1 ...
               ~= sz(2)                          
               error(['Number of elements of output object in ', ...
                      '''out.', fName{1} ,''' does not match number', ...
                      ' of elements specified in ''e.s.resCols''.']);        
            end
        elseif sz(2) ~= 1                               % single element
            error(['Output object in ''out.', fName{1} , ''' was expected', ...
                   ' to have one element (based on ''e.s.resCols'') but', ...
                   ' has ', num2str(sz(2)), '.']);
        end        
        
    end        
    
end