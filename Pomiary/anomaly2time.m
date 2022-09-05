function timeSincePeriapsis = anomaly2time(anomaly, orbitalElements)
% Compiles 3 state vectors and orbit's orbital elements into times of possible observations
% states = [r1 v1; r2 v2; r3 v3]
% orbitalElements:
% (1) hNorm = specific angular momentum
% (2) i = inclination
% (3) omega = RA of ascending node
% (4) eNorm = eccentricity
% (5) w = perigee argument
% (6) theta = true anomaly

eNorm = orbitalElements(4);
eFraction = (1-eNorm)/(1+eNorm);

% eccentric anomaly
E = 2*atan(sqrt(eFraction)*tan(anomaly/2));
meanAnomaly = E - eNorm*sin(E);
%

timeSincePeriapsis = meanAnomaly/2/pi * orbitalPeriod;

end

