function [myOutput, pointers] = DisaggregationOutput(timeVector, DisagMatrix, functionPointers)
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
%           - pointers describes 1 or 0 representing on or off states for
%               each appliance

% % % % % % % % %% Determine if First Run or not:
% % % % % % % % 
% % % % % % % % 
% % % % % % % %     %% Separation of time stamps for each appliance
% % % % % % % %     numberAppliances = 4; % For additional appliances, change this number
% % % % % % % %     
% % % % % % % %     % Reformating Disaggregation Matrix into individual Vectors
% % % % % % % %     eventTimeStamps = DisagMatrix(:,1);
% % % % % % % %     applianceIDs = DisagMatrix(:,2);
% % % % % % % %     deltaPowerValues = DisagMatrix(:,3);
% % % % % % % %     eventStatusValues = DisagMatrix(:,4);
% % % % % % % %     
% % % % % % % %     % Finding number of events for each appliance
% % % % % % % %     [numberFridgeEvents, fridgeTimes] = NumberApplianceEvents(1, applianceIDs);
% % % % % % % %     [numberHotBoxEvents, hotBoxTimes] = NumberApplianceEvents(2, applianceIDs);
% % % % % % % %     [numberHVACMode1Events, HVACMode1Times] = NumberApplianceEvents(3, applianceIDs);
% % % % % % % %     [numberHVACMode2Events, HVACMode2Times] = NumberApplianceEvents(4, applianceIDs);
% % % % % % % %     
% % % % % % % %     % Create corresponding matrices for each appliance
% % % % % % % %     FridgeMatrix = BuildMatrix(1, numberFridgeEvents, fridgeTimes, eventTimeStamps, deltaPowerValues, eventStatusValues);
% % % % % % % %     HotBoxMatrix = BuildMatrix(2, numberHotBoxEvents, hotBoxTimes, eventTimeStamps, deltaPowerValues, eventStatusValues);
% % % % % % % %     HVACMode1Events = BuildMatrix(3, numberHVACMode1Events, HVACMode1Times, eventTimeStamps, deltaPowerValues, eventStatusValues);
% % % % % % % %     HVACMode2Events = BuildMatrix(4, numberHVACMode2Events, HVACMode2Times, eventTimeStamps, deltaPowerValues, eventStatusValues);
% % % % % % % %     
% % % % % % % %     % Create Output matrix
% % % % % % % %     pointers = zeros(1, numberAppliances);
% % % % % % % %     myOutput = zeros(length(timeVector), numberAppliances + 1);
% % % % % % % %     myOutput(:,1) = timeVector;
% % % % % % % %     [myOutput(:,2), pointers(1)] = TimeSeriesCreate(FridgeMatrix, 500, timeVector, functionPointers(1));
% % % % % % % %     [myOutput(:,3), pointers(2)] = TimeSeriesCreate(HotBoxMatrix, 500, timeVector, functionPointers(2));
% % % % % % % %     [myOutput(:,4), pointers(3)] = TimeSeriesCreate(HVACMode1Events, 500, timeVector, functionPointers(3));
% % % % % % % %     [myOutput(:,5), pointers(4)] = TimeSeriesCreate(HVACMode2Events, 500, timeVector, functionPointers(4));
% % % % % % % %     currRowNumber = length(timeVector);
    
% % % % % % % %     %% NEED TO DO CSVWRITE!!!!
% % % % % % % %     
% % % % % % % %     csvwrite('DisaggregatedPower.csv', myOutput);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Create OUTPUT ROW!!!
    % currRowNumber = rowNumber + 1; % Update the row count to the current row
    %[matxSize, ~] = size(DisagMatrix); % Find the length of the matrix (should be 1)
    numberAppliances = 4; 
    
    ApplianceVector = DisagMatrix; %Find the last line of the matrix
    %ApplianceVector = ApplianceVector';
    
    pointers = zeros(1, numberAppliances);
    myOutput = zeros(1, numberAppliances + 1);
    myOutput(1) = timeVector(numel(timeVector)); % Most recent time --> a single time point
    
    if(ApplianceVector(2) == 1)
        [myOutput(2), pointers(1)] = TimeSeriesCreate2(ApplianceVector, 500, functionPointers(1));
    elseif(ApplianceVector(2) == 2)
        [myOutput(3), pointers(2)] = TimeSeriesCreate2(ApplianceVector, 500, functionPointers(2));
    elseif(ApplianceVector(2) == 3)
        [myOutput(4), pointers(3)] = TimeSeriesCreate2(ApplianceVector, 500, functionPointers(3));
    elseif(ApplianceVector(2) == 4)
        [myOutput(5), pointers(4)] = TimeSeriesCreate2(ApplianceVector, 500, functionPointers(4));
    end
    
    
    %% NEED TO DO CSVWRITE
% % % % %     dlmwrite('DisaggregatedPower.csv', myOuput, '-append', 'newline', 'pc');

end

function [ApplianceTimePoint, pointer] = TimeSeriesCreate2(ApplianceMatrix, avgOnPower, pointerStatus)
%[matxSize, ~] = size(ApplianceMatrix);

