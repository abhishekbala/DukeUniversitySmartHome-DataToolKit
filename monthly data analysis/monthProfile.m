function monthProfile(data)
  % Create axes
  axes1 = axes();
  % X Limits
  xlim([1 24]);
  % Y Limits
  yend = size(data,1);
  ylim([1 yend]);
  box('on');
  hold('all');

  % Create title
  title('System Load (W)');

  % Create contour
  contour(data,'LineColor','k','Fill','on','Parent',axes1);

  % Create imagesc
  imagesc(data)

  % Create xlabel
  xlabel('hours');

  % Create ylabel
  ylabel('days');

  % Create colorbar
  colorbar;

