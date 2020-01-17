
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2016-05-25T11:17:00-08:00'})
SET n.genre = 'blog',
    n.headline = 'Retro: Semantic Hybridization',
    n.description = 'In 2015, I presented a short paper about "Semantic Hybridization" at [XML Prague 2015](http://www.xmlprague.cz/archive/). It is a technique I\'ve been promoting for using RDFa and JSON-LD together.  Rather than make a choice of one or the other, use the strengths of each of the ways of representing semantic annotations.  The result is you can often avoid awkward constructions just for the sake of annotations.',
    n.datePublished = '2016-05-25T11:17:00-08:00',
    n.dateModified = '2016-05-25T11:17:00-08:00',
    n.url = 'http://www.milowski.com/journal/entry/2016-05-25T11:17:00-08:00'

MERGE (k0:Keyword {text:'XML Prague'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'Web'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'open data'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'RDFa'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (k4:Keyword {text:'JSON-LD'})
MERGE (n)-[:LabeledWith]->(k4)
MERGE (k5:Keyword {text:'semantics'})
MERGE (n)-[:LabeledWith]->(k5)
MERGE (k6:Keyword {text:'Semantic Hybridization'})
MERGE (n)-[:LabeledWith]->(k6)
MERGE (k7:Keyword {text:'retro'})
MERGE (n)-[:LabeledWith]->(k7)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2016-05-25/xmlprague-2015.html'})
MERGE (n)-[:AssociatedMedia]->(r)