% This gives onOffStatus in the format with 1 --> on and 0 --> off 
onOffStatus = ApplianceMatrix(4);
pointer = pointerStatus;

% This section makes -1 --> off instead of 0.
if(onOffStatus == 0)
    onOffStatus = -1;
end

if(ApplianceMatrix(2) == 0) %If latest data point is ACTUALLY NOT AN EVENT 
    onOffStatus = 0;
end

if(pointerStatus == 0 && onOffStatus == 1) % PREVIOUS STATUS OF APPLIANCE IS OFF AND CURRENT STATUS SAYS APPLIANCE TURNS ON.
    ApplianceTimePoint = onOffStatus * avgOnPower; % Change the appliance power output to ON
    pointer = 1; % Pointer shows that appliance is in on state.
elseif(pointerStatus == 0 && onOffStatus == 0) % PREVIOUS STATUS OF APPLIANCE IS OFF AND CURRENT STATUS SAYS APPLIANCE STAYS IN ORIGINAL STATE
    ApplianceTimePoint = 0; % Change the appliance power output to ON
    pointer = 0; % Pointer shows that appliance is in off state.
elseif(pointerStatus == 0 && onOffStatus == -1) % PREVIOUS STATUS OF APPLIANCE IS OFF AND CURRENT STATUS SAYS APPLIANCE TURNS OFF
    ApplianceTimePoint = 0;
    pointer = 0; % Pointer shows that appliance is in off state.
elseif(pointerStatus == 1 && onOffStatus == 1) % PREVIOUS STATUS OF APPLIANCE IS ON AND CURRENT STATUS SAYS APPLIANCE TURNS ON
    ApplianceTimePoint = onOffStatus * avgOnPower; % Change the appliance power output to ON
    pointer = 1; % Pointer shows that appliance is in on state.
elseif(pointerStatus == 1 && onOffStatus == 0) % PREVIOUS STATUS OF APPLIANCE IS ON AND CURRENT STATUS SAYS APPLIANCE STAYS IN ORIGINAL STATE
    ApplianceTimePoint = 0; % Keep the appliance power output to ON.
    pointer = 1;
elseif(pointerStatus == 1 && onOffStatus == -1) % PREVIOUS STATUS OF APPLIANCE IS ON AND CURRENT STATUS SAYS APPLIANCE TURNS OFF
    ApplianceTimePoint = 0; % Change the appliance power output to OFF
    pointer = 0; % Pointer shows that appliance is in off state.
end

end

function [ApplianceTimeSeries, pointer] = TimeSeriesCreate(ApplianceMatrix, avgOnPower, myTimeVector, pointerStatus)
%TIMESERIESCREATE This function outputs all the time series for a specific
%appliance that is relevant
onTimes = find(ApplianceMatrix(:,4) == 1);
offTimes = find(ApplianceMatrix(:,4) == 0);

OnOffTimeStamps = ApplianceMatrix(:,1);

OnTimeStamps = OnOffTimeStamps(onTimes);
OffTimeStamps = OnOffTimeStamps(offTimes);


ApplianceTimeSeries = myTimeVector;
ApplianceTimeSeries(OnTimeStamps) = 1;
ApplianceTimeSeries(OffTimeStamps) = -1;

pointer = pointerStatus; % Describes if appliance is on atm

for(i = 1:length(ApplianceTimeSeries))
    if(pointer == 0 && ApplianceTimeSeries(i) == 1)
        ApplianceTimeSeries(i) = ApplianceTimeSeries(i) * avgOnPower;
        pointer = 1;
    elseif(pointer == 0 && ApplianceTimeSeries(i) == 0)
        continue;
    elseif(pointer == 0 && ApplianceTimeSeries(i) == -1)
        ApplianceTimeSeries(i) = 0;
    elseif(pointer == 1 && ApplianceTimeSeries(i) == 1)
        ApplianceTimeSeries(i) = ApplianceTimeSeries(i) * avgOnPower;
    elseif(pointer == 1 && ApplianceTimeSeries(i) == 0)
        ApplianceTimeSeries(i) = ApplianceTimeSeries(i) * avgOnPower;
    elseif(pointer == 1 && ApplianceTimeSeries(i) == -1)
        ApplianceTimeSeries(i) = 0;
        pointer = 0;
    end
end
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






% <<<<<<< HEAD
% % Create corresponding matrices for each appliance
% FridgeMatrix = BuildMatrix(1, numberFridgeEvents, fridgeTimes, eventTimeStamps, deltaPowerValues, eventStatusValues);
% HotBoxMatrix = BuildMatrix(2, numberHotBoxEvents, hotBoxTimes, eventTimeStamps, deltaPowerValues, eventStatusValues);
% HVACMode1Events = BuildMatrix(3, numberHVACMode1Events, HVACMode1Times, eventTimeStamps, deltaPowerValues, eventStatusValues);
% HVACMode2Events = BuildMatrix(4, numberHVACMode2Events, HVACMode2Times, eventTimeStamps, deltaPowerValues, eventStatusValues);
% =======

%>>>>>>> origin/master