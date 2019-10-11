phi_res = 100;              % resolution of polar function along angular dimension
r_res = 100;                % resolution of polar function along radial dimension
max_r = 201;                % maximum angle [mm] up to which fit function is computed
x_res = 100;                % horizontal resolution of cartesian version
y_res = 100;                % vertical resolution of cartesian version

phi_0 = 1.5*pi;                  % mean of Gaussian function over angLE [rad]
                            % 0 = "right of", pi/2 = "above", pi = "left of",(3/2)*pi = "below"                                                       
sig_phi = pi*0.33;          % width of Gaussian over angle [rad]
r_0 = 0;                    % mean of Gaussian over radius [mm]
sig_r = 47;                 % width of Gaussian over radius [mm]
beta = 25;                  % steepness of sigmoid over radius (sets extreme angles to zero) 
phi_flex = pi/2 - pi/25;    % distance of sigmoid inflection point from mean of Gaussian over angle (phi)
                            % (should normally be pi/2 or somewhat less
                            % than that, to cover about 180° of the angle
                            % opposite the spatial term's main direction)

% phi_range must include a range of 2*pi (full circle) and be centered on phi_0
% (in other words: there's normally no need to edit this)
phi_range = linspace(phi_0-pi,phi_0+pi,phi_res); % angle, rad
r_range =  linspace(0,max_r,r_res); % radius, mm

% Make polar coordinate grid
[phi,r] = meshgrid(phi_range,r_range);

% fit function
fitFun_pol = exp(-((phi-phi_0).^2./(2*sig_phi.^2))) .* ...       % Gaussian over angle
             exp(-((r-r_0).^2./(2*sig_r.^2))) .* ...             % Gaussian over radius
             (1./(1+(exp(beta*(abs(phi-phi_0)-phi_flex)))));     % Sigmoid over angle (set extreme angles to zero; relative to phi_0)

% Convert to cartesian version
[fitFun_ctn,x_qps,y_qps] = pol2cart2dMat(fitFun_pol,phi_range,r_range,x_res,y_res);

%% Plots

% polar version
figure;
subplot(1,2,1)
imagesc(phi_range,r_range,fitFun_pol)
set(gca,'ydir','normal')
set(gca,'xtick',[-2*pi,-1.5*pi,-pi,-0.5*pi,0,0.5*pi,pi,1.5*pi,2*pi], ...
    'xticklabel',{'-2\pi','-1.5\pi','-\pi','-0.5\pi','0','0.5\pi','\pi','1.5\pi','2\pi'});
ylabel('Radius r [mm]')
xlabel('Angle \phi [rad]')
title('Fit Function, Polar');
axis square
% cartesian version
subplot(1,2,2)
imagesc(x_qps,y_qps,fitFun_ctn);
set(gca,'ydir','normal')
ylabel('Vertical Dist. From Ref. [mm]')
xlabel('Horizontal Dist. From Ref. [mm]')
title('Fit Function, Cartesian');
axis square

