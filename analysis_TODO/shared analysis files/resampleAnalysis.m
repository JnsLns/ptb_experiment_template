

%  % Get highest layer field "addresses" in struct a
%         a_dataFieldNames = findStructBranchEnds(a);
%         % among these, find fields holding averages (get logical indices in
%         % a_dataFieldNames; based on the field names)
%         a_trjLogicalNdcs = contains(a_dataFieldNames,'.trj');
%         a_resLogicalNdcs = contains(a_dataFieldNames,'.res');
%         % get the actual field names in struct
%         a_dataFieldNames_trj = a_dataFieldNames(a_avgLogicalNdcs);

if a.s.discardTrialsToBalance && a.s.numResamples>1
    
    warning('Resampling analysis is WORK IN PROGRESS. A lot is missing and some may be false...');
    
    if a.s.reuseOldRowSets 
        error('Both resampling and re-use of previous trial set is active. Deactivate one.');
    end
    
    if aTmp.sampleRun ==1
        aTmp.acc_a = a;
    else
        aTmp.acc_a.trj.wrp.pos.avg = cellfun(@(cur_a,acc_a)  acc_a+cur_a,a.trj.wrp.pos.avg , aTmp.acc_a.trj.wrp.pos.avg, 'uniformoutput', 0);
    end
    
    if aTmp.sampleRun  == a.s.numResamples
        a.trj.wrp.pos.avg = cellfun(@(acc_a) acc_a./a.s.numResamples,aTmp.acc_a.trj.wrp.pos.avg,'uniformoutput',0);
    end
    
end