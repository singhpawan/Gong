__author__ = 'pawan'


import sys
import re
import json
import csv

regex = re.compile("\[(?P<day>\d\d)\/(?P<month>\w+)\/(?P<year>\d\d\d\d):(?P<hour>\d\d).+\] \"(?P<method>.+) \/click\?article_id=(?P<article_id>\d+)&user_id=(?P<user_id>\d+)"
                   " (?P<protocol>.+)\" (?P<status>[0-9]+) (?P<size>\S+)")

data = []
header = True
csvfile = open('/home/pawan/dataScienceChallenge/access.csv','w')

writer = csv.writer(csvfile)
for line in open('/home/pawan/dataScienceChallenge/access.log','r'):
    r = regex.search(line)
    if r is not None:
        res = r.groupdict()
        if header == True:
            writer.writerow(res.keys())
            header = False
        else:
            writer.writerow(res.values())







