function [zAngles] = zAngle(V)
% function zAngles = zAngle(V)
% compute angle (degrees) between z-axis and each of multiple row vectors
% stacked into a matrix. Helper function used in trial script.
zAngles = acosd( dot(V',repmat([0 0 1]',1,size(V,1))) ./ sqrt(sum(V'.^2)) );