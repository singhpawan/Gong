install.packages("gridExtra")
install.packages('extrafont')
library(ggplot2)
library(dplyr)
library(reshape2)
library(tidyr)
library(GGally)
library(gridExtra)
library(extrafont)

theme_set(theme_minimal(20))



articles = read.csv('/home/pawan/dataScienceChallenge/data_csv/logarticlejoin.csv')
emailarticles = read.csv('/home/pawan/dataScienceChallenge/data_csv/emailarticlejoin.csv')
head(articles)
head(emailarticles)


summary(articles)
table(articles)
names(articles)

## articlesna contains the articles that the user clicked on in the log data
articlesna = subset(articles, !is.na(article_id))
## emailarticlesna contains the articles sent to all the users in the email
emailarticlesna = subset(emailarticles, !is.na(articleid))

summary(articlesna)
##number of that user checked
nrow(articlesna)

sample1 = subset(articlesna, month == 'Apr')
summary(sample1)
head(sample1)
tt <-table(articlesna['topic_id'])
et <-table(emailarticlesna['topic_id'])
dim(tt)
##############################create a dataframe from the output of the table command for clicked data##################################################
x <- c()
y <- c()
for( i in 1:dim(tt))
{
  x[i] <- i;
  y[i] <- tt[i];
}

df <- data.frame(x,y)
df

#############################create a dataframe from the output of the table command for emailed data###########################


articleid <- c()
cnt <- c()
for( i in 1:dim(et))
{
  articleid[i] <- i;
  cnt[i] <- et[i];
}

edf <- data.frame(articleid,cnt)
edf

#########################################combining data to get plots of number of articles sent for a particular topic id##########
#########################################and the articles for a particular topic clicked by the user and their ratios    ##########

cdf <- data.frame(articleid,y,cnt)
colnames(cdf) <- c('articleid','logcount','emailcount')
head(cdf)



################### plot of the number of articles clicked by the user from the log data ###############################

p4 <-ggplot(aes(x = articleid, y = logcount), data = cdf) + geom_point(color = 'green') + geom_line(color = 'black') + scale_x_continuous(limits = c(1,106), breaks = seq(0,106,5)) +
  xlab('Topic ID') + ylab('Number of Articles Clicked') + ggtitle('Plot of articles clicked by the user from log data')



head(cdf$emailcount)
head(cdf$logcount)
sendrecratio <- cdf$logcount/cdf$emailcount
head(sendrecratio)

ratiodf <- data.frame(articleid, sendrecratio)


################### plot of the number of articles emailed to the number of articles clicked ###########################

p5 <- ggplot(aes(x = articleid, y = logcount), data =cdf) + geom_point(color = 'green') + geom_line(aes(x = articleid, y = logcount,color = 'black')) + scale_x_continuous(limits = c(1,106), breaks = seq(0,106,5)) +
  geom_point(aes(x = articleid, y = emailcount), color = 'black') + geom_line(aes(x = articleid, y = emailcount, color = 'orange') ) +
  xlab('Topic ID') + ylab('Number of Articles') + ggtitle('Comparison of Number of Articles sent vs clicked') + scale_colour_manual(name = "Legend", values = c('black' = 'black', 'orange' = 'orange'),labels = c('Articles Clicked', 'Articles Sent'))

################### plot of the ratio of the articles clicked to the articles emailed        ########################### 
p6 <- ggplot(aes(x = articleid, y = sendrecratio), data = ratiodf) + geom_point(color = 'orange',size = 2.5) + geom_line() + scale_x_continuous(limits = c(1,106), breaks = seq(0,106,5)) +
  ggtitle('Ratio of articles sent vs articles clicked w.r.t topic_id') + xlab('Topic ID') + 
  ylab('Articles sent / Articles clicked')


grid.arrange(p4, p5, p6, ncol = 1)



################## Plots to see what kind of medium or type_id are users most interested in  ############################
typedflog <-table(articlesna['type_id'])
typedfemail <-table(emailarticlesna['type_id'])

##############################create a dataframe from the output of the table command for clicked data##################################################
typeid <- c()
tlogcount <- c()
for( i in 1:dim(typedflog))
{
  typeid[i] <- i;
  tlogcount[i] <- typedflog[i];
}

tldf <- data.frame(typeid,tlogcount)
tldf

#############################create a dataframe from the output of the table command for emailed data###########################



temailcount <- c()
for( i in 1:dim(typedfemail))
{
  temailcount[i] <- typedfemail[i];
}

tedf <- data.frame(typeid,temailcount)
tedf


