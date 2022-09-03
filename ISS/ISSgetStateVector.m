function [r,v] = ISSgetStateVector (anomaly, mu)
% returns state vector of ISS orbit from the following TLE

% 1 25544U 98067A   22246.67365757  .00002926  00000-0  59194-4 0  9993
% 2 25544  51.6442 307.7584 0002851 188.8255 322.7546 15.50015618357355

% Epoch (UTC):	03 September 2022 16:10:04
% Eccentricity:	0.0002851
% inclination:	51.6442°
% perigee height:	415 km
% apogee height:	418 km
% right ascension of ascending node:	307.7584°
% argument of perigee:	188.8255°
% revolutions per day:	15.50015618
% mean anomaly at epoch:	322.7546°
% orbit number at epoch:	35735
deg = pi/180;

secondLine = [2 25544  51.6442 307.7584 0002851 188.8255 322.7546 15.50015618357355];


inclination = secondLine(3) * deg;
RAofAscendingNode = secondLine(4) * deg;
eccentricity = secondLine(5) * 10E-8;
perigeeArgument = secondLine(6) * deg;

meanMotion = secondLine(8) * 2*pi/24/60/60; % revolutions/day -> rad/s

semiMajorAxis = (mu / meanMotion^2)^(1/3);
semiMinorAxis = semiMajorAxis * (1-eccentricity^2)^0.5;
h = meanMotion * semiMajorAxis * semiMinorAxis;

orbitalElements = [h, inclination, RAofAscendingNode, eccentricity, perigeeArgument, anomaly];
[r,v] = orbitalElements2state(orbitalElements, mu);
% plotFromOE(orbitalElements, mu, r);

return
end