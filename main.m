clc
clear
cla
%% Constants
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
phi = deg*(51 + 13/60 + 15.49/3600); % geodetic longtitude east
lambda = deg*(18 + 34/60 + 10.70/3600); % latitude
H = 165; % [m] local altitude
%% Generated test data
cla

improvement = true; % iterative improvement

central_anomaly = 312;
danomaly = 5; %
anomalies_sets = [central_anomaly-danomaly central_anomaly central_anomaly+danomaly].*deg;

%%= Test cases solving
for test_case = 1:height(anomalies_sets)
    anomalies = anomalies_sets(test_case, :);

    % Memory allocation
    t = zeros(1, 3);
    theta = zeros(3, 1);
    R = zeros(3, 3);
    ISS_rho = zeros(3, 3);
    rho = zeros(3, 3);

    % Observer's position vector at each observation
    %     R = findStationPosition(phi, theta, Re, f, H);
    %     R = ones(3)*100;
    first_obs_time = datetime("19-Dec-2022 9:30:00");

    % Time and direction cosines of each observation
    for i = 1:3
        t(i) = anomaly2time(anomalies(i), ISS_OE, mu);
        currentState = ISS.getStateVector(anomalies(i));
        ISS_position = currentState(:, 1);

        theta(i) = date2siderealTime(first_obs_time+seconds(t(i)), phi);
        R(:,i) = findStationPosition(phi, theta(i), Re, f, H);
        rho(:, i) = position2dirCosine(ISS_position, R(:,i));

        ISS.setAnomaly(anomalies(i));
        ISS.plot(sprintf("Observation %d", i), i==2);


    end
    t = t-t(1);

    % Proper calculations
    [r,v] = observation2state(R, rho, t, mu, improvement);
    orbitalElements = state2orbitalElements(r, v, mu);

    % Plots
    %     cla
    hold on
    plotEarth();
    plotFromOE(orbitalElements, mu, r, "Calculated position", true);
    ISS.setAnomaly(anomalies(2));
    %         ISS.plot();
    hold on
    %     plot3(R(1,3), R(2,3), R(3,3), 'o', 'MarkerFaceColor', 'red', 'DisplayName', 'Observer')
    plot3(R(1,2), R(2,2), R(3,2), 'o', 'MarkerFaceColor', 'blue', 'DisplayName', 'Observer')
    %     plot3(R(1,1), R(2,1), R(3,1), 'o', 'MarkerFaceColor', 'red', 'DisplayName', 'Observer')

    % Data display
    measuredValues = [norm(r), norm(v), orbitalElements];
    trueValues = [vecnorm(ISS.state), ISS.orbitalElements];
    displayData("Measured", measuredValues);
    displayData("True", trueValues);
    displayData("Error [measured-true]", measuredValues-trueValues);

    if height(anomalies_sets) > 1
        pause;
    end
end

%% Stellarium test case
cla
improvement = true;

real_R = [-2854, -3102, 5320; ...
          -2127, -3692, 5284; ...
          -1317, -4237, 5136]';

real_V = [-2854, -3102, 5320; ...
          -2127, -3692, 5284; ...
          -1317, -4237, 5136]';

ISS.setAnomaly(deg*(-78+16/60+7.4/3600));
t = [52*60+24, 54*60+26, 56*60+35]; % time [seconds]

theta = deg*[...
    15+28/60+27.1/3600; ...
    16+00/60+29.8/3600;...
    16+02/60+39.0/3600]/24*360; % local (mean) sidereal time [deg]

phi = deg*(51+23/60+15.49/60/60); % geodetic latitude

R = findStationPosition(phi, theta, Re, f, H);

rho = zeros(3,3);
for i=1:3
rho(:, i) = position2dirCosine(real_R(:,i), R(:,i));
end


[r,v] = observation2state(R, rho, t, mu, true);
orbitalElements = state2orbitalElements(r, v, mu);

% Data display
measuredValues = [norm(r), norm(v), orbitalElements];
trueValues = [vecnorm(ISS.state), ISS.orbitalElements];
displayData("Measured", measuredValues);
displayData("True", trueValues);
displayData("Error [measured-true]", measuredValues-trueValues);

% Plots
hold on
plotEarth();

plotFromOE(orbitalElements, mu, r, 'Calculated position', false)

hold on
ISS.plot("Observation", true);

plot3(R(1,2), R(2,2), R(3,2), 'o', 'MarkerFaceColor', 'blue', 'DisplayName', 'Observer')

plot3(real_R(1,3), real_R(2,3), real_R(3,3), ...
    'o', 'MarkerFaceColor', 'red', 'DisplayName', 'Station 1')
plot3(real_R(1,2), real_R(2,2), real_R(3,2), ...
    'o', 'MarkerFaceColor', 'red', 'DisplayName', 'Station 2')
plot3(real_R(1,1), real_R(2,1), real_R(3,1), ...
    'o', 'MarkerFaceColor', 'red', 'DisplayName', 'Station 3')