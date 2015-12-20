import sys
import os
import csv
import json



filename = 'email'

csvfile = open(filename + '.csv','r')
jsonfile = open(filename + '.json','w')
reader = csv.DictReader(csvfile)
for row in reader:
  jsonfile.write(json.dumps(row))
