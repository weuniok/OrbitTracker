mu = 3.986004418E14 /1000^3;

ISS = ISSClass();

ISS_OE = ISS.getOrbitalElements;
ISS_measure = ISS.getStateVector(0);

measuredOE = state2orbitalElements(ISS_measure(:,1), ISS_measure(:,2), mu);

error = ISS_OE - measuredOE;


plotFromOE(ISS_OE, mu, ISS_measure(:,1));
hold on
plotFromOE(measuredOE, mu, ISS_measure(:,1));
