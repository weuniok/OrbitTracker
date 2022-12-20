function plotEarth()
%PLOTEARTH plots Earth 

% plotting Earth

earthR = 6371; %km
[X,Y,Z] = sphere;
X = X * earthR;
Y = Y * earthR;
Z = Z * earthR;
surf(X,Y,Z, 'DisplayName', 'Earth', 'FaceAlpha', 0.1, 'EdgeAlpha', 0.3); 
% Equatorial plane
% maxR = max(abs(R), [], 'all');
maxR = max(abs(earthR*1.5), [], 'all');
[x, y] = meshgrid(-maxR:maxR:maxR);
z = zeros(size(x,1));
surf(x,y,z, 'FaceAlpha', 0.2, 'DisplayName', 'Equatorial plane', 'FaceAlpha', 0.05);

grid on
legend()

end

