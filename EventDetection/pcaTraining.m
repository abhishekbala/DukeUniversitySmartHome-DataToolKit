function pcaTraining(data, on, off)
%% Extract 61 points around each ON Event
onMatrix = zeros(length(n), 61);
offMatrix = zeros(length(n), 61);

%% Normalize on/off windows
for i = 1:length(on)
    onMean = mean(data(on(i)-30:on(i)+30));
    onStd = std(data(on(i)-30:on(i)+30));
    onMatrix(i, :) = (data(on(i)-30:on(i)+30) - onMean) / onStd;
end

for i = 1:length(off)
    offMean = mean(data(off(i)-30:off(i)+30));
    offStd = std(data(off(i)-30:off(i)+30));
    offMatrix(i, :) = (data(off(i)-30:off(i)+30) - offMean) / offStd;
end

%% PCA Training


%% PCA training to be run then
%pcaTraining(refrigerator,onRef,offRef)
onFeaturesMatrix = [];
offFeaturesMatrix = [];
onFeaturesMatrix = [onFeaturesMatrix; onMatrix];
offFeaturesMatrix = [offFeaturesMatrix; offMatrix];
[n,m] = size(onMatrix)
[p,q] = size(offMatrix)
onTargets = [];
offTargets = [];
onTargets = [onTargets; ones(n,1)];
offTargets = [offTargets; ones(n,1)];
%hotbox
onFeaturesMatrix = [onFeaturesMatrix; onMatrix];
offFeaturesMatrix = [offFeaturesMatrix; offMatrix];
onTargets = [onTargets; 2*ones(n,1)];
offTargets = [offTargets; 2*ones(n,1)];
%HVAC1
onFeaturesMatrix = [onFeaturesMatrix; onMatrix];
offFeaturesMatrix = [offFeaturesMatrix; offMatrix];
onTargets = [onTargets; 3*ones(n,1)];
offTargets = [offTargets; 3*ones(n,1)];
%HVAC2
onFeaturesMatrix = [onFeaturesMatrix; onMatrix];
offFeaturesMatrix = [offFeaturesMatrix; offMatrix];
onTargets = [onTargets; 4*ones(n,1)];
offTargets = [offTargets; 4*ones(n,1)];

onFeatureSet = prtDataSetClass;
offFeatureSet = prtDataSetClass;

onFeatureSet.data = onFeaturesMatrix;
onFeatureSet.targets = onTargets;

offFeatureSet.data = offFeaturesMatrix;
offFeatureSet.targets = offTargets;
end 