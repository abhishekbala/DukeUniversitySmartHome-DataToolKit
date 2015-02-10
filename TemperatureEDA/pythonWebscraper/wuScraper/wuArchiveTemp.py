# -*- coding: utf-8 -*-
"""
Created on Tue Feb 10 14:04:37 2015

@author: Raghav Saboo
"""

import csv
import urllib
url = 'http://www.wunderground.com/history/airport/KRDU/2015/2/9/DailyHistory.html?format=1'
data = urllib.urlopen(url)
#datareader = data.splitlines(data)
reader = csv.reader(data)
tempD = [row for row in reader]

# open a file for writing.
csv_out = open("mycsv.csv",'wb')

# create the csv writer object.
mywriter = csv.writer(csv_out)

mywriter.writerows(tempD)

csv_out.close()