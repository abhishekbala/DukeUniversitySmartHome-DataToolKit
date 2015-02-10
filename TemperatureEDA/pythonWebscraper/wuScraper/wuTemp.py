# -*- coding: utf-8 -*-
"""
Created on Tue Feb 10 13:00:29 2015

@author: Raghav Saboo
"""

import urllib
import re

htmlfile = urllib.urlopen("http://www.wunderground.com/weather-forecast/zmw:27701.1.99999?MR=1")

htmltext = htmlfile.read()

regex1 = '<span class="wx-value">(.+?)</span>'
regex2 = '<div class="local-time"><i class="fi-clock"></i> <span>(.+?)</span>'

pattern1 = re.compile(regex1)
pattern2 = re.compile(regex2)

temp = re.findall(pattern1,htmltext)
datetime = re.findall(pattern2,htmltext)
print temp[6]
print datetime