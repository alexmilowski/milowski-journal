
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2008-09-25T14:53:42-07:00'})
SET n.genre = 'blog',
    n.headline = 'slow & painful',
    n.description = 'Reconstructing my website from the raw data is a slow and painful process.  *sigh*',
    n.datePublished = '2008-09-25T14:53:42-07:00',
    n.dateModified = '2008-09-25T14:53:42-07:00',
    n.url = 'http://www.milowski.com/journal/entry/2008-09-25T14:53:42-07:00'

MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2008-09-25/14:53:42-07:00.html'})
MERGE (n)-[:AssociatedMedia]->(r)