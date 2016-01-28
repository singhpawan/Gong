__author__ = 'pawan'


import csv
import sys
from collections import defaultdict
from collections import Counter
import random
import math



def prepare_topic_likelihood_data(filename):
    """Generates the prior for the topicID and data structure

    The likelihood dict contains the topicID count for each user i.e number of
    articles read by each user for a particular topic ID.

    :param filename: pass the file for the clicked data and the eamiled data
     logarticlejoin.csv : contains the clicked data
     emailarticlejoin.csv: contains the emailed data
    :return: the priors of topicid in the each file and the data structure containing
    all the counts for individual topicIDs for each user.
    """
    priors = Counter()
    likelihood = defaultdict(Counter)
    logfile = open(filename, 'r')
    reader = csv.reader(logfile)
    header = reader.next()
    for line in reader:
        userid = line[0]
        topicid = line[2]
        priors[topicid] += 1
        likelihood[userid][topicid] += 1

    return priors, likelihood




def prepare_type_likelihood_data(filename):
    """Generates the prior for the tyepID and data structure

    The likelihood dict contains the typeID count for each user i.e number of
    articles read by each user for a particular type ID.

    :param filename: pass the file for the clicked data and the eamiled data
     logarticlejoin.csv : contains the clicked data
     emailarticlejoin.csv: contains the emailed data
    :return: the priors of typeID in the each file and the data structure containing
    all the counts for individual typeIDs for each user.
    """
    priors = Counter()
    likelihood = defaultdict(Counter)
    logfile = open(filename, 'r')
    reader = csv.reader(logfile)
    header = reader.next()
    for line in reader:
        userid = line[0]
        typeid = line[3]
        priors[typeid] += 1
        likelihood[userid][typeid] += 1

    return priors, likelihood



"""
def random_likelihood(line, priors, likelihood):

    categories = priors.keys()
    return categories[int(random.random() * len(categories))]
"""


"""
def max_prior_likelihood(line,priors, likelihood):
    categories = priors.keys()
    return max(priors, key = lambda x: priors[x])
"""

## created two new feaatures called the topic_throughput and type throughput
## although not used in the model but can be used in future model to further
## create a weighted model.


def naive_likelihood(line,priors, likelihood,type_likelihood,emailfilename):
    """Generate the likelihood of a user viewing a article

    Takes in the test line and the priors and likelihood for the accesslog file
    and returns the likelihood of the user clicking a link.

    :param line:
    :param priors:
    :param likelihood:
    :param emailfilename:
    :return:likelihood of the user clicking using the posterior probability of typeid and topicID
    for the user.
    """
    e_topic_priors, e_topic_likelihood = prepare_topic_likelihood_data(emailfilename)
    e_type_priors, e_type_likelihood = prepare_type_likelihood_data(emailfilename)
    line = line.strip().split(',')
    topicid = line[2]
    typeid = line[3]
    userid =  line[0]
    ##Calculates the number of articles for this topicID sent to the user
    e_topic_prior = e_topic_priors[topicid]

    ##Calculate teh number of articles sent to the user of this typeID
    e_type_prior = e_type_priors[typeid]

    ##Total number of articles in the sent file
    total_articles_sent = sum(e_topic_priors.values())

    ##Total number of articles sent to a particular userID
    nArticles_sent = float(sum(e_topic_likelihood[userid].values()))

    ##Total number of articles read by the userID
    nArticles_read = float(sum(likelihood[userid].values()))

    ##Fraction of articles read by the user add 1 to avoid divide by zero.
    prior_seen = (nArticles_read + 1)/ (nArticles_sent + 1)

    ##Calculates P(topicID | Seen) for a given topicID
    topicid_seen = max(1E-4,likelihood[userid][topicid] / nArticles_read)

    ##Calculate P(typeID | Seen) for a given typeID
    typeid_seen = max(1E-4, type_likelihood[userid][typeid] / nArticles_read)

    ## calculate P(Seen|topicID) posterior for a given topicID
    topic_prob = (prior_seen * topicid_seen)

    ## calculate P(Seen|typeID) posterior for a given typeID
    type_prob = (prior_seen * typeid_seen )


    print topic_prob, ": Likelihood of reading the topic"
    print type_prob, ": Likelihood of reading in type"

    ## calculates the fraction of articles  read by the user for a particular topicID to the number
    ## of articles for a particular topicID sent to the user.
    ## using max to avoid divide by zero and in numerator to stop mulitply by 0.
    topic_read_throughput = max(1,float(likelihood[userid][topicid])) / float(max(1,(e_topic_likelihood[userid][topicid])))

    ## calculates the fraction of articles  read by the user for a particular typeID to the number
    ## of articles for a particular typeID sent to the user
    type_read_throughput = max(1,float(type_likelihood[userid][typeid])) / float(max(1,(e_type_likelihood[userid][typeid])))

    # Features Generated explained in the report
    print topic_read_throughput, ": Topic throughput"
    print type_read_throughput, ": Type throughput"

    ## calculates P(Seen|topicID,typeID) = P(Seen|topicID) * P(Seen|typeID)
    joint_likelihood = topic_prob * type_prob

    return (userid, topicid,typeid, math.log(joint_likelihood))




def main():
    """
    accesslogile: pass the log file in here
    eamilarticlesent: pass the corresponding email sent file
    :return:
    """
    accesslogfile = sys.argv[1]
    emailarticlesent = sys.argv[2]
    topic_priors, topic_likelihood = prepare_topic_likelihood_data(accesslogfile)
    type_priors, type_likelihood = prepare_type_likelihood_data(accesslogfile)
    line = "5,16654,8,23,1,Apr,3,3190"
    userid, topicid, typeid, likelihood = naive_likelihood(line,topic_priors,topic_likelihood,type_likelihood,emailarticlesent)
    print "The probability of user {0} viewing the topic {1} and  typeid {2} is {3}".format(userid,topicid,typeid,likelihood)
    writefile = open('output.txt', 'w')

    ##Uncomment the code if you don't want to run on a testing file and want to see the likelihood for a individual user
    ## for a particular article id. The log and email file have been parsed in the above format and will take csv values.
    ## individual likelihood can be observed over a period of time by entering line and runnign it 3 times to observe the
    ## how the likelihood changes.
    """testfile = sys.argv[3]
    testentries = open(testfile,'r')
    for line in testentries:
        userid, topicid, typeid, likelihood = naive_likelihood(line,topic_priors,topic_likelihood,type_likelihood,emailarticlesent)
        str1 = "The probability of user {0} viewing the topic {1} and  typeid {2} is {3}".format(userid,topicid,typeid,likelihood)
        print str1
        writefile.write(str1)
    """


# Boiler plate syntax to call main.
if __name__ == "__main__":
    main()


