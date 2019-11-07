
%%%% Construct or extend e.s.resCols based on fields of struct 'out'
%    (and on first run also transfer tg.s.triallistCols numbers)

% initialize e.s.resCols and check whether it's the first run 
if ~isfield(e.s, 'resCols')
    e.s.resCols = struct;
    isFirstRun = true;    
else 
    isFirstRun = false;
end

% After each trial, go through all fields of 'out' and add those fields
% to e.s.resCols that weren't present on previous trials.
for fName = fieldnames(out)'
    
    % Check that object in the field is integer or column vector
    sz = size(out.(fName{1}));
    if numel(sz)>2 || sz(1) > 1
        error(['Output objects in fields of struct ''out'' must ', ...
            'be integers or column vectors but ''out.', fName{1}, ...
            ''' has size [', num2str(sz), '].']);
    end        
    
    % for the first trial where current field of 'out' is used (i.e., does
    % not exist in e.s.resCols yet): add field (or start/end fields) to
    % e.s.resCols
    if ~isfield(e.s.resCols, fName{1}) && ...
       ~isfield(e.s.resCols, [fName{1}, 'Start'])                                
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

% only on the first go: 
% add row numbers to e.s.resCols for results matrix columns that will hold
% trial data. (when results are written to e.results, the row of trial data
% for the current trial will be appended to the corresponding results row;
% the row numbers for these data are computed and stored here)
if isFirstRun    
    maxCol = max(structfun(@(x) x, e.s.resCols)); % max column in use for results data
    % iterate over fields of tg.s.triallistCols, add maxCol to each entry, and
    % store in new field with same name in e.s.resCols.
    for fn = fieldnames(tg.s.triallistCols)'
        if isfield(e.s.resCols, fn{1})
            error(['Field ', fn{1}, ' was about to be copied from tg.s.triallistCols', ...
                ' to e.s.resCols, but already exists in e.s.resCols.']);
        end
        e.s.resCols.(fn{1}) = tg.s.triallistCols.(fn{1}) + maxCol;
    end
end



