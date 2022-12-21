function x = solveUniversalKepler(dt, r0, vr0, a, mu)
%SOLVEUNIVERSALKEPLER Solves universal Kepler equation
% dt 
% r0 - radial position 
% vr0 - radial velocity
% a - reciprocal of semimajor axis
% mu - gravitational parameter
% x - universal anomaly

error = 1E-8;
maxIter = 1000;

% initial X estimate
x = sqrt(mu)*abs(a)*dt;

ratio  = 1;
iter = 0;
while abs(ratio) > error && iter <= maxIter
    % Stumpff functions
    z = a*x*x;
    C = StumpffC(z);
    S = StumpffS(z);

    F = r0*vr0/sqrt(mu)*x^2*C + (1 - a*r0)*x^3*S + r0*x - sqrt(mu)*dt;
    dF = r0*vr0/sqrt(mu)*x*(1 - a*x^2*S) + (1 - a*r0)*x^2*C + r0;

    ratio = F/dF;

    x = x - ratio;
    iter = iter+1;
end
end

