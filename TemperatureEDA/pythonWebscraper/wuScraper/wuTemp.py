# -*- coding: utf-8 -*-
"""
Created on Tue Feb 10 13:00:29 2015

@author: Raghav Saboo
"""
from datetime import datetime, timedelta
import os
import csv
import urllib
import re

# Continuous while loop. Might want to consider threading/sched instead later.
while 1:
    # Get the XML date from Weather Underground    
    htmlfile = urllib.urlopen("http://www.wunderground.com/weather-forecast/zmw:27701.1.99999?MR=1")
    htmltext = htmlfile.read()
    # Parse through the XML to get the relevant data
    regex1 = '<span class="wx-value">(.+?)</span>'
    regex2 = '<div class="local-time"><i class="fi-clock"></i> <span>(.+?)</span>'
    pattern1 = re.compile(regex1)
    pattern2 = re.compile(regex2)
    # Store the data
    temp = re.findall(pattern1,htmltext)
    date = re.findall(pattern2,htmltext)
    data = [[temp[6],date]]
    # Open the csv file storing the Temperature Date
    with open("wuTempData.csv",'a') as csvOut:
        # Write the data from Weather Underground to local csv
        csvwriter = csv.writer(csvOut,delimiter=',',dialect='excel')
        csvwriter.writerows(data)
    # Count the number of rows in the csv file
    with open("wuTempData.csv", 'rb') as csvFile:
        reader = csv.reader(csvFile)    
        rowCount = sum(1 for row in reader)
    # If the csv file is too big, truncate it
    if rowCount > 60:
        with open("wuTempData.csv", 'rb') as csvFileBig:
            with open("wuTempData1.csv", 'wb') as csvFile1:
                for _ in range(30):
                    csvFileBig.next();
                for line in csvFileBig:
                    csvFile1.write(line)   
        os.remove("wuTempData.csv")
        os.rename("wuTempData1.csv","wuTempData.csv")
        # Schedule the next run
    nextRun = datetime.now() + timedelta(seconds = 10)
    # Enter another while loop until time for the next run
    while 1:
        if datetime.now() > nextRun:
            print "Getting the current temperature reading"
            break