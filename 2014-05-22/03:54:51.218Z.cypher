
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2014-05-22T03:54:51.218000+00:00'})
SET n.genre = 'blog',
    n.headline = 'XProclet Released',
    n.description = '## What is it?',
    n.datePublished = '2014-05-22T03:54:51.218000+00:00',
    n.dateModified = '2014-05-22T03:54:51.218000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2014-05-22T03:54:51.218000+00:00'

MERGE (k0:Keyword {text:'XProc'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'Restlet'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'web'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'github'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2014-05-22/03:54:51.218Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)