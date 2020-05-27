
%%%% Create e.s.resCols based on trial columns

e.s.resCols = struct;

% add row numbers to e.s.resCols for results matrix columns that will hold
% trial data. (when results are written to e.results, trial data from
% the triallist will also be written to the corresponding results row;
% the row numbers for these data are computed and stored here).

startAtCol = 1; % first column number in e.s.resCols to use

% iterate over fields of triallistCols, add maxCol to each entry, and
% store in new field with same name in e.s.resCols.
for fn = fieldnames(triallistCols)'
    if isfield(e.s.resCols, fn{1})
        error(['Field ', fn{1}, ' was about to be copied from triallistCols', ...
            ' to e.s.resCols, but already exists in e.s.resCols.']);
    end
    e.s.resCols.(fn{1}) = triallistCols.(fn{1}) + (startAtCol-1);
end




