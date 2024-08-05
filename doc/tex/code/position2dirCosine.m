function rho = position2dirCosine(RObject, RObserver)
%POSITION2DIRCOSINE returns observation vectors for object and observer position vectors
% rho - direction cosine vector
% RObject - position vector of the spaceship
% RObserver - position vector of the observer

rho = RObject - RObserver;
rhoNorm = norm(rho);
rho = rho/rhoNorm;

end

