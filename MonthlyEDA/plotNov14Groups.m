for i = 1:2014457
    group =  k6(i,1);
    switch group
        case 1
            subplot(6,1,1)
            plot(k6(i,2),k6(i,3))
            hold on
        case 2
            subplot(6,1,2)
            plot(k6(i,2),k6(i,3))
            hold on
        case 3
            subplot(6,1,3)
            plot(k6(i,2),k6(i,3))
            hold on
        case 4
            subplot(6,1,4)
            plot(k6(i,2),k6(i,3))
            hold on
        case 5
            subplot(6,1,5)
            plot(k6(i,2),k6(i,3))
            hold on
        case 6
            subplot(6,1,6)
            plot(k6(i,2),k6(i,3))
            hold on
    end
end

           
            
            