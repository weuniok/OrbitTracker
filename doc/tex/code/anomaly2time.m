function timeSincePeriapsis = anomaly2time(anomaly, orbitalElements, mu)
%ANOMALY2TIME Returns time since periapsis for true anomaly and orbitalElements
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

% if anomaly > pi
%     full_orbits = floor(anomaly/pi);
% else
%     full_orbits = 0;
% end

% Period
T = 2*pi/mu^2 * (hNorm/sqrt(1-eNorm^2))^3;

% eccentric anomaly
E = 2*atan(sqrt(eFraction)*tan(anomaly/2));

% mean anomaly
meanAnomaly = E - eNorm*sin(E);

timeSincePeriapsis = meanAnomaly * T / 2 / pi;

if anomaly > pi
    timeSincePeriapsis = timeSincePeriapsis + T;
end

end

