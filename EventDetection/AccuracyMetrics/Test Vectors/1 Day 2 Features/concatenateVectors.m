%concatanateVectors

ON = prtDataSetClass;
load('disaggID.mat');
ON.targets = ONdcsID';
ON.data = ONdcsID';

OFF = prtDataSetClass;
OFF.targets = OFFdcsID';
OFF.data = OFFdcsID';


%% Truth Values Concatenation
dummy = prtDataSetClass;
truthON = prtDataSetClass;
load('h10p.mat')
load('refrigerator.mat')
load('hotbox.mat')
load('HVAC1.mat')
load('HVAC2.mat')
refOnTruth= [refOnTruth*1]';
h10onTruth = [h10onTruth*2]';
hotOnTruth = [hotOnTruth*3]';
HVAC1onTruth = [HVAC1onTruth*4]';
HVAC2onTruth = [HVAC2onTruth*5]';

a = find(refOnTruth == 0); b = find(h10onTruth == 0); c = find(hotOnTruth == 0);
d = find(HVAC1onTruth == 0); e = find(HVAC2onTruth == 0);

for i = 1:length(refOnTruth)
    if isempty(find(a == i));
        

onTruths = h10onTruth + refOnTruth + hotOnTruth + HVAC1onTruth + HVAC2onTruth;
dummy.data = onTruths;
dummy.targets = dummy.data;
truthON = catObservations(truthON, dummy);

dummy = prtDataSetClass;
truthOFF = prtDataSetClass;
load('h10p.mat')
load('refrigerator.mat')
load('hotbox.mat')
load('HVAC1.mat')
load('HVAC2.mat')
refOffTruth= [refOffTruth*1]';
h10offTruth = [h10offTruth*2]';
hotOffTruth = [hotOffTruth*3]';
HVAC1offTruth = [HVAC1offTruth*4]';
HVAC2offTruth = [HVAC2offTruth*5]';
offTruths = h10offTruth + refOffTruth + hotOffTruth + HVAC1offTruth + HVAC2offTruth;
dummy.data = offTruths;
dummy.targets = dummy.data;
truthOFF = catObservations(truthOFF, dummy);