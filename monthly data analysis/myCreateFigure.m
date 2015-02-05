function myCreateFigure(data1)
  % Create figure
  figure1 = figure('Units','Pixels','Position',[200, 200, 800, 400]);

  % Create axes
  axes1 = axes('Parent',figure1);
  % X Limits
  xlim([1 24]);
  % Y Limits
  ylim([1 31]);
  box('on');
  hold('all');

  % Create title
  title('System Load (W)');

  % Create contour
  contour(data1,'LineColor','k','Fill','on','Parent',axes1);

  % Create xlabel
  xlabel('hours');

  % Create ylabel
  ylabel('days');

  % Create colorbar
  colorbar;

