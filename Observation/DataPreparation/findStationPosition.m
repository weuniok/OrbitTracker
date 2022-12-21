function R = findStationPosition(phi, theta, Re, f, H)
%FINDSTATIONPOSITION converts from geocentral coordinates to cartesian (ECI)
% phi = geodetic latitude
% theta = local sidereal time
% Re = equatorial radius
% f - oblateness = (Re - Rp) / Re where:
% Rp = polar radius
% H = local altitude

theta = theta.'; % to horizontal
multiplier = Re / sqrt(1-(2*f - f*f)*sin(phi)^2);

R = [(multiplier + H) * cos(phi) * cos(theta); ...
    (multiplier + H) * cos(phi) * sin(theta);...
    (multiplier * (1-f)^2 + H) * sin(phi) .* ones(length(theta),1).'];

end

