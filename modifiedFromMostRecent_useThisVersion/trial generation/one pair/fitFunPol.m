function fitPol = fitFunPol(phi_input,r_input,r_0,sig_r,phi_0,sig_phi,phi_flex,beta)
%
% Compute spatial term fit from polar coordinates.
%
% phi_input and r_input are n-dimensional matrices, corresponding elements
% of which constitute pairs of polar coordinates (angle and radius,
% respectively). fitPol is a matrix of the same size as each of them.
%
% Angles in phi_input are not restricted to any interval, but are mapped to
% that over which the fit function is defined (spanning phi_0-pi to phi_0+pi)
% automatically.
%
% Parameters
% phi_0     mean of Gaussian function over angle [rad]
%           e.g. 0 = "right of", pi/2 = "above", pi = "left of",(3/2)*pi = "below"                                                       
% sig_phi   width of Gaussian over angle [rad]
% r_0       mean of Gaussian over radius 
% sig_r     width of Gaussian over radius
% beta      steepness of sigmoid over radius (sets extreme angles to zero) 
% phi_flex  distance of sigmoid inflection point from mean of Gaussian over
%           angle (should normally be pi/2 or somewhat less than that, to
%           cover about 180° of the angle opposite the spatial term's main
%           direction)
%
% This uses the same formula as Lins & Schöner, 2017

phi_input = phi_0 - pi + mod(phi_input-(phi_0+pi),2*pi);

% fit function
fitPol = exp(-((phi_input-phi_0).^2./(2*sig_phi.^2))) .* ...       % Gaussian over angle
             exp(-((r_input-r_0).^2./(2*sig_r.^2))) .* ...             % Gaussian over radius
             (1./(1+(exp(beta*(abs(phi_input-phi_0)-phi_flex)))));     % Sigmoid over angle (set extreme angles to zero; relative to phi_0)
         
