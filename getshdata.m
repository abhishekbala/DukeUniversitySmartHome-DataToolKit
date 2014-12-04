%The data format preferences.
setdbprefs('DataReturnFormat', 'numeric');
setdbprefs('NullNumberRead', 'NaN');
setdbprefs('NullStringRead', 'null');


%ODBC connection to database.
conn = database('Smart Home', 'student', '');
ping(conn)

%Set up cursor to read data using MySQL query
% ' ,	smart_home.b7139_01_r_02_phase2'...
%    ' ,	smart_home.b7139_01_r_03_solar1'...
%    ' ,	smart_home.b7139_01_r_04_solar2'...
%    ' ,	smart_home.b7139_03_r_01_refrig'...
%    ' ,	smart_home.b7139_06_r_01_irrigation'...

mySQLquery = ['SELECT 	smart_home.timestamp'...
    ' ,	smart_home.b7139_01_r_01_phase1'... 
    ' FROM 	energydata.smart_home '...
    ' WHERE 	smart_home.timestamp >= 1417735228'...
    ' ORDER BY 	smart_home.timestamp DESC'];
tic;
curs = exec(conn,mySQLquery);
t = toc;
%Fetch data based on cursor used above
curs = fetch(curs,200);

%Store data locally on Matlab
shData1 = curs.Data;

%Close cursor
close(curs);

%Close database connection.
% close(conn);

%Clear variables
clear conn curs