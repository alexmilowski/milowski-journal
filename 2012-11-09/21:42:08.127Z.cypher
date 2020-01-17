
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2012-11-09T21:42:08.127000+00:00'})
SET n.genre = 'blog',
    n.headline = 'Updates and yet more updates ...',
    n.description = 'Some rather unfortunate things have been happening in my life, things that just happen because the are bound to happen sometime, like losing my father.  I\'m reminded of the good things and that life will just continue.  In one of his more salient and conscious moments he said to me, as I was pondering my pending trip to Edinburgh, to continue my PhD research and  “Go and get the damn thing done!”',
    n.datePublished = '2012-11-09T21:42:08.127000+00:00',
    n.dateModified = '2012-11-09T21:42:08.127000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2012-11-09T21:42:08.127000+00:00'

MERGE (k0:Keyword {text:'RDFa'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'Green Turtle'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'JSON-LD'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'XML Prague'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (k4:Keyword {text:'XProc'})
MERGE (n)-[:LabeledWith]->(k4)
MERGE (k5:Keyword {text:'Raspberry Pi'})
MERGE (n)-[:LabeledWith]->(k5)
MERGE (k6:Keyword {text:'weather'})
MERGE (n)-[:LabeledWith]->(k6)
MERGE (k7:Keyword {text:'phd'})
MERGE (n)-[:LabeledWith]->(k7)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2012-11-09/21:42:08.127Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)