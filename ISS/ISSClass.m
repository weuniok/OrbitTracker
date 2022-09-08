classdef ISSClass < handle

    properties
        orbitalElements
        state
        epochTLE
        mu = 3.986004418E14 /1000^3;
    end
    
    methods
        function obj = ISSClass()
            TLE_firstLine = {1 '25544U' '98067A'   22250.60379146  .00007699  00000-0  14232-3 0  9993};
            TLE_secondLine = [2 25544  51.6443 288.2831 0002670 203.2971 293.6689 15.50084907357968];
            obj.updateOrbitalElements(TLE_secondLine );
            obj.state = obj.getStateVector(obj.orbitalElements(6));
            obj.epochTLE = obj.readEpoch(convertStringsToChars(string(TLE_firstLine{4})));
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

        function epochTLE = readEpoch(obj, epoch)
            day = epoch(1:5);
            epochTLE = ...
                datetime(day, 'InputFormat', 'yyDDD') + ...
                days(mod(str2double(epoch), 1));
        end

        function plot(obj)
            plotFromOE(obj.orbitalElements, obj.mu, obj.state(:,1));
        end

        %% set
        function setAnomaly(obj, anomaly)
            obj.orbitalElements(6) = anomaly;
            obj.state = obj.getStateVector(obj.orbitalElements(6));
        end
        %% get
        function stateVector = getStateVector(obj, anomaly)
            obj.orbitalElements(6) = anomaly;
            [r,v] = orbitalElements2state(obj.orbitalElements, obj.mu);
            stateVector = [r,v];
            return
        end

        function orbitalElements = getOrbitalElements(obj)
            orbitalElements = obj.orbitalElements;
        end

        function mu = getMu(obj)
            mu = obj.mu;
        end

    end
end

