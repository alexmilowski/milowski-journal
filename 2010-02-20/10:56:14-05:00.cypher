
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2010-02-20T10:56:14-05:00'})
SET n.genre = 'blog',
    n.headline = 'Web-based Editor for Atomojo',
    n.description = 'I just finished a web-based editor for the Atom Publishing Protocol that is part of Atomojo.  I\'ve also integrated it with the Atomojo server.  You can now just add the `edit-client=\'true\'` attribute to any `host` or `resource` declaration in your `server.conf` and it will configure the editor on the `/edit/` path of your server.',
    n.datePublished = '2010-02-20T10:56:14-05:00',
    n.dateModified = '2010-02-20T10:56:14-05:00',
    n.url = 'http://www.milowski.com/journal/entry/2010-02-20T10:56:14-05:00'

MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2010-02-20/10:56:14-05:00.html'})
MERGE (n)-[:AssociatedMedia]->(r)