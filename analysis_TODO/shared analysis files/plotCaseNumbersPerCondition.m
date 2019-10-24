% Works in principle... somewhat WIP though

% This plots info (mean, min, max) about the case numbers in each condition
% over participants


if aTmp.plotCaseNumbersAcrossParticipants
    for whichVal = 1:3
        switch whichVal
            case 1
                tmp = cellMean(aTmp.ncs_ind,a.s.ptsDim);
                superTitle = 'mean number of cases across participants';
            case 2
                tmp = cellCollapse(aTmp.ncs_ind,a.s.ptsDim);
                tmp = cellfun(@(bla) min(bla,[],a.s.ptsDim), tmp, 'uniformoutput',0);
                superTitle = 'minimum number of cases across participants';
            case 3
                tmp = cellCollapse(aTmp.ncs_ind,a.s.ptsDim);
                tmp = cellfun(@(bla) max(bla,[],a.s.ptsDim), tmp, 'uniformoutput',0);
                superTitle = 'maximum number of cases across participants';
        end
        if ndims(tmp) > 3; warning('Mean case number bar graphs can only be plotted for three or fewer IVs'); end
        tmp = cellCollapse(tmp,1,2); % first IV will be represented by bar colors
        figure;
        d2Sz = size(tmp,2);
        d3Sz = size(tmp,3);
        for tmpCell = 1:numel(tmp)
            curSubs = ind2subAll(size(tmp),tmpCell);
            curSubs(end+1:3) = 1;
            subplot(d2Sz,d3Sz,(curSubs(2)-1)*d3Sz+curSubs(3))
            bar(tmp{tmpCell});
            ttlStr = '';
            sep = '';
            for curDim = 2:ndims(tmp)
                if curDim == 3; sep = ' / '; end
                ttlStr = strcat(ttlStr, sep, a.s.ivs{curDim,a.s.ivsCols.valLabels}(curSubs(curDim)));
            end
            title(ttlStr);
            legend(a.s.ivs{1,a.s.ivsCols.valLabels}')
        end
        tmpMat = cell2mat(tmp);
        set(findobj(gcf,'type','axes'),'ylim',[0 ceil(max(tmpMat(:)))]);
        suptitle(superTitle);
    end
end