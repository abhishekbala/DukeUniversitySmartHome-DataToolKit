function [time, refrigerator, h10p, hotbox, HVAC1, HVAC2] = extractSubMeteredData()
%% COMMENTS TO BE UPDATED

shMar2015 = importdata('shMar2015.csv');

time = shMar2015(:,1); refrigerator = shMar2015(:,14); h10p = shMar2015(:,12);
hotbox = shMar2015(:,13); HVAC1 = shMar2015(:,6) + shMar2015(:,8);
HVAC2 = shMar2015(:,7) + shMar2015(:,9);
