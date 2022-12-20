function orbitPlot = plotFromOE(orbitalElements, mu, r, name, plotAdditional)
% plots the orbit from orbirtal elements vector
% orbitalElements:
% (1) hNorm = specific angular momentum
% (2) i = inclination
% (3) omega = RA of ascending node
% (4) eNorm = eccentricity
% (5) w = perigee argument
% (6) theta = true anomaly
% name - name of plotted point
% plotAdditional - true/false - should plot apse line and orbit?
h = orbitalElements(1);
i = orbitalElements(2);
omega = orbitalElements(3);
e = orbitalElements(4);
w = orbitalElements(5);

% perigee
rp = h^2/mu * 1/(1+e*cos(0));
% apogee
ra = h^2/mu * 1/(1+e*cos(pi));

% perifocal r
theta = linspace(0, 2*pi);
R = h^2/mu * 1 ./ (1+ e*cos(theta)) .* [cos(theta); sin(theta); zeros(1, length(theta))];

rotation = ...
    [cos(w) sin(w) 0; -sin(w) cos(w) 0; 0 0 1] * ...
    [1 0 0; 0 cos(i) sin(i); 0 -sin(i) cos(i)] * ...
    [cos(omega) sin(omega) 0; -sin(omega) cos(omega) 0; 0 0 1];

% geocentric R
R = rotation.' * R;

%% plotting
hold on

if name == "Calculated position"
    plotstyle = 'b--';
    dotcolor = "green";
else
    dotcolor = "red";
    plotstyle = 'r-';
end


if plotAdditional
    % plotting the orbit

    plot3(R(1,:), R(2,:), R(3,:), plotstyle, 'DisplayName', strcat("Orbit ", name), 'LineWidth', 1);



    % % Apse line
    % apsePoints = [ [rp*cos(0); 0; 0], [0; 0; 0], [ra*cos(pi); 0; 0] ];
    % apsePoints = rotation.' * apsePoints;
    % plot3(apsePoints(1,:), apsePoints(2,:), apsePoints(3,:), 'o--k', 'MarkerFaceColor', 'black', ...
    %     'DisplayName', 'Apse line')

end

% Initial state
plot3(r(1), r(2), r(3), 'o', 'MarkerFaceColor', dotcolor, 'DisplayName', name)
% Axes
axis equal
xlabel('x [km]')
ylabel('y [km]')
zlabel('z [km]')

% Initial state geo


end