% Anomaly Detection Timer
% Sets up a timer object to run the anomalyDetection function
% every 10 minutes

t = timer('TimerFcn', 'anomalyDetection', 'Period', 600, 'TasksToExecute', 99999, ...
    'ExecutionMode', 'fixedRate');
start(t);