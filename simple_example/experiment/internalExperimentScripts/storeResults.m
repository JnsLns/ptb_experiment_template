%%% Move result data from struct 'out' to 'e.results' 

% initialize results table on first trial
if ~isfield(e, 'results')
    e.results = table();
end

% convert struct 'out' to table row
newResultsRow = struct2table(out, 'AsArray', true);

% check that variable names do not overlap with trial list var names
if any(ismember(trials.Properties.VariableNames, ...
        newResultsRow.Properties.VariableNames))
    error(['Field names in struct ''out'' must not overlap with variable ', ...
        'names of trial list.']);
end

% add info from trial list 
newResultsRow = [newResultsRow, trials(curTrial,:)];

% append to result list. Any non-overlapping variables (i.e., fields of
% 'out' that have not been used in previous trials) will be added to all
% existing rows of the results list and padded with NaN or empty cell
% arrays.
e.results = forceAppendTable(e.results, newResultsRow);




