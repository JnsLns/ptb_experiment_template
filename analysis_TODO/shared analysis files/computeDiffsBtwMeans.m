% Compute differences between means from different levels of an IV. Results are
% concatenated as additional page(s) to the existing cell array, along the
% dimension (=IV) within which differences were computed. The label column
% of a.s.ivs (a.s.ivsCols.valLabels) is updated with an appropriate label for the
% diff(s). Diffs may be computed between IV-levels that were not included
% in a.s.ivsCols.useVal (i.e., intentionally excluded from plotting); in this
% case, the array pages referring to these levels trials are removed after
% computing diffs.
%
% NOTE: Arrays in .ind fields of the trj. struct are NOT JOINED!! (such
% fields in res. are joined though!)

for curIv = 1:size(a.s.ivs,1)
       
    for curDiff = 1:size(a.s.ivs{curIv,a.s.ivsCols.diffs},1)           
        
        disp('Computing differences btw. means...');
        
        % Get page indices into results arrays (at the same time linear index
        % into matrices wihtin a.s.ivs) for minuend and subtrahend values.        
        minuend = find(a.s.ivs{curIv,a.s.ivsCols.values} == a.s.ivs{curIv,a.s.ivsCols.diffs}(curDiff,1));                                
        subtrahend = find(a.s.ivs{curIv,a.s.ivsCols.values} == a.s.ivs{curIv,a.s.ivsCols.diffs}(curDiff,2));                
        
        % Get labels of both
        minName = a.s.ivs{curIv,a.s.ivsCols.valLabels}{minuend};
        subName = a.s.ivs{curIv,a.s.ivsCols.valLabels}{subtrahend};              
        
        % add name of difference to a.s.ivs
        a.s.ivs{curIv,a.s.ivsCols.valLabels}{end+1} = strjoin({minName, subName} , ' minus ');        
        
        % do subtraction (add additional arrays here for more diffs):
                        
        a.trj.wrp.pos.avg = cellDiff(a.trj.wrp.pos.avg,curIv,minuend,subtrahend,1);
        a.trj.wrp.pos.std = cellStdOfDiff(a.trj.wrp.pos.std,a.res.ncs,curIv,minuend,subtrahend,1);               
        if a.s.doCompute_spdVelAcc
            a.trj.wrp.spd.avg = cellDiff(a.trj.wrp.spd.avg,curIv,minuend,subtrahend,1);
            a.trj.wrp.spd.std = cellStdOfDiff(a.trj.wrp.spd.std,a.res.ncs,curIv,minuend,subtrahend,1);
            a.trj.wrp.vel.avg = cellDiff(a.trj.wrp.vel.avg,curIv,minuend,subtrahend,1);
            a.trj.wrp.vel.std = cellStdOfDiff(a.trj.wrp.vel.std,a.res.ncs,curIv,minuend,subtrahend,1);
            a.trj.wrp.acc.avg = cellDiff(a.trj.wrp.acc.avg,curIv,minuend,subtrahend,1);
            a.trj.wrp.acc.std = cellStdOfDiff(a.trj.wrp.acc.std,a.res.ncs,curIv,minuend,subtrahend,1);
        end
        
        if a.s.doCompute_aligned
            a.trj.alg.pos.avg = cellDiff(a.trj.alg.pos.avg,curIv,minuend,subtrahend,1);
            a.trj.alg.pos.std = cellStdOfDiff(a.trj.alg.pos.std,a.res.ncs,curIv,minuend,subtrahend,1);
            if a.s.doCompute_spdVelAcc
                a.trj.alg.spd.avg = cellDiff(a.trj.alg.spd.avg,curIv,minuend,subtrahend,1);
                a.trj.alg.spd.std = cellStdOfDiff(a.trj.alg.spd.std,a.res.ncs,curIv,minuend,subtrahend,1);
                a.trj.alg.vel.avg = cellDiff(a.trj.alg.vel.avg,curIv,minuend,subtrahend,1);
                a.trj.alg.vel.std = cellStdOfDiff(a.trj.alg.vel.std,a.res.ncs,curIv,minuend,subtrahend,1);
                a.trj.alg.acc.avg = cellDiff(a.trj.alg.acc.avg,curIv,minuend,subtrahend,1);
                a.trj.alg.acc.std = cellStdOfDiff(a.trj.alg.acc.std,a.res.ncs,curIv,minuend,subtrahend,1);
            end
        end
        
        % PROTOTYPE START
        a.trj.wrp.ang.tgt.avg = cellDiff(a.trj.wrp.ang.tgt.avg,curIv,minuend,subtrahend,1);
        a.trj.wrp.ang.tgt.std = cellStdOfDiff(a.trj.wrp.ang.tgt.std,a.res.ncs,curIv,minuend,subtrahend,1);                       
        a.trj.wrp.ang.ref.avg = cellDiff(a.trj.wrp.ang.ref.avg,curIv,minuend,subtrahend,1);
        a.trj.wrp.ang.ref.std = cellStdOfDiff(a.trj.wrp.ang.ref.std,a.res.ncs,curIv,minuend,subtrahend,1);                       
        a.trj.wrp.ang.dtr.avg = cellDiff(a.trj.wrp.ang.dtr.avg,curIv,minuend,subtrahend,1);
        a.trj.wrp.ang.dtr.std = cellStdOfDiff(a.trj.wrp.ang.dtr.std,a.res.ncs,curIv,minuend,subtrahend,1);                       
        % PROTOTYPE END
    
        a.res.avg = cellDiff(a.res.avg,curIv,minuend,subtrahend,1);
        a.res.std = cellStdOfDiff(a.res.std,a.res.ncs,curIv,minuend,subtrahend,1);                   
        
        % For a.res.ind, just join the individal cases
        from1_tmp = ones(1,ndims(a.res.ind)); from1_tmp(curIv) = minuend;
        to1_tmp = ones(1,ndims(a.res.ind)).*size(a.res.ind); to1_tmp(curIv) = minuend;        
        from2_tmp = ones(1,ndims(a.res.ind)); from2_tmp(curIv) = subtrahend;
        to2_tmp = ones(1,ndims(a.res.ind)).*size(a.res.ind); to2_tmp(curIv) = subtrahend;        
        minSlice_tmp = subArray(a.res.ind,from1_tmp,to1_tmp);
        subSlice_tmp = subArray(a.res.ind,from2_tmp,to2_tmp);
        a.res.ind = cat(curIv,a.res.ind,cellCollapse(cat(curIv,minSlice_tmp,subSlice_tmp),curIv,1));
        
        % For a.res.ncs, just sum number of cases in the two conditions going into the difference
        from1_tmp = ones(1,ndims(a.res.ncs)); from1_tmp(curIv) = minuend;
        to1_tmp = ones(1,ndims(a.res.ncs)).*size(a.res.ncs); to1_tmp(curIv) = minuend;        
        from2_tmp = ones(1,ndims(a.res.ncs)); from2_tmp(curIv) = subtrahend;
        to2_tmp = ones(1,ndims(a.res.ncs)).*size(a.res.ncs); to2_tmp(curIv) = subtrahend;        
        minSlice_tmp = subArray(a.res.ncs,from1_tmp,to1_tmp);
        subSlice_tmp = subArray(a.res.ncs,from2_tmp,to2_tmp);
        a.res.ncs = cat(curIv,a.res.ncs,sum(cat(curIv,minSlice_tmp,subSlice_tmp),curIv));                                
       
        if a.s.doCompute_aucMaxDev
            a.trj.wrp.auc.avg = cell2mat(cellDiff(num2cell(a.trj.wrp.auc.avg),curIv,minuend,subtrahend,1));
            a.trj.wrp.auc.std = cell2mat(cellStdOfDiff(num2cell(a.trj.wrp.auc.std),a.res.ncs,curIv,minuend,subtrahend,1));
            a.trj.wrp.mDev.avg = cell2mat(cellDiff(num2cell(a.trj.wrp.mDev.avg),curIv,minuend,subtrahend,1));
            a.trj.wrp.mDev.std = cell2mat(cellStdOfDiff(num2cell(a.trj.wrp.mDev.std),a.res.ncs,curIv,minuend,subtrahend,1));
        end
        
    end
    
end


clearvars -except a e tg aTmp