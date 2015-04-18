clear;
clc;

net = Train();

%This is what allows us to re-run with new input real-time data;
results = InputData(net);