
articles = read.csv('/home/pawan/dataScienceChallenge/data_csv/logarticlejoin.csv')
emailarticles = read.csv('/home/pawan/dataScienceChallenge/data_csv/emailarticlejoin.csv')

##########File splitting in clicked data was done in R and for emailed data was done in sqlite3#######################
janarticles = subset(articles, articles$month == 'Jan')
nrow(janarticles)

jan_Feb_articles = subset(articles, articles$month == 'Jan' | articles$month == 'Feb')
nrow(jan_Feb_articles)

nrow(emailarticles)
write.csv(janarticles, '/home/pawan/dataScienceChallenge/data_csv/jan_read_article.csv',na="",quote=FALSE,row.names = FALSE)
write.csv(jan_Feb_articles, '/home/pawan/dataScienceChallenge/data_csv/jan_Feb_read_article.csv',na="",quote=FALSE,row.names = FALSE)
aprarticles = subset(articles, articles$month == 'Apr')
write.csv(aprarticles, '/home/pawan/dataScienceChallenge/data_csv/apr_read_article.csv',na="",quote=FALSE,row.names = FALSE)






