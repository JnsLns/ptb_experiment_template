% Compute fit for each item and store in trial list

for curTrial = 1:size(triallist,1)

    % get item positions relative to reference
    x_tmp = triallist(curTrial,triallistCols.horzPosStart:triallistCols.horzPosEnd)' - ...
        triallist(curTrial,triallistCols.horzPosStart-1+triallist(curTrial,triallistCols.ref))';
    y_tmp = triallist(curTrial,triallistCols.vertPosStart:triallistCols.vertPosEnd)' - ...
        triallist(curTrial,triallistCols.vertPosStart-1+triallist(curTrial,triallistCols.ref))';
    
    % convert to polar
    [phi_tmp, r_tmp] = cart2pol(x_tmp,y_tmp);    
    
    % Compute fit                
    phi_0_current = phi_0_bySptCode(triallist(curTrial,triallistCols.spt)); % pick phi_0 depending on spatial term    
    fits_tmp = fitFunPol(phi_tmp,r_tmp,r_0,sig_r,phi_0_current,sig_phi,phi_flex,beta);
    
    % store in trialmatrix
    triallist(curTrial,triallistCols.fitsStart:triallistCols.fitsEnd) = fits_tmp;
    
end

