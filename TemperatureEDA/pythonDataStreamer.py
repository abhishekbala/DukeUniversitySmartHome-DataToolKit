# -*- coding: utf-8 -*-
"""
Created on Sun Jan 25 17:09:49 2015

@author: Raghav Saboo
"""
from datetime import datetime, timedelta
import time
import csv
import pymysql.cursors

for _ in range(30):
    # There is a 51 second lag in the MySQL data.
    # The last 5 minutes worth of data is to be loaded every 5 minutes.
    unixTime = str(int(time.time())-352) 
    
    connection=pymysql.connect(
        host='67.159.81.86',user='student',
        passwd='bassconnex',db='energydata',
        cursorclass = pymysql.cursors.SSCursor)
    cursor=connection.cursor()
    
    cursor.execute("SELECT smarthome.timestamp,	smarthome.b7139_01_r_01_phase1 \
    , smarthome.b7139_01_r_02_phase2 FROM energydata.smarthome \
    WHERE smarthome.timestamp =" +unixTime+ " \
    ORDER BY smarthome.timestamp ASC")
    
    shData = [row for row in cursor]
    
    with open("shData.csv",'a') as csv_out:
        csvwriter = csv.writer(csv_out,delimiter=',',dialect='excel')
        csvwriter.writerows(shData)
    
    time.sleep(1)

cursor.close()
connection.close()
