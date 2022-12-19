function orbitPlot = plotFromOE(orbitalElements, mu, r)
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

% perigee
rp = h^2/mu * 1/(1+e*cos(0));
% apogee
ra = h^2/mu * 1/(1+e*cos(pi));

% perifocal r
theta = linspace(0, 2*pi);
R = h^2/mu * 1 ./ (1+ e*cos(theta)) .* [cos(theta); sin(theta); zeros(1, length(theta))];

rotation = ...
    [cos(w) sin(w) 0; -sin(w) cos(w) 0; 0 0 1] * ...
    [1 0 0; 0 cos(i) sin(i); 0 -sin(i) cos(i)] * ...
    [cos(omega) sin(omega) 0; -sin(omega) cos(omega) 0; 0 0 1];

% geocentric R
R = rotation.' * R;

%% plotting
hold on
% plotting Earth
earthR = 6371; %km
% [X,Y,Z] = sphere;
% X = X * earthR;
% Y = Y * earthR;
% Z = Z * earthR;
% surf(X,Y,Z, 'DisplayName', 'Earth'); 
% Equatorial plane
% maxR = max(abs(R), [], 'all');
maxR = max(abs(earthR*1.5), [], 'all');
[x, y] = meshgrid(-maxR:maxR:maxR);
z = zeros(size(x,1));
surf(x,y,z, 'FaceAlpha', 0.2, 'DisplayName', 'Equatorial plane');
% plotting the orbit
plot3(R(1,:), R(2,:), R(3,:), 'DisplayName', 'Orbit'); 

% Apse line
apsePoints = [ [rp*cos(0); 0; 0], [0; 0; 0], [ra*cos(pi); 0; 0] ];
apsePoints = rotation.' * apsePoints;
plot3(apsePoints(1,:), apsePoints(2,:), apsePoints(3,:), 'o--k', 'MarkerFaceColor', 'black', ...
    'DisplayName', 'Apse line')

% Node line


% Initial state
plot3(r(1), r(2), r(3), 'o', 'MarkerFaceColor', 'red', 'DisplayName', 'Initial state')
% Axes
axis equal
xlabel('x [km]')
ylabel('y [km]')
zlabel('z [km]')
grid on
legend()
% Initial state geo

hold off
end