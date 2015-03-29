function [onTimes, offTimes, eventTimes] = ApplianceDataLabelGenerator(data, time, parameters)
%% Parameters
% Output: onTimes => Array of time values for when events turn on.
%         offTimes => Array of time values for when events turn off.
%         eventTimes => Array of time values for all events.
%
% Data => inputted data
% Time => time values corresponding to data
% parameters => array of GLR parameters


[on off events] = GLR_EventDetection(data, parameters(1), parameters(2), parameters(3), parameters(4), parameters(5), parameters(6), parameters(7));

onIndices = find(on == 1);
offIndices = find(off == 1);
eventIndices = find(events == 1);

onTimes = time(onIndices);
offTimes = time(offIndices);
eventTimes = time(eventIndices);

end