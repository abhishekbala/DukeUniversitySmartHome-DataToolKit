%concatanateFeatures

ON = prtDataSetClass;
load('disaggID.mat');
ON.targets = ONdcsID';
ON.data = ONdcsID';

OFF = prtDataSetClass;
OFF.targets = OFFdcsID';
OFF.data = OFFdcsID';