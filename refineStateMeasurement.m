function [r2, v2] = refineStateMeasurement(r2, v2, mu)
% iterative improvement of the orbit determined by observation2state.m
% r2 - position vector of object in second observation
% v2 - velocity vector of object in second observation
% mu - gravitational paremete


% vector magnitudes
rNorm = norm(r2);
vNorm = norm(v2);

% semimajor axis reciprocal (1/a)
alpha = 2/rNorm - vNorm^2/mu;

% radial component of v
vRadial = dot(v2, r2/rNorm);

% universal Kepler's equation (Algorithm 3.3, Equation 3.46)



end

