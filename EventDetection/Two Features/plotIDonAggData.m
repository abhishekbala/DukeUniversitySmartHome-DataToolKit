plot(agg(1600:2700))
hold on;
onEventsAgg(onEventsAgg == 0) = NaN;
plot(agg(1600:2700,:)'.*onEventsAgg(:,1600:2700),'ro');

labels = (ONdcsID(1600:2700));
labels(153)
labels(536)