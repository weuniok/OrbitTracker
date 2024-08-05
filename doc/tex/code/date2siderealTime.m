function theta = date2siderealTime(date, longtitudeEast)
%DATE2SIDEREALTIME retrns local sidereal time at date for longtitude
% date - datetime object
% longtitudeEast - [rad]
deg = pi/180;

T0 = (juliandate(date) - 2451545) / 36526;
theta_gw = (100.4606184 + 36000.77004*T0 + 0.000387933*T0^2 - 2.583*1E-8*T0^3);
theta_gw = mod(theta_gw, 360);
theta_gw = theta_gw + 360.98564724*timeofday(date)/hours(24);
theta = theta_gw*deg + longtitudeEast;
theta = mod(theta, 2*pi);
end

