% Anomaly Detection Timer
% Sets up a timer object to run the anomalyDetection function
% every 10 minutes

t = timer('TimerFcn', 'anomalyDetection', 'Period', 600);
start(t);

cleanerUpper = onCleanup(@()stop(t));