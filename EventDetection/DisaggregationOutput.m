function [ApplianceTimeSeries] = DisaggregationOutput(timeVector, DisagMatrix)
%DISAGGREGATIONOUTPUT This function outputs time series values
%corresponding to each appliance's on vs. off state
%   Input: - Time vector (N x 1) of UNIX time stamps
%          - (#Events x 4) Matrix consisting of:
%               Col 1: Time stamps of each event turning on or off
%               Col 2: Appliance ID @ corresponding time stamp
%               Col 3: Change in power value @ corresponding time stamp
%               Col 4: Event Status (on/off) @ corresponding time stamp
%
%   Output: - (N x #Appliances) Matrix
%               jth col corresponds to jth appliance with the ith element
%               in the column corresponding to the power output of the
%               specific appliance at the particular UNIX time stamp

%% Separation of time stamps for each appliance
numberAppliances = 4; % For additional appliances, change this number

% Reformating Disaggregation Matrix into individual Vectors
eventTimeStamps = DisagMatrix(:,1);
applianceIDs = DisagMatrix(:,2);
deltaPowerValues = DisagMatrix(:,3);
eventStatusValues = DisagMatrix(:,4);

% Finding number of events for each appliance
[numberFridgeEvents, fridgeTimes] = NumberApplianceEvents(1, applianceIDs);
[numberHotBoxEvents, hotBoxTimes] = NumberApplianceEvents(2, applianceIDs);
[numberHVACMode1Events, HVACMode1Times] = NumberApplianceEvents(3, applianceIDs);
[numberHVACMode2Events, HVACMode2Times] = NumberApplianceEvents(4, applianceIDs);

% Create corresponding matrices for each appliance
FridgeMatrix = BuildMatrix(1, numberFridgeEvents, fridgeTimes, eventTimeStamps, deltaPowerValues, eventStatusValues);
HotBoxMatrix = BuildMatrix(2, numberHotBoxEvents, hotBoxTimes, eventTimeStamps, deltaPowerValues, eventStatusValues);
HVACMode1Events = BuildMatrix(3, numberHVACMode1Events, HVACMode1Times, eventTimeStamps, deltaPowerValues, eventStatusValues);
HVACMode2Events = BuildMatrix(4, numberHVACMode2Events, HVACMode2Times, eventTimeStamps, deltaPowerValues, eventStatusValues);
end

function TimeSeriesCreate(ApplianceMatrix)
%TIMESERIESCREATE This function outputs all the time series for a specific
%appliance that are relevant
onTimes = find(ApplianceMatrix(:,4) == 1);
offTimes = find(ApplianceMatrix(:,4) == 0);

for(i = 1:length(onTimes))
end

function [numberEvents, eventTimes] = NumberApplianceEvents(IDNumber, ApplianceIDVector)
numberEvents = length(find(ApplianceIDVector == IDNumber));
eventTimes = find(ApplianceIDVector == IDNumber);
end

function ApplianceMatrix = BuildMatrix(applianceNumber, numberApplianceEvents, applianceTimes, eventTimeStamps, deltaPowerValues, eventStatusValues)
ApplianceMatrix = zeros(numberApplianceEvents, 4);
ApplianceMatrix(:,1) = eventTimeStamps(applianceTimes);
ApplianceMatrix(:,2) = applianceNumber.*ones(numberApplianceEvents, 1);
ApplianceMatrix(:,3) = deltaPowerValues(applianceTimes);
ApplianceMatrix(:,4) = eventStatusValues(applianceTimes);
end