# -*- coding: utf-8 -*-
"""
Created on Sun Jan 25 17:09:49 2015

@author: Raghav Saboo
"""
import os
import time
import csv
import pymysql.cursors

# Infinite loop.
while 1:
    # print command just for visualising script run.    
    print "New Data to be loaded"
    # Get the current SYSTEM unix time. !!MAKE SURE TO CALIBRATE CLOCK!!  
    # There is a 51 second lag in the MySQL data.
    unixTime = str(int(time.time())-352) 
    # Setup connection to MySQL database
    connection=pymysql.connect(
        host='67.159.81.86',user='student',
        passwd='bassconnex',db='energydata',
        cursorclass = pymysql.cursors.SSCursor)
    cursor=connection.cursor()
    # Query the MySQL database.
    # 1 second worth of data from 5 minutes prior from current time is loaded.
    cursor.execute("SELECT smarthome.timestamp,	smarthome.b7139_01_r_01_phase1 \
    , smarthome.b7139_01_r_02_phase2, smarthome.b7139_01_r_03_solar1 \
    , smarthome.b7139_01_r_04_solar2	FROM energydata.smarthome \
    WHERE smarthome.timestamp =" +unixTime+ " \
    ORDER BY smarthome.timestamp ASC")
    # Store the 1 second data locally.
    shData = [row for row in cursor]
    # Store in csv (append).
    with open("shData.csv",'a') as csvOut:
        csvwriter = csv.writer(csvOut,delimiter=',',dialect='excel')
        csvwriter.writerows(shData)
    # Lock file to Python
    # Check the length of the CSV file.
    with open("shData.csv",'rb') as csvFile:
        reader = csv.reader(csvFile)
        rowCount = sum(1 for row in reader)
    # If CSV file is unnecessarily long, truncate.
    if rowCount > 2100:
        print "Length >2000"
        with open("shData.csv", 'rb') as csvFileBig:
            with open("shData1.csv", 'wb') as csvFile1:
                for _ in range(200):
                    csvFileBig.next();
                for line in csvFileBig:
                    csvFile1.write(line)
        os.remove("shData.csv")
        os.rename("shData1.csv","shData.csv")
    # Pause for 1 second and then repeat. Could use more sophisticated wait
        # like in wuTemp if needed.
    time.sleep(1)

cursor.close()
connection.close()
