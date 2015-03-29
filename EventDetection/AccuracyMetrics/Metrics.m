function [ output_args ] = Metrics( classifiedData, testTruthData, uniqueClasses, classNames )
%METRICS Summary of this function goes here
%   Detailed explanation goes here
%   uniqueClasses <-- numeric i.e. 5
%   classNames <-- array (5x1) i.e. {'Class 1', 'Class 2'...}

% Load a binary truth dataset

prtScoreConfusionMatrix(classifiedData,testTruthData,uniqueClasses,classNames);
end

