
function [fixedNaNs, binaryMissing] = fixMissingValues(dataAsCSV)


%data = importdata(dataAsCSV);
data = dataAsCSV;
timeStart = data(1,1);
timeEnd = data(end, 1);
correctSize = timeEnd - timeStart + 1;

fixTime =  zeros(correctSize, length(data(1,:) ) );

for k = 1:length(data(:,1))
    fixTime(data(k,1)-timeStart+1,:) =  data(k,:);
end

for k = 1:length(fixTime(:,1))
    if fixTime(k,1) == 0
        fixTime(k,2:end) = fixTime(k-1,2:end);
        fixTime(k,1) = fixTime(k-1,1)+1;
    end
    
end

fixed = fixTime;



%% MUST NOT HAVE NAN IN FIRST MINUTE
rowHasNaN = zeros(length(fixed(:,1)),1);
binaryMissing = zeros(length(fixed(:,1)), length(fixed(1,:)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for x = 1:60
    for y = 2:length(fixed(1,:))
        if isnan(fixed(x,y))
            if (x>1) && ~isnan(fixed(x-1,y))
                fixed(x,y) = fixed(x-1, y);
            elseif x==1
                fixed(x,y) = 0;
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k = 1:length(fixed(:,1))
    binaryMissing(k, 1) = fixed(k,1);
    
    for l = 2:length(fixed(1,:))
        
        if isnan(fixed(k,l))
            binaryMissing(k,l) = 1;
            rowHasNaN(k,1) = 1;
            if(k < 3600) && ~isnan(fixed(k-60, l))
                fixed(k,l) = fixed(k-60, l);
                
            elseif (k<86400) && ~isnan(fixed(k-3600, l))
                fixed(k,l) = fixed(k-3600, l);
                % if less than a days worth of data, take the previous
                % hour
            elseif (k>86400) && ~isnan(fixed(k-86400, l))
                %if more than a days woth but less than a weeks, take from
                %the next ay
                fixed(k,l) = fixed(k-86400, l);
                
            elseif (k>7*86400) && ~isnan(fixed(k-7*86400, l))
                fixed(k,l) = fixed(k-7*86400,l);
                %%assuming at least 2 weeks worth of data present
                
            end
            
        end
        
    end
    
end







fixedNaNs = fixed;



end
%% FIXED IS WITH NANS FILLED IN
%% REMOVED IS WITH NaNs REMOVED