#########################################combining data to get plots of number of articles sent for a particular topic id##########
#########################################and the articles for a particular topic clicked by the user and their ratios    ##########

tdf <- data.frame(typeid,tlogcount,temailcount)
head(tdf)


################### plot of the number of articles clicked by the user from the log data ###############################

p1 <-ggplot(aes(x = typeid, y = tlogcount), data = tdf) + geom_point(color = 'green') + geom_line(color = 'black') + scale_x_continuous(limits = c(1,49), breaks = seq(0,49,2)) +
  xlab('Type ID') + ylab('Number of Articles Clicked') + ggtitle('Plot of articles clicked by the user from log data for type') +
  theme(plot.title = element_text(size=15, face="bold", vjust=2))

################### plot of the number of articles emailed to the number of articles clicked ###########################

p2 <- ggplot(aes(x = typeid, y = tlogcount), data =tdf) + geom_point(color = 'green') + geom_line(aes(x = typeid, y = tlogcount,color = 'black')) + 
  scale_x_continuous(limits = c(1,49), breaks = seq(0,49,2)) +
  geom_point(aes(x = typeid, y = temailcount), color = 'black') + geom_line(aes(x = typeid, y = temailcount, color = 'orange') ) +
  xlab('Type ID') + ylab('Number of Articles') + ggtitle('Comparison of Number of Articles sent vs clicked for Type') + 
  scale_colour_manual(name = "Legend", values = c('black' = 'black', 'orange' = 'orange'),labels = c('Articles Clicked', 'Articles Sent')) + 
  theme(plot.title = element_text(size=15, face="bold", vjust=2)) + 
  theme(axis.text.y = element_text(size=10, face="bold", vjust=2))


head(tdf$temailcount)
head(tdf$tlogcount)
sendrecvratio <- tdf$tlogcount/tdf$temailcount
head(sendrecvratio)

ratiotdf <- data.frame(typeid, sendrecvratio)

################### plot of the ratio of the articles clicked to the articles emailed for Type       ########################### 
p3 <- ggplot(aes(x = typeid, y = sendrecvratio), data = ratiotdf) + geom_point(color = 'orange',size = 2.5) + geom_line() + scale_x_continuous(limits = c(1,49), breaks = seq(0,49,2)) +
  ggtitle('Ratio of articles sent vs articles clicked w.r.t type_id') + xlab('Type ID') + 
  ylab('Articles sent / Articles clicked') + theme(plot.title = element_text(size=15, face="bold", vjust=2))

grid.arrange(p1,p2,p3, ncol =1)

########################################################################################

###Plot for the number of articles read at hour of day ################################

accesslog = read.csv('/home/pawan/dataScienceChallenge/access.csv')

head(accesslog)
names(accesslog)
summary(accesslog)
table(accesslog['month'])
table(accesslog['hour'])
saccesslog = accesslog[c(-1,-2,-5)]
ggpairs(saccesslog[sample.int(nrow(saccesslog),100),])


###########Plot of number of articles read during the hour of a day #####################################################
ggplot(aes(x = hour),data = accesslog) + geom_histogram(color = 'orange', fill = '#099D99') + scale_x_continuous(limits = c(0,23), breaks = seq(0,23,1)) +
  xlab('Hour of the day') + ylab('Number of articles read') + ggtitle('Plot of number of article read at hour of the day') + scale_y_continuous(limits = c(0,230000), breaks = seq(0,230000,10000))

###########Plot of number of articles read during the hour of a day with y axis at sqrt scale to see the smaller differences#################

ggplot(aes(x = hour),data = accesslog) + geom_histogram(color = 'orange', fill = '#099D99') + scale_x_continuous(limits = c(0,23), breaks = seq(0,23,1)) +
  xlab('Hour of the day') + ylab('Number of articles read') + ggtitle('Plot of number of article read at hour of the day') + scale_y_sqrt()

#############################################Plot of number of articles read by user in 3 months ####################################
userdf <- table(articlesna['user_id'])
head(userdf)
dim(userdf)

userid <- c()
articlecount1 <- c()
for( i in 1:dim(userdf))
{
  userid[i] <- i;
  articlecount1[i] <- userdf[i];
}

udf <- data.frame(userid, articlecount1)
udf
names(udf)


head(udf)
nrow(udf)
tail(udf$articlecount1)
ggplot(aes(x = userid, y = articlecount1), data = udf) + geom_point(alpha = 0.1, color = 'orange', position = position_jitter(h = 0) ) +
   coord_trans(y = 'sqrt') + xlab("UserID") + ylab("Number of Articles Read") + ggtitle("Number of articles read by user in 90 days.")


summary(articlecount)

