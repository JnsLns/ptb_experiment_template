% Compute sums of different levels of an IV (i.e., sum condition means).
% Results are concatenated as additional page(s) to the existing cell array,
% along the dimension (=IV) within which sums were computed. The
% label column of a.s.ivs (a.s.ivsCols.valLabels) is updated with an
% appropriate label for the sum(s). Sums may be computed of IV-levels that
% were not included in a.s.ivsCols.useVal (i.e., intentionally excluded
% from plotting); in this case, the array pages referring to these levels
% trials are removed after computing sums.
%
% NOTE: Arrays in .ind fields of the trj. struct are NOT JOINED!! (such
% fields in res. are joined though!)

for curIv = 1:size(a.s.ivs,1)
       
    for curSum = 1:size(a.s.ivs{curIv,a.s.ivsCols.sums},1)           
        
        disp('Computing sums of condition means...');
        
        % Get page indices into results arrays (at the same time linear index
        % into matrices wihtin a.s.ivs) for summand values.
        summand1 = find(a.s.ivs{curIv,a.s.ivsCols.values} == a.s.ivs{curIv,a.s.ivsCols.sums}(curSum,1));                                
        summand2 = find(a.s.ivs{curIv,a.s.ivsCols.values} == a.s.ivs{curIv,a.s.ivsCols.sums}(curSum,2));                
        
        % Get labels of both
        summand1Name = a.s.ivs{curIv,a.s.ivsCols.valLabels}{summand1};
        summand2Name = a.s.ivs{curIv,a.s.ivsCols.valLabels}{summand2};              
        
        % add name of sum to a.s.ivs
        a.s.ivs{curIv,a.s.ivsCols.valLabels}{end+1} = strjoin({summand1Name, summand2Name} , ' plus ');        
        
        % do addition (add additional arrays here for more sums):                                        
        
        a.trj.wrp.pos.avg = cellSum(a.trj.wrp.pos.avg,curIv,[summand1,summand2],1);
        a.trj.wrp.pos.std = cellStdOfSum(a.trj.wrp.pos.std,0,curIv,summand1,summand2,1);               
        if a.s.doCompute_spdVelAcc
            a.trj.wrp.spd.avg = cellSum(a.trj.wrp.spd.avg,curIv,[summand1,summand2],1);
            a.trj.wrp.spd.std = cellStdOfSum(a.trj.wrp.spd.std,0,curIv,summand1,summand2,1);
            a.trj.wrp.vel.avg = cellSum(a.trj.wrp.vel.avg,curIv,[summand1,summand2],1);
            a.trj.wrp.vel.std = cellStdOfSum(a.trj.wrp.vel.std,0,curIv,summand1,summand2,1);
            a.trj.wrp.acc.avg = cellSum(a.trj.wrp.acc.avg,curIv,[summand1,summand2],1);
            a.trj.wrp.acc.std = cellStdOfSum(a.trj.wrp.acc.std,0,curIv,summand1,summand2,1);
        end
        
        if a.s.doCompute_aligned
            a.trj.alg.pos.avg = cellSum(a.trj.alg.pos.avg,curIv,[summand1,summand2],1);
            a.trj.alg.pos.std = cellStdOfSum(a.trj.alg.pos.std,0,curIv,summand1,summand2,1);
            if a.s.doCompute_spdVelAcc
                a.trj.alg.spd.avg = cellSum(a.trj.alg.spd.avg,curIv,[summand1,summand2],1);
                a.trj.alg.spd.std = cellStdOfSum(a.trj.alg.spd.std,0,curIv,summand1,summand2,1);
                a.trj.alg.vel.avg = cellSum(a.trj.alg.vel.avg,curIv,[summand1,summand2],1);
                a.trj.alg.vel.std = cellStdOfSum(a.trj.alg.vel.std,0,curIv,summand1,summand2,1);
                a.trj.alg.acc.avg = cellSum(a.trj.alg.acc.avg,curIv,[summand1,summand2],1);
                a.trj.alg.acc.std = cellStdOfSum(a.trj.alg.acc.std,0,curIv,summand1,summand2,1);
            end
        end
    
        a.res.avg = cellSum(a.res.avg,curIv,[summand1,summand2],1);
        a.res.std = cellStdOfSum(a.res.std,0,curIv,summand1,summand2,1);                   
        
        % For a.res.ind, just join the individal cases
        from1_tmp = ones(1,ndims(a.res.ind)); from1_tmp(curIv) = summand1;
        to1_tmp = ones(1,ndims(a.res.ind)).*size(a.res.ind); to1_tmp(curIv) = summand1;        
        from2_tmp = ones(1,ndims(a.res.ind)); from2_tmp(curIv) = summand2;
        to2_tmp = ones(1,ndims(a.res.ind)).*size(a.res.ind); to2_tmp(curIv) = summand2;        
        summand1Slice_tmp = subArray(a.res.ind,from1_tmp,to1_tmp);
        summand2Slice_tmp = subArray(a.res.ind,from2_tmp,to2_tmp);
        a.res.ind = cat(curIv,a.res.ind,cellCollapse(cat(curIv,summand1Slice_tmp,summand2Slice_tmp),curIv,1));
        
        % For a.res.ncs, just sum number of cases in the two conditions going into the difference
        from1_tmp = ones(1,ndims(a.res.ncs)); from1_tmp(curIv) = summand1;
        to1_tmp = ones(1,ndims(a.res.ncs)).*size(a.res.ncs); to1_tmp(curIv) = summand1;        
        from2_tmp = ones(1,ndims(a.res.ncs)); from2_tmp(curIv) = summand2;
        to2_tmp = ones(1,ndims(a.res.ncs)).*size(a.res.ncs); to2_tmp(curIv) = summand2;        
        summand1Slice_tmp = subArray(a.res.ncs,from1_tmp,to1_tmp);
        summand2Slice_tmp = subArray(a.res.ncs,from2_tmp,to2_tmp);
        a.res.ncs = cat(curIv,a.res.ncs,sum(cat(curIv,summand1Slice_tmp,summand2Slice_tmp),curIv));                                
       
        if a.s.doCompute_aucMaxDev
            a.trj.wrp.auc.avg = cell2mat(cellSum(num2cell(a.trj.wrp.auc.avg),curIv,[summand1,summand2],1));
            a.trj.wrp.auc.std = cell2mat(cellStdOfSum(num2cell(a.trj.wrp.auc.std),0,curIv,summand1,summand2,1));
            a.trj.wrp.mDev.avg = cell2mat(cellSum(num2cell(a.trj.wrp.mDev.avg),curIv,[summand1,summand2],1));
            a.trj.wrp.mDev.std = cell2mat(cellStdOfSum(num2cell(a.trj.wrp.mDev.std),0,curIv,summand1,summand2,1));
        end
        
    end
    
end


clearvars -except a e tg aTmp