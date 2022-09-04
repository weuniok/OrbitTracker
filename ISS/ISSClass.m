classdef ISSClass < handle

    properties
        orbitalElements
        mu = 3.986004418E14 /1000^3;
    end
    
    methods
        function obj = ISSClass()
            secondLineTLE = [2 25544  51.6442 307.7584 0002851 188.8255 322.7546 15.50015618357355];
            obj.updateOrbitalElements(secondLineTLE);
        end

        function updateOrbitalElements(obj, secondLineTLE)
            deg = pi/180;

            inclination = secondLineTLE(3) * deg;
            RAofAscendingNode = secondLineTLE(4) * deg;
            eccentricity = secondLineTLE(5) * 10E-8;
            perigeeArgument = secondLineTLE(6) * deg;

            meanMotion = secondLineTLE(8) * 2*pi/24/60/60; % revolutions/day -> rad/s

            semiMajorAxis = (obj.mu / meanMotion^2)^(1/3);
            semiMinorAxis = semiMajorAxis * (1-eccentricity^2)^0.5;
            h = meanMotion * semiMajorAxis * semiMinorAxis;

            obj.orbitalElements = [h, inclination, RAofAscendingNode, eccentricity, perigeeArgument, 0];
        end

        function stateVector = getStateVector(obj, anomaly)
            obj.orbitalElements(6) = anomaly;
            [r,v] = orbitalElements2state(obj.orbitalElements, obj.mu);
            stateVector = [r,v];
            return
        end

        function orbitalElements = getOrbitalElements(obj)
            orbitalElements = obj.orbitalElements;
        end

    end
end

