function DisaggregationOutput2()
%DISAGGREGATIONOUTPUT2 Summary of this function goes here
%   Detailed explanation goes here

if(~exist('DisaggregatedPower.csv', 'file'))
    %% Make Initial CSV File:
    csvwrite('DisaggregatedPower.csv', []);
    
    %% Get the first time vector
    firstTimeData = importdata('eventData.csv');
    [numRows, ~] = size(firstTimeData);
    functionPointers = [0, 0, 0, 0];
    memoryOfPreviousPowerValues = [0, 0, 0, 0, 0];
    
    for i = 1:numRows
        % Assume that the functionPointers are [0, 0, 0, 0] ==> all appliances
        % are off:
        
        % This code updates functionPointers, showing whether each particular
        % appliance is on or off:
        %     if(i ~= 1)
        %         disaggregatedData = importdata('DisaggregatedPower.csv');
        %         [numRowsDisaggregatedPower, numColsDisaggregatedPower] = size(disaggregatedData);
        %         appliancePowers = disaggregatedData(numRowsDisaggregatedPower, :);
        %         appliancePowers = appliancePowers(2:length(appliancePowers));
        %         functionPointers(appliancePowers ~= 0) = 1;
        %     end
        
        currentTime = firstTimeData(i,1);
        disagMatrix = firstTimeData(i,:);
        applianceNumber = disagMatrix(2);
        
        if(applianceNumber == 0)
            memoryOfPreviousPowerValues(1) = currentTime;
            dlmwrite('DisaggregatedPower.csv', memoryOfPreviousPowerValues, '-append', 'newline', 'pc');
        else
            [appliancePowerOutputs, functionPointers] = DisaggregationOutput(currentTime, disagMatrix, functionPointers);
            
            memoryOfPreviousPowerValues(applianceNumber+ 1) = appliancePowerOutputs(applianceNumber+1);
            memoryOfPreviousPowerValues(1) = appliancePowerOutputs(1);
            
            %% CSV Write:
            dlmwrite('DisaggregatedPower.csv', memoryOfPreviousPowerValues, '-append', 'newline', 'pc');
        end
    end
    
    %% Continuous Stream:
    %     disaggregatedData = importdata('DisaggregatedPower.csv');
    %     [numRowsDisaggregatedPower, ~] = size(disaggregatedData);
    %     appliancePowers = disaggregatedData(numRowsDisaggregatedPower, :);
    %     appliancePowers = appliancePowers(2:length(appliancePowers));
    %     functionPointers(appliancePowers ~= 0) = 1;
    %     pause(1)
    
    % memoryOfPreviousPowerValues = importData('DisaggregatedPower.csv');
    % [rowsDisaggregatedPower, ~] = size(memoryOfPreviousPowerValues);
    % memoryOfPreviousPowerValues = memoryOfPreviousPowerValues(numRows, :);
    
    while(1)
        liveData = importdata('eventData.csv');
        [numRowsNew, ~] = size(liveData);
        if numRowsNew > numRows + 1
            numRows = numRows + 1;
            currentTime = liveData(numRows,1);
            disagMatrix = liveData(numRows,:);
            applianceNumber = disagMatrix(2);
            
            if(applianceNumber == 0)
                memoryOfPreviousPowerValues(1) = currentTime;
                dlmwrite('DisaggregatedPower.csv', memoryOfPreviousPowerValues, '-append', 'newline', 'pc');
            else
                [appliancePowerOutputs, functionPointers] = DisaggregationOutput(currentTime, disagMatrix, functionPointers);
                
                memoryOfPreviousPowerValues(applianceNumber+ 1) = appliancePowerOutputs(applianceNumber+1);
                memoryOfPreviousPowerValues(1) = appliancePowerOutputs(1);
                
                dlmwrite('DisaggregatedPower.csv', memoryOfPreviousPowerValues, '-append', 'newline', 'pc');
            end
        end
        %% CSV Write:
        pause(1)
    end
else
    
    memoryOfPreviousPowerValues = importData('DisaggregatedPower.csv');
    [rowsDisaggregatedPower, ~] = size(memoryOfPreviousPowerValues);
    memoryOfPreviousPowerValues = memoryOfPreviousPowerValues(rowsDisaggregatedPower, :);
    numRows = rowsDisaggregatedPower;
    
    while(1)
        liveData = importdata('eventData.csv');
        [numRowsNew, ~] = size(liveData);
        if numRowsNew > numRows + 1
            numRows = numRows + 1;
            currentTime = liveData(numRows,1);
            disagMatrix = liveData(numRows,:);
            applianceNumber = disagMatrix(2);
            
            if(applianceNumber == 0)
                memoryOfPreviousPowerValues(1) = currentTime;
                dlmwrite('DisaggregatedPower.csv', memoryOfPreviousPowerValues, '-append', 'newline', 'pc');
            else
                [appliancePowerOutputs, functionPointers] = DisaggregationOutput(currentTime, disagMatrix, functionPointers);
                
                memoryOfPreviousPowerValues(applianceNumber+ 1) = appliancePowerOutputs(applianceNumber+1);
                memoryOfPreviousPowerValues(1) = appliancePowerOutputs(1);
                
                dlmwrite('DisaggregatedPower.csv', memoryOfPreviousPowerValues, '-append', 'newline', 'pc');
            end
        end
        %% CSV Write:
        pause(1)
    end
end

end
