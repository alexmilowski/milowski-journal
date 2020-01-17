
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2016-05-24T13:25:00-08:00'})
SET n.genre = 'blog',
    n.headline = 'Retro: Scientific Computing in the Open Web Platform',
    n.description = 'It has been far too long since I\'ve written about my research, past or present, and I need to correct that.  I\'ve been rather silent over the past year or more — life has kept me busy with other things.  As such, I have a backlog of information.',
    n.datePublished = '2016-05-24T13:25:00-08:00',
    n.dateModified = '2016-05-24T13:25:00-08:00',
    n.url = 'http://www.milowski.com/journal/entry/2016-05-24T13:25:00-08:00'

MERGE (k0:Keyword {text:'XML Prague'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'Web'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'open data'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'science'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (k4:Keyword {text:'RDFa'})
MERGE (n)-[:LabeledWith]->(k4)
MERGE (k5:Keyword {text:'semantics'})
MERGE (n)-[:LabeledWith]->(k5)
MERGE (k6:Keyword {text:'retro'})
MERGE (n)-[:LabeledWith]->(k6)
MERGE (k7:Keyword {text:'PhD'})
MERGE (n)-[:LabeledWith]->(k7)
MERGE (k8:Keyword {text:'Edinburgh'})
MERGE (n)-[:LabeledWith]->(k8)
MERGE (k9:Keyword {text:'mesonet.info'})
MERGE (n)-[:LabeledWith]->(k9)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2016-05-24/xmlprague-2014.html'})
MERGE (n)-[:AssociatedMedia]->(r)