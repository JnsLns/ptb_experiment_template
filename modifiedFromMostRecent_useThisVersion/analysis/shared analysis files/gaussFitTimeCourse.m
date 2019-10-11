
if a.s.doGaussFit
            
    sourceArray = a.trj.(a.s.gFit.aggregationType).(a.s.gFit.dataType).avg;
    
    a.trj.fit.gMean = zeros(size(sourceArray)); % gauss mean
    a.trj.fit.gAmpl = zeros(size(sourceArray)); % gauss amplitude
    a.trj.fit.gSigm = zeros(size(sourceArray)); % gauss sigma (1 std)
    
    % Loop over cells of source array
    for curLndx = 1:numel(sourceArray)
                                
        fitDat_x = sourceArray{curLndx}(:,a.s.trajCols.(a.s.gFit.xAxCol));
        fitDat_y = sourceArray{curLndx}(:,a.s.trajCols.(a.s.gFit.yAxCol));                        
        
        % Normalize y data if desired
        if a.s.gFit.yAxProp
            fitDat_y = fitDat_y./max(fitDat_y); 
        end
        if a.s.gFit.yAxUseIndices
            fitDat_y = (1:numel(fitDat_y))'; 
        end
        
        % make sure only the absolutely largest hump is considered:
        % if sign of absolutely largest value in x data is negative, then
        % set all positive values to zero; if it is positive, then set all
        % negative values to zero        
        if sign(fitDat_x(max(abs(fitDat_x))==abs(fitDat_x))) == -1
            fitDat_x(fitDat_x>0) = 0;
        elseif sign(fitDat_x(max(abs(fitDat_x))==abs(fitDat_x))) == 1
            fitDat_x(fitDat_x<0) = 0;
        end
        
        try
            f = fit(fitDat_y,fitDat_x,'Gauss1');%,'Lower',[0 0 0], 'Upper', [100 max(fitDat_y) max(fitDat_y)]);
        catch % some curves cannot be fitted for unknown reasons... find out why!
           warning('One of the mean trajectories threw an error while Gauss-fitting');
            f.a1 = nan; f.b1 = nan; f.c1 = nan;
        end
            
        % Store coefficients
        a.trj.fit.gAmpl(curLndx) = f.a1;
        a.trj.fit.gMean(curLndx) = f.b1;
        a.trj.fit.gSigm(curLndx) = f.c1;
        
        %figure;
        plot(f); hold on; plot(fitDat_y,fitDat_x)
        
    end
    
end
