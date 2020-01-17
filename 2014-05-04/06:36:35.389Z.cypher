
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2014-05-04T06:36:35.389000+00:00'})
SET n.genre = 'blog',
    n.headline = 'XProc to the Rescue: Restoring AtomPub',
    n.description = '## Restoring AtomPub via XProc',
    n.datePublished = '2014-05-04T06:36:35.389000+00:00',
    n.dateModified = '2014-05-04T06:36:35.389000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2014-05-04T06:36:35.389000+00:00'

MERGE (k0:Keyword {text:'XProc'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'atom'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'atompub'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2014-05-04/06:36:35.389Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)