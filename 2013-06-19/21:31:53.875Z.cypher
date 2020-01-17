
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2013-06-19T21:31:53.875000+00:00'})
SET n.genre = 'blog',
    n.headline = 'Managing Documents in MarkLogic with XProc',
    n.description = '### Summary',
    n.datePublished = '2013-06-19T21:31:53.875000+00:00',
    n.dateModified = '2013-06-19T21:31:53.875000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2013-06-19T21:31:53.875000+00:00'

MERGE (k0:Keyword {text:'XProc'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'MarkLogic'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'XQuery'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'big data'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (k4:Keyword {text:'Calabash'})
MERGE (n)-[:LabeledWith]->(k4)
MERGE (k5:Keyword {text:'MLD Approach'})
MERGE (n)-[:LabeledWith]->(k5)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2013-06-19/21:31:53.875Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)