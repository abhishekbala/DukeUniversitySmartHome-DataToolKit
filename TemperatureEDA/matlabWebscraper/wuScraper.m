%% Get the current temperature
% 
% The phrase "Total Widgets" makes a good target string.

the_url = 'http://www.wunderground.com/';
current_temp = urlfilter(the_url,'Duke Forest');
disp(current_temp)

clear
the_url = 'http://www.weather.com/weather/today/l/USNC0192:1:US';
current_temp = urlfilter(the_url,'Weather');
disp(current_temp)

clear
the_url = 'http://www.wral.com/weather_current_conditions/13264720/'
current_temp = urlfilter(the_url,'Dew Point');

clear
xml = urlread('http://forecast.weather.gov/MapClick.php?textField1=35.99402554900047&textField2=-78.89861818799966#.VNo2-vnF98G');
