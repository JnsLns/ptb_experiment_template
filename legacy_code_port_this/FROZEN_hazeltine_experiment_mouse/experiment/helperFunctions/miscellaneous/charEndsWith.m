function [ew] = charEndsWith(charArr, pat)     
% function [ew] = charEndsWith(charArr, pat)     
%
% Check whether character array 'charArr' ends on pattern 'pat'. If so,
% returns true, else false (including case where 'pat' has more elements
% than 'charArr'). 
%
% (Starting from R2016b the built-in function endsWith can instead be used).

if ~ischar(charArr) || ~ischar(pat)
    error('Arguments charArr and pat must be character arrays.')
end
lencharArr = length(charArr);
lenPat = length(pat);
if lencharArr >= lenPat
    ew = strcmp(charArr(lencharArr-lenPat+1:end), pat);            
else
    ew = false;
end