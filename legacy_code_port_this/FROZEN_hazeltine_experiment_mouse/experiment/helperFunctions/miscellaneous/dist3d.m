function [dist] = dist3d(p1, ps, dropDims)
% function [dist] = dist3d(p1, ps, dropDims)
%
% Compute Euclidean distance in 3d space between point p1 and points ps.
% 
% __Input__
%
% p1        three-element row vector (x,y,z) 
%
% ps        three-element row vector (x,y,z) or n-by-3 matrix, where each
%           row holds one point. Distance to all of these points is
%           computed.
%
% dropDims  optional, default [0,0,0]. Three-element row vector, 
%           specifying components to include in the computation (x,y,z, in
%           this order). 1 means that the respective dimension is
%           disregarded (projecting the vectors onto remaining dimensions),
%           0 means it is taken into account.
%
% __Output__
% 
% dist      Scalar or column vector, holding the Euclidean distances
%           between point p1 and points ps.

if nargin < 3
    dropDims = [0 0 0];    
end

dropDims = repmat(dropDims, size(ps,1), 1);
p1 = repmat(p1,size(ps,1),1);
ps = ps - ps.*dropDims + p1.*dropDims;      
dist = sqrt(dot((p1-ps),(p1-ps),2));
            
end

