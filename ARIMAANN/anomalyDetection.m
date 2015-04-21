function [refAnomalies, hotBoxAnomalies, hvacAnomalies] = anomalyDetection
    disaggregatedDataAllAppliances = csvread('..\EventDetection\DisaggregatedPower.csv');
    
    Refridge_BlockSize = 60*60*10 + 60 * 10;
    disaggregatedDataRefridge = disaggregatedDataAllAppliances(end-Refridge_BlockSize+1:end, [1 2]);
    
    HotBox_BlockSize = 60*60*12 + 60 * 10;
    disaggregatedDataHotBox = disaggregatedDataAllAppliances(end-HotBox_BlockSize+1:end, [1 3]);
    
    HVAC_BlockSize = 60*60*10 + 60 * 10;
    HVACSumData = disaggregatedDataAllAppliances(end-HVAC_BlockSize+1:end, 4) ...
        + disaggregatedDataAllAppliances(end-HVAC_BlockSize+1:end, 5);
    disaggregatedDataHVAC = [disaggregatedDataAllAppliances(end-HVAC_BlockSize+1:end, 1) HVACSumData];
    
    load('netRef');
    load('netHotbox');
    load('netHVACsum');
    
    refAnomalies = predictionFromRecentData(netRef, preProcessData(disaggregatedDataRefridge));
    hotBoxAnomalies = predictionFromRecentData(netHotBox, preProcessData(disaggregatedDataHotBox));
    hvacAnomalies = predictionFromRecentData(netHVACsum, preProcessData(disaggregatedDataHVAC));
    
    anomalyMatrix = [refAnomalies(:,1) refAnomalies(:,2) refAnomalies(:,3) ... 
        refAnomalies(:,4) hotBoxAnomalies(:,2) hotBoxAnomalies(:,3) hotBoxAnomalies(:,4) ...
        hvacAnomalies(:,2) hvacAnomalies(:,3) hvacAnomalies(:,4)];
    
    dlmwrite('anomalyMatrix.csv',anomalyMatrix,'precision',11);
end