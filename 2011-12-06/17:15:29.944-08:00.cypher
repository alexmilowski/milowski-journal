
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2011-12-06T17:15:29.944000-08:00'})
SET n.genre = 'blog',
    n.headline = 'XProc on My Website',
    n.description = 'I\'ve migrated my whole website to run on a combination of [XProc](http://www.w3.org/TR/XProc) , [Restlet](http://www.restlet.org) , and the new [Atomojo V2](http://code.google.com/p/atomojo) server.  Atomojo V2 provides an Atom APP backend powered by XProc and [MarkLogic](http://www.marklogic.com) glued together using Restlet.  The same archictecture has been use to deploy this website.  That is, almost all the pages are the result of running some XProc-enabled process.',
    n.datePublished = '2011-12-06T17:15:29.944000-08:00',
    n.dateModified = '2011-12-06T17:15:29.944000-08:00',
    n.url = 'http://www.milowski.com/journal/entry/2011-12-06T17:15:29.944000-08:00'

MERGE (k0:Keyword {text:'XProc'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'atomojo'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'restlet'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'MarkLogic'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2011-12-06/17:15:29.944-08:00.html'})
MERGE (n)-[:AssociatedMedia]->(r)