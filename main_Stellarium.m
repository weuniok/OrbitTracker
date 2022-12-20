clc
clear
cla
%% Constants
improvement = true;

mu = 3.986004418E14 /1000^3;
deg = pi/180;
Re = 6378; % Earth Radius
f = 0.003353; % Earth oblateness
%% ISS model
% Values from the web
TLE_first_line = {1 '25544U' '98067A' 22353.42711160  .00011227  00000-0  20403-3 0  9992};
TLE_second_line = [2 25544  51.6432 138.9346 0003592 174.7295 234.7524 15.50052736373915];

ISS = ISSClass(TLE_first_line, TLE_second_line);
ISS_OE = ISS.getOrbitalElements;
%% Observer's data
phi = deg*(51+23/60+15.49/60/60); % geodetic longtitude east
H = 153; % [m] local altitude

theta = deg*[...
    15+28/60+27.1/3600; ...
    16+00/60+29.8/3600;...
    16+02/60+39.0/3600]/24*360; % local (mean) sidereal time [deg]

R = findStationPosition(phi, theta, Re, f, H);

%% Observation
t = [52*60+24, 54*60+26, 56*60+35]; % time [seconds]

real_R = [-2854, -3102, 5320; ...
          -2127, -3692, 5284; ...
          -1317, -4237, 5136]';
real_R_norm = vecnorm(real_R(:, 2));

real_V = [5.74, -5.08, 0.12; ...
          6.13, -4.55, -0.71; ...
          6.41,-3.90, -1.57]';
real_V_norm = vecnorm(real_V(:, 2));

real_state_vector = [real_R_norm, real_V_norm];

ISS.setAnomaly(deg*(-78+16/60+7.4/3600));

rho = zeros(3,3);
for i=1:3
rho(:, i) = position2dirCosine(real_R(:,i), R(:,i));
end

[r,v] = observation2state(R, rho, t, mu, improvement);
orbitalElements = state2orbitalElements(r, v, mu);

%% Data display
measuredValues = [norm(r), norm(v), orbitalElements];
trueValues = [real_state_vector, ISS.orbitalElements];
displayData("Measured", convertOE(measuredValues));
displayData("True", convertOE(trueValues));
displayData("Error [measured-true]", (convertOE(measuredValues)-(convertOE(trueValues))));

% Plots
hold on
plotEarth();

plotFromOE(orbitalElements, mu, r, 'Calculated position', true)

hold on
axis equal

ISS.plot("Observation 2", true);

plot3(R(1,2), R(2,2), R(3,2), 'o', 'MarkerFaceColor', 'blue', 'DisplayName', 'Observer')

plot3(real_R(1,3), real_R(2,3), real_R(3,3), ...
    'o', 'MarkerFaceColor', 'red', 'DisplayName', 'Observation 1')
% plot3(real_R(1,2), real_R(2,2), real_R(3,2), ...
%     'o', 'MarkerFaceColor', 'red', 'DisplayName', 'Observation 2')
plot3(real_R(1,1), real_R(2,1), real_R(3,1), ...
    'o', 'MarkerFaceColor', 'red', 'DisplayName', 'Observation 3')