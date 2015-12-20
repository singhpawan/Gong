__author__ = 'pawan'


import sys
import re
import json

regex = re.compile("\[(?P<day>\d\d)\/(?P<month>\w+)\/(?P<year>\d\d\d\d):(?P<hour>\d\d).+\] \"(?P<method>.+) \/click\?article_id=(?P<article_id>\d+)&user_id=(?P<user_id>\d+)"
                   " (?P<protocol>.+)\" (?P<status>[0-9]+) (?P<size>\S+)")

data = []

writer = open('/home/pawan/dataScienceChallenge/access.json','w')
writer.write('[')
for line in open('/home/pawan/dataScienceChallenge/access.log','r'):
    r = regex.search(line)
    if r is not None:
        res = r.groupdict()
        writer.write(json.dumps(res))
        writer.write(',')
writer.write(']')


