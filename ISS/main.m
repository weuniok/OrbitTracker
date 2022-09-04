mu = 3.986004418E14 /1000^3;

ISS = ISSClass();

ISS_OE = ISS.getOrbitalElements;
ISS_measure = ISS.getStateVector(0);

measuredOE = state2orbitalElements(ISS_measure(:,1), ISS_measure(:,2), mu);

error = ISS_OE - measuredOE;


% plotFromOE(ISS_OE, mu, ISS_measure(:,1));
% hold on
% plotFromOE(measuredOE, mu, ISS_measure(:,1));


%% Testing observation Stellarium
deg = pi/180;

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
    2+1/60+37/3600]/24*360; % local sidereal time [deg]
phi = deg*(51+13/60+12.72/60/60); % geodetic latitude
Re = 6378; % Earth Radius 
f = 0.003353; % Earth oblateness
H = 0; % local altitude

R = findStationPosition(phi, theta, Re, f, H);
rho = angles2directionCosines(alfa, delta);

[r,v] = observation2state(R, rho, t, mu, true);
orbitalElements = state2orbitalElements(r, v, mu);
plotFromOE(orbitalElements, mu, r)
