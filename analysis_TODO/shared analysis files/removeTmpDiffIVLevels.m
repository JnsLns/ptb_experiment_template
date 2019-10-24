% remove data from computed results arrays that was inserted temporarily
% only for the purpose of computing their difference in computeDiffsBtwMeans.m
% (and which themselves should not be plotted).
for curIv = 1:size(a.s.ivs,1)
   
    while ~isempty(a.s.ivs{curIv,a.s.ivsCols.tmpValsDiff})

       curTmpVal = a.s.ivs{curIv,a.s.ivsCols.tmpValsDiff}(1);
        
       % Find number of page that needs to be removed from the dimension
       % given by curIv to get rid of current temp value data
       pageNum = find(a.s.ivs{curIv,a.s.ivsCols.values} == curTmpVal);
       
       % delete that page from all relevant result arrays
       a.trj.wrp.pos.avg = cellPageDelete(a.trj.wrp.pos.avg,curIv,pageNum);
       a.trj.wrp.pos.std = cellPageDelete(a.trj.wrp.pos.std,curIv,pageNum);       
       if a.s.doCompute_spdVelAcc
           a.trj.wrp.spd.avg = cellPageDelete(a.trj.wrp.spd.avg,curIv,pageNum);
           a.trj.wrp.spd.std = cellPageDelete(a.trj.wrp.spd.std,curIv,pageNum);
           a.trj.wrp.vel.avg = cellPageDelete(a.trj.wrp.vel.avg,curIv,pageNum);
           a.trj.wrp.vel.std = cellPageDelete(a.trj.wrp.vel.std,curIv,pageNum);
           a.trj.wrp.acc.avg = cellPageDelete(a.trj.wrp.acc.avg,curIv,pageNum);
           a.trj.wrp.acc.std = cellPageDelete(a.trj.wrp.acc.std,curIv,pageNum);
       end
       
       % PROTOTYPE START
       a.trj.wrp.ang.tgt.avg = cellPageDelete(a.trj.wrp.ang.tgt.avg,curIv,pageNum);
       a.trj.wrp.ang.tgt.std = cellPageDelete(a.trj.wrp.ang.tgt.std,curIv,pageNum);       
       a.trj.wrp.ang.ref.avg = cellPageDelete(a.trj.wrp.ang.ref.avg,curIv,pageNum);
       a.trj.wrp.ang.ref.std = cellPageDelete(a.trj.wrp.ang.ref.std,curIv,pageNum);              
       a.trj.wrp.ang.dtr.avg = cellPageDelete(a.trj.wrp.ang.dtr.avg,curIv,pageNum);
       a.trj.wrp.ang.dtr.std = cellPageDelete(a.trj.wrp.ang.dtr.std,curIv,pageNum);              
       % PROTOTYPE END
       
       if a.s.doCompute_aligned
           a.trj.alg.pos.avg = cellPageDelete(a.trj.alg.pos.avg,curIv,pageNum);
           a.trj.alg.pos.std = cellPageDelete(a.trj.alg.pos.std,curIv,pageNum);
           if a.s.doCompute_spdVelAcc
               a.trj.alg.spd.avg = cellPageDelete(a.trj.alg.spd.avg,curIv,pageNum);
               a.trj.alg.spd.std = cellPageDelete(a.trj.alg.spd.std,curIv,pageNum);
               a.trj.alg.vel.avg = cellPageDelete(a.trj.alg.vel.avg,curIv,pageNum);
               a.trj.alg.vel.std = cellPageDelete(a.trj.alg.vel.std,curIv,pageNum);
               a.trj.alg.acc.avg = cellPageDelete(a.trj.alg.acc.avg,curIv,pageNum);
               a.trj.alg.acc.std = cellPageDelete(a.trj.alg.acc.std,curIv,pageNum);
           end
       end
       
       if a.s.doCompute_aucMaxDev
           a.trj.wrp.auc.avg = cellPageDelete(a.trj.wrp.auc.avg,curIv,pageNum);
           a.trj.wrp.auc.std = cellPageDelete(a.trj.wrp.auc.std,curIv,pageNum);
           a.trj.wrp.mDev.avg = cellPageDelete(a.trj.wrp.mDev.avg,curIv,pageNum);
           a.trj.wrp.mDev.std = cellPageDelete(a.trj.wrp.mDev.std,curIv,pageNum);
       end
       a.res.avg = cellPageDelete(a.res.avg,curIv,pageNum);
       a.res.std = cellPageDelete(a.res.std,curIv,pageNum);       
       a.res.ind = cellPageDelete(a.res.ind,curIv,pageNum);
       a.res.ncs = cellPageDelete(a.res.ncs,curIv,pageNum);           
                     
       % remove current temp val from storage and from values and delete
       % corresponding label from a.s.ivs
       a.s.ivs{curIv,a.s.ivsCols.tmpValsDiff}(1) = [];       
       a.s.ivs{curIv,a.s.ivsCols.values}(pageNum) = [];       
       a.s.ivs{curIv,a.s.ivsCols.valLabels}(pageNum) = [];         
              
    end

end


clearvars -except a e tg aTmp