# -*- coding: utf-8 -*-
"""
Created on Sun Jan 25 17:09:49 2015

@author: Raghav Saboo
"""
import os
import time
import csv
import pymysql.cursors

# The current or end time for the period data is required (UNIX time)
unixEndTime = 1429403762
# The number of seconds of data wanted
unixSeconds = 46800
# Calculates the start timestamp from which data to be retrieved
unixStartTime = unixEndTime - (1)*unixSeconds

# print command just for visualising script run.
# print "New Data to be loaded"
# Get the current SYSTEM unix time. !!MAKE SURE TO CALIBRATE CLOCK!!
# There is a 51 second lag in the MySQL data.
# Setup connection to MySQL database
connection=pymysql.connect(
	host='67.159.81.86',user='student',
	passwd='bassconnex',db='energydata',
	cursorclass = pymysql.cursors.SSCursor)
cursor=connection.cursor()
# Query the MySQL database.
# Data is loaded based on the timestamps provided above
cursor.execute("SELECT smarthome.timestamp,	smarthome.b7139_01_r_01_phase1 \
, smarthome.b7139_01_r_02_phase2, smarthome.b7139_01_r_03_solar1, smarthome.b7139_01_r_04_solar2 \
, smarthome.b7139_05_r_01_ahu1, smarthome.b7139_05_r_03_ahu2, smarthome.b7139_05_r_05_cu1, smarthome.b7139_05_r_07_cu2 \
, smarthome.b7139_05_r_09_airrecunit, smarthome.b7139_06_r_02_erv \
, smarthome.b7139_06_r_03_h10p, smarthome.b7139_04_r_06_hotbox, smarthome.b7139_03_r_01_refrig \
FROM energydata.smarthome \
WHERE smarthome.timestamp >=" +str(unixStartTime)+ " \
AND smarthome.timestamp <=" + str(unixEndTime) + " \
ORDER BY smarthome.timestamp ASC")

# Store the data locally
shData = [row for row in cursor]
# Store in csv (change the name as required in "")
with open("13Hours.csv",'wb') as csvOut:
	csvwriter = csv.writer(csvOut,delimiter=',',dialect='excel')
	csvwriter.writerows(shData)

cursor.close()
connection.close()
