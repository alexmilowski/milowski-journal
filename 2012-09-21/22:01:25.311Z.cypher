
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2012-09-21T22:01:25.311000+00:00'})
SET n.genre = 'blog',
    n.headline = 'Comments Welcome!',
    n.description = 'I\'ve just added comments to my blog entries.  I\'m using a company called [Disqus](http://www.disqus.com) and their commenting service is fairly easy to integrate.  Unfortunately, it looks like you can only comment on one subject (URI) per page.  As such, if you want to view or add comments, you\'ll have to go to the entry page.  The "[view comments]" link on each entry will always take you to the comments--which are at the bottom of the entry.',
    n.datePublished = '2012-09-21T22:01:25.311000+00:00',
    n.dateModified = '2012-09-21T22:01:25.311000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2012-09-21T22:01:25.311000+00:00'

MERGE (k0:Keyword {text:'Disqus'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'comments'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2012-09-21/22:01:25.311Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)