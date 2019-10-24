if a.s.removeZeroCaseParticipants
    if a.s.discardTrialsToBalance
        
        disp('Checking for participants with zero cases in any of the defined conditions (joined levels count as single conditions).');
        
        % error/sanity checks
        if strcmp(a.s.ivs{a.s.ptsDim,a.s.ivsCols.name},'participants (manual)')
            disp([char(9),'(Participant dim. is ', num2str(a.s.ptsDim) ,', set manually (averaging DISabled).)']);
            if a.s.ptsDim ~= 1
                error('Manually defined participant dimension is not in row 1 of a.s.ivs (it should be defined first in ivDefinition.m)!');
            end
        end
        if strcmp(a.s.ivs{a.s.ptsDim,a.s.ivsCols.name},'internalPtsDim')
            disp([char(9), '(Participant dim. is ', num2str(a.s.ptsDim) ,', set automatically (averaging ENabled).)']);
            if size(a.s.ivs,1) ~= a.s.ptsDim
                error('Averaging over participants enabled but internalPtsDim is not the final row of ivs!');
            end
        end
        if ~strcmp(a.s.ivs{a.s.ptsDim,a.s.ivsCols.name},'participants (manual)') && ~strcmp(a.s.ivs{a.s.ptsDim,a.s.ivsCols.name},'internalPtsDim')
            error(['Participant dim. set to ', num2str(a.s.ptsDim), ', but that row of a.s.ivs is not named accordingly!']);
        end
        
        % Find participants with zero cases (index refers to internal
        % participants dimension in the data array, i.e., normally last
        % dimension)
        ncsAfterBalancing = cellfun(@(rws) sum(rws),a.s.rowSets,'uniformoutput',0);
        a.s.ncsAfterBalancing = ncsAfterBalancing;
        
        numPtsBeforeRemoval = size(ncsAfterBalancing,a.s.ptsDim);
        for curDim = 1:ndims(ncsAfterBalancing)
            if curDim ~= a.s.ptsDim % collapse along all but participant dim
                ncsAfterBalancing = cellCollapse(ncsAfterBalancing,curDim,1);
            end
        end
        % Find indices of participants with zero cases
        zeroCasePts_lndcs = find(squeeze(cellfun(@(nab) any(nab==0),ncsAfterBalancing)));
        
        % Remove pages pertaining to these participants from rowSets
        a.s.rowSets = cellPageDelete(a.s.rowSets,a.s.ptsDim,zeroCasePts_lndcs);
        % Remove info about these participants from ivs
        a.s.ivs{a.s.ptsDim,a.s.ivsCols.values}(zeroCasePts_lndcs) = [];
        a.s.ivs{a.s.ptsDim,a.s.ivsCols.valLabels}(zeroCasePts_lndcs) = [];
        a.s.ivs{a.s.ptsDim,a.s.ivsCols.useVal}(zeroCasePts_lndcs) = [];
        
        % info
        for i = 1:numel(zeroCasePts_lndcs)
            if iscell(a.s.files)
                discardedPtpFilename = a.s.files{zeroCasePts_lndcs(i)};
            else
                discardedPtpFilename = [a.s.files, ' (exact file name unknown)'];
            end
            disp([char(9) '-> removed participant ' num2str(zeroCasePts_lndcs(i)) ' (file ' discardedPtpFilename ').']);
        end
        disp([char(9) '-> ' num2str(numel(zeroCasePts_lndcs)) ' of ' num2str(numPtsBeforeRemoval) ' pts. removed due to zero cases.'    ]);
        disp([char(9) '-> (see a.s.ncsAfterBalancing for exact case numbers after balancing / before removal.)']);
        
        
    else
        warning('Zero case participants are not removed even though a.s.removeZeroCaseParticipants==1, because a.s.discardTrialsToBalance==0');        
    end
end





