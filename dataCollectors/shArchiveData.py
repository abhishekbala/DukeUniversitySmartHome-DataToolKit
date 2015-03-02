# -*- coding: utf-8 -*-
"""

"""
import os
import time
import csv
import pymysql.cursors
import sys
import datetime

dd = str(sys.argv[1])
mm = str(sys.argv[2])
yyyy = str(sys.argv[3])
# numDays = int(sys.argv[4])

# print command just for visualising script run.    
print "Getting the data from the desired day..."


time1 = datetime.datetime(int(yyyy), int(mm), int(dd))
unixTimeDesired = time.mktime(time1.timetuple())


# Convert the desired time to Unix Time. !!MAKE SURE TO CALIBRATE CLOCK!!  
# There is a 51 second lag in the MySQL data.
unixTime = str(unixTimeDesired-51)

 
# Setup connection to MySQL database
connection=pymysql.connect(
	host='67.159.81.86',user='student',
	passwd='bassconnex',db='energydata',
	cursorclass = pymysql.cursors.SSCursor)
cursor=connection.cursor()


# Query the MySQL database.

# 1 second worth of data.
cursor.execute("SELECT smarthome.timestamp,	smarthome.b7139_01_r_01_phase1 \
, smarthome.b7139_01_r_02_phase2 FROM energydata.smarthome \
WHERE smarthome.timestamp =" +unixTime+ " \
ORDER BY smarthome.timestamp ASC")

# Store the 1 second data locally.
shData = [row for row in cursor]
# Store in csv (append).
with open("shArchiveData.csv",'a') as csvOut:
	csvwriter = csv.writer(csvOut,delimiter=',',dialect='excel')
	csvwriter.writerows(shData)
# Check the length of the CSV file.
with open("shArchiveData.csv",'rb') as csvFile:
	reader = csv.reader(csvFile)
	rowCount = sum(1 for row in reader)




# If CSV file is unnecessarily long, truncate.


#if rowCount > 1800:
#	with open("shArchiveData.csv", 'rb') as csvFileBig:
#		with open("shArchiveData1.csv", 'wb') as csvFile1:
#			for _ in range(1):
#				csvFileBig.next();
#			for line in csvFileBig:
#				csvFile1.write(line)   
#	os.remove("shArchiveData.csv")
#	os.rename("shArchiveData1.csv","shArchiveData.csv")
# Pause for 1 second and then repeat. Could use more sophisticated wait
	# like in wuTemp if needed.
#time.sleep(1)

cursor.close()
connection.close()
