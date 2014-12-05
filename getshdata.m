function shData = getshdata(conn, mySQLquery)

curs = exec(conn,mySQLquery);

%Fetch data based on cursor used above
curs = fetch(curs,200);

%Store data locally on Matlab
shData = curs.Data;

%Close cursor
close(curs);

%Close database connection.
%close(conn);

%Clear variables
clear conn curs

end