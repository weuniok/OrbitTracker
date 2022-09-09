function [r2, v2] = observation2state(R, rho, t, mu, iterativeImprovementOn)
% returns state vector
% R - observer's position vectors
% rho - direction cosine vectors
% t - observation times

% time intervals
tau = [t(1)-t(2); t(3)-t(1); t(3)-t(2)];
% cross products p
p = [cross(rho(:,2), rho(:,3)), cross(rho(:,1), rho(:,3)), cross(rho(:,1), rho(:,2))];
% weird D
D0 = dot(rho(:,1), p(:,1));
D = R.'*p;
% A and B
A = 1/D0 * (-D(1,2) * tau(3)/tau(2) + D(2,2) + D(3,2) * tau(1)/tau(2));
B = 1/6/D0 * (D(1,2)*(tau(3)^2-tau(2)^2)*tau(3)/tau(2) + D(3,2)*(tau(2)^2-tau(1)^2)*tau(1)/tau(2));
% E
E = dot(R(:,2), rho(:,2));
% abc coefficients
a = -(A^2+2*A*E+dot(R(:,2), R(:,2))); 
b = -2*mu*B*(A+E);
c = -mu^2*B^2;
% roots
r = roots([1, 0, a, 0, 0, b, 0, 0, c]);
r2Norm = max(r(real(r)>0 & imag(r) == 0)); % real solutions larger than Earth Radius

if length(r2Norm) > 1
    error("More than one solution to the 8th order polynomial calculated. Proceeding is not supported.")
else 
    if isempty(r2Norm)
        error("No solution found.");
    end
end

% lengths of cosine directions
rhoNorm(1) = 1/D0 * ( (6*(D(3,1)*tau(1)/tau(3) + D(2,1)*tau(2)/tau(3))*r2Norm^3  + mu*D(3,1)*(tau(2)^2-tau(1)^2)*tau(1)/tau(3) )...
    / (6*r2Norm^3 + mu*(tau(2)^2 - tau(3)^2)) - D(1,1) ) ;
rhoNorm(2) = A + mu*B/r2Norm^3;
rhoNorm(3) = 1/D0 * ( (6*(D(1,3)*tau(3)/tau(1) - D(2,3)*tau(2)/tau(1))*r2Norm^3  + mu*D(1,3)*(tau(2)^2-tau(3)^2)*tau(3)/tau(1) )...
    / (6*r2Norm^3 + mu*(tau(2)^2 - tau(3)^2)) - D(3,3) ) ;
% r vector
r = R + rho .* rhoNorm;
% Langrage coefficients
f(1) = 1 - 0.5 * mu/r2Norm^3 * tau(1)^2;
f(3) = 1 - 0.5 * mu/r2Norm^3 * tau(3)^2;
g(1) = tau(1) - mu/r2Norm^3*tau(1)^3/6;
g(3) = tau(3) - mu/r2Norm^3*tau(3)^3/6;
% v2
v2 = (f(1)*r(:,3)-f(3)*r(:,1))/(f(1)*g(3)-f(3)*g(1));
r2 = r(:,2);

if iterativeImprovementOn == true
    iter = 0;
    iterMax = 1000;
    maxError = 1E-8;
    error = [1,1,1];
    fgNew = [f(1), f(3), g(1), g(3)];

    while sum(error < maxError) ~= 3 && iter < iterMax
    [r2, v2, newRhoNorm, fgNew] = refineStateMeasurement(r2, v2, tau, rho, R, D, D0, mu, fgNew);
    error = abs(newRhoNorm - rhoNorm);
    rhoNorm = newRhoNorm;
    iter = iter + 1;
    end

end

end

