mu = 3.986004418E14 /1000^3; % km^3 /s^2
% r = [-6045; -3490; 2500]; % km
% v = [-3.457; 6.618; 2.533]; % km/s 
deg = pi/180;
 
% Example 1 data
% t = [0, 118.10, 237.58];
% alfa = deg*([43.537;54.420;64.318]);
% delta = deg*([-8.7833;-12.074;-15.105]);
% theta = deg*[44.506;45.000;45.499];
% phi = deg*40;
% Re = 6378; %km
% f = 0.003353;
% H = 1;

% Example 2 data
t = [0, 60, 120];
alfa = deg*([0; 65.9279; 79.8500]);
delta = deg*([51.5110; 27.9911; 14.6609]);
theta = deg*[0; 0.250684; 0.501369];
phi = deg*29;
Re = 6378; %km
f = 0.003353;
H = 0;

%%
R = findStationPosition(phi, theta, Re, f, H);
%%
rho = angles2directionCosines(alfa, delta);
%%
[r,v] = observation2state(R, rho, t, mu);
%%
[r,v] = refineStateMeasurement(r, v, mu);
%%
orbitalElements = state2orbitalElements(r, v, mu);
%% 
cla
plotFromOE(orbitalElements, mu, r)
%%