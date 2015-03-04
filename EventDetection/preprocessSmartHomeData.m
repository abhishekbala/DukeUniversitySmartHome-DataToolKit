% Preprocess all data

load('smartHomeData.mat');

for i=2:size(smartHomeData,2)
    for j=1:size(smartHomeData,1)
        if smartHomeData(j,i) > 1e6
            smartHomeData(j,i)
            smartHomeData(j,i) = smartHomeData(j-1,i);
        end
    end
end

save('smartHomeData');