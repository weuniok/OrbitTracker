%% Constants
mu = 3.986004418E14 /1000^3;
deg = pi/180;
Re = 6378; % Earth Radius 
f = 0.003353; % Earth oblateness
%% ISS model
ISS = ISSClass();
ISS_OE = ISS.getOrbitalElements;
% TLE values are hardcoded ATM and must be changed niside ISSClass definition
% TLE_firstLine = {1 '25544U' '98067A'   22250.60379146  .00007699  00000-0  14232-3 0  9993};
% TLE_secondLine = [2 25544  51.6443 288.2831 0002670 203.2971 293.6689 15.50084907357968];
%% Observer's data
phi = deg*(51+13/60+12.72/60/60); % geodetic longtitude east
lambda = deg*(13+33/60); % latitude
H = 0; % [m] local altitude

%% Test cases data
cla

anomalies_sets = ...
    [254 256 258;
    254 256 258;
    254 256 258].*deg;

improvement = true;
central_anomaly = 256;
danomaly = 120;
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
    % theta - local sidereal time TODO calculate this 
%     R = findStationPosition(phi, theta, Re, f, H);
%     R = ones(3)*100;
    date = datetime("1-Jan-1970 00:00:00");

    % Time and direction cosines of each observation
    for i = 1:3
        t(i) = anomaly2time(anomalies(i), ISS_OE, mu);
        currentState = ISS.getStateVector(anomalies(i));
        ISS_position = currentState(:, 1);

        theta(i) = date2siderealTime(date+seconds(t(i)), phi);
        R(:,i) = findStationPosition(phi, theta(i), Re, f, H);
        rho(:, i) = position2dirCosine(ISS_position, R(:,i));

        ISS.setAnomaly(anomalies(i));
%         ISS.plot();

    end
    t = t-t(1);

    % Proper calculations
%     [r,v] = observation2state(R, rho, t, mu, true);
    [r,v] = observation2state(R, rho, t, mu, improvement);
    orbitalElements = state2orbitalElements(r, v, mu);

    % Plots
    cla
    plotFromOE(orbitalElements, mu, r);
    ISS.setAnomaly(anomalies(2));
%     ISS.plot();

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
rReal = [3704; 2109; 5283];
vReal = [-4.53; 6.14; 0.72];

t = [54*60, 56*60+50, 58*60+33]; % time [seconds]
alfa = deg*([...
    20+58/60+11.81/3600; ...
    1+39/60+12.08/3600; ...
    7+15/60+37.05/3600]/24*360); % right ascension [deg]
delta = deg*([...
    5+6/60+8.5/3600; ...
    52+4/60+6.3/3600; ...
    26+39/60+12.4/3600]); % declination [deg]
theta = deg*[...
    1+57/60+3.1/3600; ...
    1+59/60+53.6/3600;...
    2+1/60+37.3/3600]/24*360; % local (mean) sidereal time [deg]
% theta = deg*[...
%     1+57/60+2.4/3600; ...
%     1+59/60+52.9/3600;...
%     2+1/60+36.5/3600]/24*360; % apparent sidereal time [deg]

phi = deg*(51+13/60+12.72/60/60); % geodetic latitude

R = findStationPosition(phi, theta, Re, f, H);
rho = angles2directionCosines(alfa, delta);

[r,v] = observation2state(R, rho, t, mu, true);
orbitalElements = state2orbitalElements(r, v, mu);
plotFromOE(orbitalElements, mu, r)
