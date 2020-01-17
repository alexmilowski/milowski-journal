
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2008-09-25T12:39:47-07:00'})
SET n.genre = 'blog',
    n.headline = 'Restlet is Awesome!',
    n.description = '[Restlet](http://www.restlet.org) is really an amazing project.  It is so easy to create a REST-oriented service.',
    n.datePublished = '2008-09-25T12:39:47-07:00',
    n.dateModified = '2008-09-25T12:39:47-07:00',
    n.url = 'http://www.milowski.com/journal/entry/2008-09-25T12:39:47-07:00'

MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2008-09-25/12:39:47-07:00.html'})
MERGE (n)-[:AssociatedMedia]->(r)