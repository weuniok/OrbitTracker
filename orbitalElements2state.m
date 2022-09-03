function [r,v] = orbitalElements2state(orbitalElements, mu)

% plots the orbit from orbirtal elements vector
% orbitalElements:
% (1) hNorm = specific angular momentum
% (2) i = inclination
% (3) omega = RA of ascending node
% (4) eNorm = eccentricity
% (5) w = perigee argument
% (6) theta = true anomaly

h = orbitalElements(1);
i = orbitalElements(2);
omega = orbitalElements(3);
e = orbitalElements(4);
w = orbitalElements(5);
theta = orbitalElements(6);

% perifocal coordinates orbital state
r = h^2/mu * 1 / (1+ e*cos(theta)) .* [cos(theta); sin(theta); 0];
v = mu/h * [-sin(theta); e+cos(theta); 0];

% rotation matrix from geocentric to perifocal;
rotation = ...
    [cos(w) sin(w) 0; -sin(w) cos(w) 0; 0 0 1] * ...
    [1 0 0; 0 cos(i) sin(i); 0 -sin(i) cos(i)] * ...
    [cos(omega) sin(omega) 0; -sin(omega) cos(omega) 0; 0 0 1];

% geocentric orbital state
r = rotation.' * r;
v = rotation.' * v;

return
end

