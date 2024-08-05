function orbitalElements = convertOE(orbitalElements)
% CONVERTOE converts OE from h to semimajor axis (a)

mu = 3.986004418E14 /1000^3;
h = orbitalElements(3);
e = orbitalElements(6);

rp = h^2/mu * 1/(1+e*cos(0));
ra = h^2/mu * 1/(1+e*cos(pi));
orbitalElements(3) = 0.5*(ra+rp);


end