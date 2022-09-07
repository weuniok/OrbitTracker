function [r2, v2, rhoNorm, fgNew] = refineStateMeasurement(r2, v2, tau, rho, R, D, D0, mu, fgOld)
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
x1 = solveUniversalKepler(tau(1), rNorm, vRadial, alpha, mu);
x3 = solveUniversalKepler(tau(3), rNorm, vRadial, alpha, mu);

% f, g, c
z1 = alpha * x1^2;
z3 = alpha * x3^2;

f(1) = 1 - x1^2 / rNorm * StumpffC(z1);
f(3) = 1 - x3^2 / rNorm * StumpffC(z1);
g(1) = tau(1) - 1/sqrt(mu) * x1^3 * StumpffS(z1);
g(3) = tau(3) - 1/sqrt(mu) * x3^3 * StumpffS(z3);

f(1) = mean([f(1), fgOld(1)]);
f(3) = mean([f(3), fgOld(2)]);
g(1) = mean([g(1), fgOld(3)]);
g(3) = mean([g(3), fgOld(4)]);
fgNew = [f(1), f(3), g(1), g(3)];

c1 = g(3)/(f(1)*g(3) - f(3)*g(1));
c3 = -g(1)/(f(1)*g(3) - f(3)*g(1));

% new rho
rhoNorm(1) = 1/D0 * (-D(1,1) + D(2,1)/c1 - D(3,1)*c3/c1);
rhoNorm(2) = 1/D0 * (-c1*D(1,2) + D(2,2) - D(3,2)*c3);
rhoNorm(3) = 1/D0 * (-c1/c3*D(1,3) + D(2,3)/c3 - D(3,3));

r = R + rho .* rhoNorm;
r2 = r(:, 2);
v2 = (f(1)*r(:,3)-f(3)*r(:,1))/(f(1)*g(3)-f(3)*g(1));

end

