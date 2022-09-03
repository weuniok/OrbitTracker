function [r,v] = ISSgetStateVector (anomaly)
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
eccentricity = secondLine(5);
perigeeArgument = secondLine(6) * deg;


h = orbitalElements(1);
i = orbitalElements(2);
omega = orbitalElements(3);
e = orbitalElements(4);
w = orbitalElements(5);

%radii
% perigee
rp = h^2/mu * 1/(1+e*cos(0));
%apogee
ra = h^2/mu * 1/(1+e*cos(pi));

ra = -ra;
rp = -rp;

% semimajor axis
a = 0.5 * (rp + ra);
% period
T = 2 * pi / sqrt(mu) * a^1.5;

% start plot at X, then transform
t = linspace(0, 2*pi);
b = a * sqrt(1-e^2);

X = a * cos(t);
Y = b * sin(t);
Z = a * 0;

x = (-rp+ra)/2 + X;
y = Y; 
z = X*0;

rotation = ...
    [cos(w) sin(w) 0; -sin(w) cos(w) 0; 0 0 1] * ...
    [1 0 0; 0 cos(i) sin(i); 0 -sin(i) cos(i)] * ...
    [cos(omega) sin(omega) 0; -sin(omega) cos(omega) 0; 0 0 1];

R = rotation.' * [x;y;z];

hold on
% plotting Earth
earthR = 6371; %km
[X,Y,Z] = sphere;
X = X * earthR;
Y = Y * earthR;
Z = Z * earthR;
surf(X,Y,Z, 'DisplayName', 'Earth'); 
% Equatorial plane
maxR = max(abs(R), [], 'all');
[x, y] = meshgrid(-maxR:maxR:maxR);
z = zeros(size(x,1));
surf(x,y,z, 'FaceAlpha', 0.2, 'DisplayName', 'Equatorial plane');
% plotting the orbit
plot3(R(1,:), R(2,:), R(3,:), 'DisplayName', 'Orbit'); % rotated orbit
% plot3(R2(1,:), R2(2,:), R2(3,:)); % rotated orbit

% Apse line
apsePoints = [ [-rp; 0; 0], [0; 0; 0], [ra; 0; 0] ];
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


return
end