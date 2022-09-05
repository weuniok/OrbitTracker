function timeSincePeriapsis = anomaly2time(anomaly, orbitalElements, mu)
% Returns time since periapsis for true anomaly, orbit's OE and mu
% orbitalElements:
% (1) hNorm = specific angular momentum
% (2) i = inclination
% (3) omega = RA of ascending node
% (4) eNorm = eccentricity
% (5) w = perigee argument
% (6) theta = true anomaly

hNorm = orbitalElements(1);
eNorm = orbitalElements(4);
eFraction = (1-eNorm)/(1+eNorm);

% eccentric anomaly
E = 2*atan(sqrt(eFraction)*tan(anomaly/2));

% mean anomaly
meanAnomaly = E - eNorm*sin(E);

timeSincePeriapsis = meanAnomaly * (hNorm/sqrt(1-eNorm^2))^3/mu^2; 

end

