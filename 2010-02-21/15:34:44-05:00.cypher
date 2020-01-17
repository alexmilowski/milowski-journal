
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2010-02-21T15:34:44-05:00'})
SET n.genre = 'blog',
    n.headline = 'Using contenteditable in Atomojo\'s Editor',
    n.description = 'I just added the use of WYSIWIG editing to the content editor for entries with XHTML content.  The `contenteditable=\'true\'` is really simple and works very well in browsers like Safari or Firefox.  Given that I only use non-broken browsers to edit my feeds, this will work well.',
    n.datePublished = '2010-02-21T15:34:44-05:00',
    n.dateModified = '2010-02-21T15:34:44-05:00',
    n.url = 'http://www.milowski.com/journal/entry/2010-02-21T15:34:44-05:00'

MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2010-02-21/15:34:44-05:00.html'})
MERGE (n)-[:AssociatedMedia]->(r)