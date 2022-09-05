%% ISS model
mu = 3.986004418E14 /1000^3;

ISS = ISSClass();

ISS_OE = ISS.getOrbitalElements;
ISS_measure = ISS.getStateVector(0);

measuredOE = state2orbitalElements(ISS_measure(:,1), ISS_measure(:,2), mu);

error = ISS_OE - measuredOE;


plotFromOE(ISS_OE, mu, ISS_measure(:,1));
% hold on
% plotFromOE(measuredOE, mu, ISS_measure(:,1));


%% Testing observation Stellarium
mu = 3.986004418E14 /1000^3;
deg = pi/180;
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
Re = 6378; % Earth Radius 
f = 0.003353; % Earth oblateness
H = 0; % local altitude

R = findStationPosition(phi, theta, Re, f, H);
rho = angles2directionCosines(alfa, delta);

[r,v] = observation2state(R, rho, t, mu, true);
orbitalElements = state2orbitalElements(r, v, mu);
plotFromOE(orbitalElements, mu, r)
%% Comparison to TLE ISS
ISS_rNorm = norm(ISS_measure(:,1));
ISS_vNorm = norm(ISS_measure(:,2));
rNorm = norm(r);
vNorm = norm(v);
rRealNorm = norm(rReal);
vRealNorm = norm(vReal);

errorR = abs(ISS_rNorm-rNorm)/rNorm;
errorV = abs(ISS_vNorm-vNorm)/vNorm;
errorRealR = abs(rRealNorm-rNorm)/rNorm;
errorRealV = abs(vRealNorm-vNorm)/vNorm;
errorISSR = abs(rRealNorm-ISS_rNorm)/rNorm;
errorISSV = abs(vRealNorm-ISS_vNorm)/vNorm;
