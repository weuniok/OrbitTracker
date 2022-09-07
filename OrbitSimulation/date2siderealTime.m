function theta = date2siderealTime(date, longtitudeEast)
%DATE2SIDEREALTIME retrns local sidereal time 
% date - datetime object
deg = pi/180;

T0 = (juliandate(date) - 2451545) / 36526;
theta_gw = (100.4606184 + 36000.77004*T0 + 0.000387933*T^2 - 2.583*1E-8*T0^3);
theta_gw = mod(theta_gw, 360);
theta = (theta_gw + longtitudeEast)*deg;
end

