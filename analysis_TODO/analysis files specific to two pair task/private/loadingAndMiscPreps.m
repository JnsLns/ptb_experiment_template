%% Load results files and join data from different participants.
% also: compare experimental and trial generation settings stored
% in the different results and warn if they differ.

disp('Loading files...'),

if ~isa(a.s.files,'cell')
    a.s.files = {a.s.files};
end
for curFile = 1:numel(a.s.files)
    load([a.s.path, a.s.files{curFile}]);   
    if numel(e.trajectories) ~= size(e.results,1)
        warning('off','backtrace');
        warning(['Missing trials in file ', a.s.files{curFile},'.']);
        warning('on','backtrace');
    end        
    % Trim trajectory cell and trials to same length as results to get rid
    % of undone trials (and corresponding empty cells in trajectory array)
    e.trajectories = e.trajectories(1:size(e.results,1));    
    if curFile == 1
        % add results column for participant tag
        a.rs = [e.results, repmat(curFile,size(e.results,1),1)];
        a.tr = e.trajectories;
        a.trials = e.trials_main;
        % store experimental and trial generation settings from first file to
        % later compare with those from other files
        fst_es = e.s;
        fst_tg = rmfield(tg,{'triallist','gen'});
        fst_gen = tg.gen;
    else
        
        % Make sure experimental settings in struct e.s and trial generation
        % settings in struct tg and tg.gen are the same for all loaded files
        % (note: isequal even distinguishes order of field creation in structs)
        warning('off','backtrace');
        if ~isequal(fst_es,e.s)        
            for curFieldName = fieldnames(fst_es)'
                if ~isequal(e.s.(curFieldName{1}),fst_es.(curFieldName{1}))
                    warning(['e.s.', curFieldName{1},' deviant in file ', num2str(curFile), ' (', a.s.files{curFile}, ').']);
                end
            end
        end
        if ~isequal(fst_gen,tg.gen)
            for curFieldName = fieldnames(fst_gen)'
                if ~isequal(tg.gen.(curFieldName{1}),fst_gen.(curFieldName{1}))
                    warning(['tg.gen.', curFieldName{1},' deviant in file ', num2str(curFile), ' (', a.s.files{curFile}, ').']);
                end
            end
        end
        curTg = rmfield(tg,{'triallist','gen'});
        if ~isequal(fst_tg,curTg)
            for curFieldName = fieldnames(fst_tg)'
                if ~isequal(curTg.(curFieldName{1}),fst_tg.(curFieldName{1}))
                    warning(['tg.', curFieldName{1},' deviant in file ', num2str(curFile), ' (', a.s.files{curFile}, ').']);
                end
            end
        end
        warning('on','backtrace');
        
        % concatenate/append to data from previous files
        a.rs = [a.rs;[e.results, repmat(curFile,size(e.results,1),1)]];
        a.tr = [a.tr;e.trajectories];
        a.trials = [a.trials;e.trials_main];
        
    end
end


%% make backup of raw data
a.rawDatBAK.trials = a.trials;
a.rawDatBAK.rs = a.rs;
a.rawDatBAK.tr = a.tr;

% Copy experiment settings to analysis struct, only those that are actually used.
a.s.resCols = e.s.resCols;
a.s.trajCols = e.s.trajCols;
a.s.presArea_mm = e.s.presArea_mm;
a.s.sptStrings = e.s.sptStrings; 


clearvars -except a e tg aTmp