function sub = ind2subAll(siz,ndx)
% This is the same function as matlab function ind2sub (see documentation 
% below), but modified such that the output is not a variable number of
% arguments, but a single row vector with all subscript indices for the
% given siz input.
%
%
%IND2SUBALL Multiple subscripts from linear index.
%   IND2SUBALL is used to determine the equivalent subscript values
%   corresponding to a given single index into an array.
%
%   [I,J] = IND2SUBALL(SIZ,IND) returns the arrays I and J containing the
%   equivalent row and column subscripts corresponding to the index
%   matrix IND for a matrix of size SIZ.  
%   For matrices, [I,J] = IND2SUBALL(SIZE(A),FIND(A>5)) returns the same
%   values as [I,J] = FIND(A>5).
%
%   [I1,I2,I3,...,In] = IND2SUBALL(SIZ,IND) returns N subscript arrays
%   I1,I2,..,In containing the equivalent N-D array subscripts
%   equivalent to IND for an array of size SIZ.
%
%   Class support for input IND:
%      float: double, single
%      integer: uint8, int8, uint16, int16, uint32, int32, uint64, int64
%
%   See also SUB2IND, FIND.
 
%   Copyright 1984-2013 The MathWorks, Inc. 

%nout = max(nargout,1);
nout = length(siz);

siz = double(siz);
lensiz = length(siz);

if lensiz < nout
    siz = [siz ones(1,nout-lensiz)];
elseif lensiz > nout
    siz = [siz(1:nout-1) prod(siz(nout:end))];
end

if nout == 2
    vi = rem(ndx-1, siz(1)) + 1;
    sub{2} = double((ndx - vi)/siz(1) + 1);
    sub{1} = double(vi);
else
    k = [1 cumprod(siz(1:end-1))];
    for i = nout:-1:1,
        vi = rem(ndx-1, k(i)) + 1;
        vj = (ndx - vi)/k(i) + 1;
        sub{i} = double(vj);
        ndx = vi;
    end            
end

sub = cell2mat(sub);

