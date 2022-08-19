mu = 3.986004418E14 /1000^3; % km^3 /s^2
% r = [-6045; -3490; 2500]; % km
% v = [-3.457; 6.618; 2.533]; % km/s 
R = [3489.8 3460.1 34299; 3430.2 3460.1 3490.1; 4078.5 4078.5 4078.5];
rho = [];
t = [0; 118.2; 237.58];

[r,v] = observation2state(R, rho, t, mu);
orbitalElements = state2orbitalElements(r, v, mu);
%% 
cla
plotFromOE(orbitalElements, mu, r)