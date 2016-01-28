How to run the program

IF you want to run check for the individual userid, articleID, topicID, typeID. 
Don't uncomment the code for the testing file. It takes a lot of time for training.
and then writing the results to a file.


###################################################################################
Likelihood for the month of Jan
python likelihoodv2.1.1.py jan_read_article.csv jan_send_article.csv 

###################################################################################
Likelihood for the month of Jan_Feb
python likelihoodv2.1.1.py jan_Feb_read_article.csv jan_feb_send_article.csv

###################################################################################
Likelihood for the entier 3 month period
python likelihoodv2.1.1.py logarticlejoin.csv emailarticlejoin.csv

###################################################################################
To run it against the testing file. I used the data for the month of Apr. But it
has a data containing articles that have not been read by most of the user and hence 
the likelihoods are small.

To runt this uncomment the testing code and supply the testing argument as below
python likelihoodv2.1.1.py logarticlejoin.csv emailarticlejoin.csv apr_read_article.csv



