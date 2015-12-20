import sys
import os
import json
import csv
from collections import defaultdict
from  sets import Set


def process_file(filename):
  data = defaultdict(list)
  
  f = open(filename, 'r').readlines()
  for line in f:
    text = line.split(',')
    userid = text[0]
    data[userid]['articleid'] = text[1]
    data[userid]['topicid'] = text[2]
    data[userid]['typeid'] = text[3]

  return data




if __name__ == '__main__':
  filename = sys.argv[1]  
  data =  process_file(filename)
  print data
