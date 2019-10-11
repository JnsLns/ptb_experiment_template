% The general theory of random variables states that
% if x is a random variable with
% mean mu_x and
% variance s^2_x,
%
% then the random variable y,
% defined by y = ax + b,
% where a and b are constants, has
% mean mu_y = a * mu_x + b and
% variance s^2_y = a^2 * s^2_x.

% Draw pseudrandom value from normal distribution with defined mean and
% standard deviation.

% mns = column vector with means
% sds = column vector with stds
% mns_out = column vector with means 

function mns_out = randnParams(mns,sds)

mns_out = sds.*randn(size(sds,1),1) + mns;

end


