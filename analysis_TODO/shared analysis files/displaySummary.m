disp(sprintf('\n------Summary-------------------------------------------'))

for curIv = 1:size(a.s.ivs,1)
   
    disp(sprintf(['\nDim.' num2str(curIv) ' -> IV "' a.s.ivs{curIv,a.s.ivsCols.name} '" (' num2str(numel(a.s.ivs{curIv,a.s.ivsCols.values})) ' act. levels)']))
    
    for curLv = 1:numel(a.s.ivs{curIv,a.s.ivsCols.valLabels})
        disp(sprintf(['\t Level ' num2str(curLv) ': ' num2str(a.s.ivs{curIv,a.s.ivsCols.valLabels}{curLv})]))
    end
    
end
    
disp(char(10));
    