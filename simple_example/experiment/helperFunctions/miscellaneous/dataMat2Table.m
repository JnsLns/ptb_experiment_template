
function tbl = dataMat2Table(dataMat, colStr)
% function tbl = dataMat2Table(dataMat, colStr)
%
% Convert a data matrix (from trial generation, experiment, or analysis) to
% a table, based on the corresponding column struct.

tbl = table();

for fn = fieldnames(colStr)'

    f = fn{1};    
    colNums = colStr.(f);
    nCols = numel(colNums);
    
    % Add table column mad up of all columns denoted in current field
    tbl(:, end+1) = table(dataMat(:, colNums));
    tbl.Properties.VariableNames{size(tbl,2)} = f;                                    
        
end