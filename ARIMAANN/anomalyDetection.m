function [refAnomalies, hotBoxAnomalies, hvacAnomalies] = anomalyDetection
    disaggregatedDataAllAppliances = csvread('..\EventDetection\DisaggregatedPower.csv');
    
    Refridge_BlockSize = 60*60*10 + 60 * 10;
    disaggregatedDataRefridge = disaggregatedDataAllAppliances(end-Refridge_BlockSize+1:dataLength, 2);
    
    HotBox_BlockSize = 60*60*12 + 60 * 10;
    disaggregatedDataHotBox = disaggregatedDataAllAppliances(end-HotBox_BlockSize+1:dataLength, 3);
    
    HVAC_BlockSize = 60*60*12 + 60 * 10;
    disaggregatedDataHVAC = disaggregatedDataAllAppliances(end-HVAC_BlockSize+1:dataLength, 4) ...
    + disaggregatedDataAllAppliances(dataLength-HVAC_BlockSize+1:dataLength, 5);
    
    netRef = load('netRef');
    netHotBox = load('netHotbox');
    netHVAC = load('netHVAC');
    
    refAnomalies = InputDatav2(netRef, preProcessData(disaggregatedDataRefridge));
    hotBoxAnomalies = InputDatav2(netHotBox, preProcessData(disaggregatedDataHotBox));
    hvacAnomalies = InputDatav2(netHVAC, preProcessData(disaggregatedDataHVAC));
    
    anomalyMatrix = [refAnomalies(:,1) refAnomalies(:,2) refAnomalies(:,3) ... 
        refAnomalies(:,4) hotBoxAnomalies(:,2) hotBoxAnomalies(:,3) hotBoxAnomalies(:,4) ...
        hvacAnomalies(:,2) hvacAnomalies(:,3) hvacAnomalies(:,4)];
    
    save('anomalyMatrix');
end