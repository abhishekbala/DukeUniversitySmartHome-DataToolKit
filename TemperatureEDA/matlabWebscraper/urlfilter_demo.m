%% Examples from the Trendy Tutorial
% This code references the tutorial HTML file found
% <http://www.mathworks.com/matlabcentral/trendy/Tutorial/trendco.html
% here>.

% Copyright 2012-2013 The MathWorks, Inc.

%% Task 1: How many widgets were produced?
% 
% The phrase "Total Widgets" makes a good target string.

the_url = 'http://www.mathworks.com/matlabcentral/trendy/Tutorial/trendco.html';
total_widgets = urlfilter(the_url,'Total Widgets');
disp(total_widgets)

%%
% Even though the phrase "Total Widgets" doesn't sit next to the number,
% it's still a good specific marker for the number that we're interested
% in. URLFILTER starts there and begins looking for numbers. The first one
% it finds is 437, at which point it stops.

%% Task 2: What is today's relative humidity?
% In this case "humidity" is a good target, but the number immediately
% following the target (77) isn't the one we're interested in. The
% workaround is to collect two numbers and only use the second one. This
% involves passing a third argument to URLFILTER.

the_url = 'http://www.mathworks.com/matlabcentral/trendy/Tutorial/trendco.html';
vals = urlfilter(the_url,'humidity',2);
humidity = vals(2);
disp(humidity)

%% Task 3: How much did TrendCo make on Tetrascopes today?
% In this case we want to collect two numbers (sales from East and West)
% and add them together.

the_url = 'http://www.mathworks.com/matlabcentral/trendy/Tutorial/trendco.html';
vals = urlfilter(the_url,'Tetrascope',3);
east_sales = vals(2);
west_sales = vals(3);
total_sales = east_sales + west_sales;
disp(total_sales)

%% Task 4: What is the ID number for Grid Brackets?
% This looks like an easy question, but the obvious solution doesn't work:

the_url = 'http://www.mathworks.com/matlabcentral/trendy/Tutorial/trendco.html';
sales = urlfilter(the_url,'Grid Bracket');
disp(sales)      % fails!

%%
% Why isn't it working? It's only when you view the underlying HTML source
% that you see there is a non-breaking space between "Grid" and "Bracket".
% So instead of "Grid Bracket", the target search term should be
% "Grid&nbsp;Bracket".

sales = urlfilter('http://www.mathworks.com/matlabcentral/trendy/Tutorial/trendco.html','Grid&nbsp;Bracket');
disp(sales)

%%
% Now the code works fine. Remember that sometimes you have to examine the
% source HTML before you can be confident that your target string is
% accurate and unique.