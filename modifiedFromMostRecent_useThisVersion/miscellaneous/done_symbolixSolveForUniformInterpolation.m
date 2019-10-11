

x1 = sym('x1', [1 2]); % position vector of last resulting point (from previous step)
x2 = sym('x2', [1 2]); % position vector of raw trajectory's first point of
                       % segment currently being checked for intersection
                       % point with circle of radius r around x1.
x3 = sym('x3', [1 2]); % position vector of the second point of that segment
                       % (if the current segment has an intersection point
                       % with said circle, then the final point will be on
                       % on the segment between x1 and x3)

                       syms l; % factor by which x3 need to multiplied to arrive at new point
                       syms r; % Distance from x1 at which the new point should be placed

% Constraint is that the new point should be separated from x1 by a distance of
% r and that it should lie somwhere on the original trajectory. The new point
% will be expressed in terms of the position vector of x2 plus some
% multiple of the vector from x2 to x3 (l).
                       
% Define equation      
eqn1 = r^2 == sum((x2+l*(x3-x2)-x1).^2);

solve(eqn1,l,'IgnoreAnalyticConstraints',1)

%% TEST SOLUTION 


segLen = 7;      % desired segment length in final intepolation

p11 = 2.5;  % position vector of last resulting point (from previous step)
p12 = 2;

p21 = 1;    % position vector of raw trajectory's first point of
p22 = 5.5;  % segment currently being checked for intersection
            % point with circle of radius r around x1.

p31 = 7;    % position vector of the second point of that segment
p32 = 6;    % (if the current segment has an intersection point
            % with said circle, then the final point will be on
            % on the segment between x1 and x3)

l = ...
(p11*p31 - p12*p22 - p11*p21 + p12*p32 - p21*p31 - p22*p32 + ...
    (segLen^2*p21^2 - 2*segLen^2*p21*p31 + segLen^2*p22^2 - 2*segLen^2*p22*p32 + ...
    segLen^2*p31^2 + segLen^2*p32^2 - p11^2*p22^2 + 2*p11^2*p22*p32 - ...
    p11^2*p32^2 + 2*p11*p12*p21*p22 - 2*p11*p12*p21*p32 - ...
    2*p11*p12*p22*p31 + 2*p11*p12*p31*p32 - 2*p11*p21*p22*p32 + ...
    2*p11*p21*p32^2 + 2*p11*p22^2*p31 - 2*p11*p22*p31*p32 - ...
    p12^2*p21^2 + 2*p12^2*p21*p31 - p12^2*p31^2 + 2*p12*p21^2*p32 -...
    2*p12*p21*p22*p31 - 2*p12*p21*p31*p32 + 2*p12*p22*p31^2 - ...
    p21^2*p32^2 + 2*p21*p22*p31*p32 - p22^2*p31^2)^(1/2) + ...
    p21^2 + p22^2)/(p21^2 - 2*p21*p31 + p22^2 - 2*p22*p32 + p31^2 + p32^2);


p_new = [p21, p22] + ([p31, p32]-[p21, p22]) * l