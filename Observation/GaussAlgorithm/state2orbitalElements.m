function orbitalElements = state2orbitalElements (r, v, mu)
% returns orbital elements from the state vector
% r = [x y z]
% v = [vx vy vz]


% Distance
rNorm = norm(r);
% Speed
vNorm = norm(v);
% Radial velocity
vr = dot(r, v) / rNorm;
% Specific angular momentum
h = cross(r, v);
hNorm = norm(h);
% Inclination
i = acos(h(3)/hNorm);
% Node line vector
N = cross([0 0 1], h);
NNorm = norm(N);
% RA of ascending node
if N(2) >= 0
    omega = acos(N(1)/NNorm);
else
    omega = 2*pi - acos(N(1)/NNorm);
end
% eccentricity
e = 1/mu * (cross(v,h) - mu * r/rNorm);
eNorm = norm(e);
% perigee argument
if e(3) >= 0
    w = acos(dot(N, e)/NNorm/eNorm);
else
    w = 2*pi - acos(dot(N, e)/NNorm/eNorm);
end
% true anomaly
if vr >= 0
    theta = acos(dot(e, r)/eNorm/rNorm);
else
    theta = 2*pi - acos(dot(e, r)/eNorm/rNorm);
end

orbitalElements = [hNorm, i, omega, eNorm, w, theta];
% hNorm = specific angular momentum
% i = inclination
% omega = RA of ascending node
% eNorm = eccentricity
% w = perigee argument
% theta = true anomaly

return
end