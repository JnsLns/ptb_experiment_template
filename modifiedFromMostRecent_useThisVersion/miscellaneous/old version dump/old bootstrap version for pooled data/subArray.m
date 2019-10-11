function subArr = subArray(arr,from,to)
%
% This function returns a subarray of another array, arr, retaining the
% dimensionality and order of dimensions of arr. The subarray is specified
% in the form of subscript indices into arr, provided in two row
% vectors, from and to, that hold the indices of the first and last
% elements from arr, respectively, that the subarray should contain.
% The linear index of each of the indices in from and to is
% equal to the dimension of arr to which that index refers. Zeros within
% from and to are interpreted as '1' or 'end', respectively.
% 
% The standard MATLAB syntax for getting a subarray is, e.g.,
% subArr = arr(2:3,4:8,1:end), which is inconvenient when having to
% adress a subarray without knowing its dimensionality at coding time. The
% subArray call equivalent to the above example would be 
% subArr = subArray(arr,[2 4 1],[3 8 0]);


%loop through dimensions
theString = 'subArr = arr(';
for i = 1:numel(from)
        
    if i<numel(from)
        trailingStr = ',';
    else
        trailingStr = ');';
    end
    
    curFrom = num2str(from(i));
    curTo = num2str(to(i));        
    
    if from(i) 
        curFrom = num2str(from(i));
    else
        curFrom = '1';        
    end
        
    if to(i) 
        curTo = num2str(to(i));
    else
        curTo = 'end';        
    end                           
    
    % successively concatenate string for eval.
    theString = [theString, curFrom, ':' , curTo, trailingStr];                   
     
end


eval(theString);
