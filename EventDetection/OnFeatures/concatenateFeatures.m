%concatanateFeatures

ON = prtDataSetClass;
load('FridgeOnFeatures.mat');
ON = catObservations(ON, onFeatureSet);
load('h10pOnFeatures.mat');
ON = catObservations(ON, onFeatureSet);
load('hotBoxOnFeatures.mat');
ON = catObservations(ON, onFeatureSet);
load('HVAC1OnFeatures.mat');
ON = catObservations(ON, onFeatureSet);
load('HVAC2OnFeatures.mat');
ON = catObservations(ON, onFeatureSet);

