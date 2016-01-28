logarticlejoin.csv

Contins the left joined data from logs  tables on article_id from articles.

sqlite script

create view logarticlejoin as 
   ...> select log.user_id as user_id, articles.article_id as article_id, articles.topic_id as topic_id, articles.type_id as type_id, log.day as day, log.month as month, log.hour as hour, log.size as size
   ...> from log
   ...> left join articles
   ...> on log.article_id == articles.article_id
   ...> group by log.user_id, articles.article_id, topic_id, type_id,day, month, hour, size
   ...> order by log.user_id;
sqlite> select count(*) from logarticlejoin;
1761990




emailarticlejoin.csv contains the left join from email_content on to articles table.

create view emailarticle as 
   ...> select email_content.user_id as userid, email_content.article_id as articleid, articles.topic_id,
   ...> articles.type_id, email_content.send_time
   ...> from email_content
   ...> left join articles
   ...> on email_content.article_id == articles.article_id
   ...> group by userid, articleid, topic_id, type_id, send_time
   ...> order by userid;

sqlite> select count(*) from emailarticle;
10738006

