function anomalyDetection
    disaggregatedDataAllAppliances = csvread('EventDetection\DisaggregatedPower.csv');
    dataLength = length(disaggregatedDataAllAppliances);
    
    Refridge_BlockSize = 60*60*10 + 60 * 10;
    disaggregatedDataRefridge = disaggregatedDataAllAppliances(dataLength-Refridge_BlockSize+1:dataLength, 2);
    
    HotBox_BlockSize = 60*60*12 + 60 * 10;
    disaggregatedDataHotBox = disaggregatedDataAllAppliances(dataLength-HotBox_BlockSize+1:dataLength, 3);
    
    HVAC_BlockSize = 60*60*12 + 60 * 10;
    disaggregatedDataHVAC = disaggregatedDataAllAppliances(dataLength-HVAC_BlockSize+1:dataLength, 4)
    + disaggregatedDataAllAppliances(dataLength-HVAC_BlockSize+1:dataLength, 5);
    
    netRef = load('netRef');
    netHotBox = load('netHotbox');
    netHVAC = load('netHVAC');
    
    refAnomalies = InputDatav2(netRef, preProcessData(disaggregatedDataRefridge));
    hotBoxAnomalies = InputDatav2(netHotBox, preProcessData(disaggregatedDataHotBox));
    hvacAnomalies = InputDatav2(netHVAC, preProcessData(disaggregatedDataHVAC));
end