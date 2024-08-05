function rho = angles2directionCosines(alfa, delta)
%ANGLES2DIRECTIONCOSINES converts astro coordinates angles (declination and RA) to direction
% vectors
rho = [cos(delta).*cos(alfa) cos(delta).*sin(alfa) sin(delta)].';
end

