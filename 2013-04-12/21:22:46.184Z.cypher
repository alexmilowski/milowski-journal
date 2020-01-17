
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2013-04-12T21:22:46.184000+00:00'})
SET n.genre = 'blog',
    n.headline = 'MarkLogic World 2013: mesonet.info: A Large-scale Weather Database for Citizen Science',
    n.description = '',
    n.datePublished = '2013-04-12T21:22:46.184000+00:00',
    n.dateModified = '2013-04-12T21:22:46.184000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2013-04-12T21:22:46.184000+00:00'

MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2013-04-12/21:22:46.184Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)