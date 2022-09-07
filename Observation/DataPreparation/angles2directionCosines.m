function rho = angles2directionCosines(alfa, delta)
rho = [cos(delta).*cos(alfa) cos(delta).*sin(alfa) sin(delta)].';
end

