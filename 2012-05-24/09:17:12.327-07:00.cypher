
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2012-05-24T09:17:12.327000-07:00'})
SET n.genre = 'blog',
    n.headline = 'Using RDFa to Annotate Images',
    n.description = '### The Idea',
    n.datePublished = '2012-05-24T09:17:12.327000-07:00',
    n.dateModified = '2012-05-24T09:17:12.327000-07:00',
    n.url = 'http://www.milowski.com/journal/entry/2012-05-24T09:17:12.327000-07:00'

MERGE (k0:Keyword {text:'rdfa'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'javascript'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2012-05-24/09:17:12.327-07:00.html'})
MERGE (n)-[:AssociatedMedia]->(r)