function x = universalAnomaly(alpha, mu)
% Solves Kepler's equation for the universal anomaly given dt, r0, vr0, alpha, mu
% x - universal anomaly

% loop tolerance
maxError = 1.e-8;
maxIter = 100;

% initial x0 estimate
x = sqrt(mu)*abs(alpha)*dt;

while i < maxIter & abs(error) > maxError
    i = i+1;
    
    

    x = x - error;
end

end

