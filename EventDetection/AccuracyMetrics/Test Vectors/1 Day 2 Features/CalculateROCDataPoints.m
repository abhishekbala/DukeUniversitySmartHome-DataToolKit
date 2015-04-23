% Compute ROC curve data points given test vectors

%% Load data
clear;
cls;
load('disaggID.mat');
load('h10p.mat');
load('hotbox.mat');
load('HVAC1.mat');
load('HVAC2.mat');
load('refrigerator.mat');

%% Compute TP and FP for each appliance
% IDs:
refID = 1;
h10pID = 2;
hotID = 3;
hvac1ID = 4;
hvac2ID = 5;

% Refrigerator On
refOnDcs = refOnTruth * refID;


% Refrigerator Off
refOffDcs = refOffTruth * refID;

%