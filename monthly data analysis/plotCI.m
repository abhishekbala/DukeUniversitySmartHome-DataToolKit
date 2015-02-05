function plotCI(data, m1, s1, ci1, m2, s2, ci2)
%% Get number of days and number of hours
  numDays  = size(data, 1);
  numHours = size(data, 2);

%% Create Figure
  figure;
  
  % Create subplot for visualizing daily profile
  subplot(1,2,1);
  plot(data', 'Color', [.8 .8 .8]);
  %patch([1:numHours,numHours:-1:1],[ci1(1,:), ci1(2,end:-1:1)], [.8 .8 .8])
  line(1:numHours, m1, 'Linewidth', 2, 'Color', 'r');
  grid on; 
  xlim([1 numHours]);
  xlabel('hours');
  ylabel('system load (W)');
  title('Daily Profile (mean & CI)');

  % Create subplot for visualizing month profile
  subplot(1,2,2);
  plot(data, 'Color', [.8 .8 .8]);
  %patch([1:numDays,numDays:-1:1],[ci2(1,:), ci2(2,end:-1:1)], [.8 .8 .8])
  line(1:numDays, m2, 'Linewidth', 2, 'Color', 'r');
  grid on;xlim([1 numDays]);
  xlabel('days');
  ylabel('system load (W)');
  title('Month Profile (mean & CI)');
