
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2014-06-03T00:31:15.606000+00:00'})
SET n.genre = 'blog',
    n.headline = 'GeoJSON to the Rescue (or not)!',
    n.description = 'This is the fourth entry in my series on my PhD dissertation titled <cite>Enabling Scientific Data on the Web</cite>.  In this entry, we will explore GeoJSON as an alternate approach to geospatial scientific data.',
    n.datePublished = '2014-06-03T00:31:15.606000+00:00',
    n.dateModified = '2014-06-03T00:31:15.606000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2014-06-03T00:31:15.606000+00:00'

MERGE (k0:Keyword {text:'phd'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'science'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'web'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'opendata'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (k4:Keyword {text:'Edinburgh'})
MERGE (n)-[:LabeledWith]->(k4)
MERGE (k5:Keyword {text:'GeoJSON'})
MERGE (n)-[:LabeledWith]->(k5)
MERGE (k6:Keyword {text:'JSON-LD'})
MERGE (n)-[:LabeledWith]->(k6)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2014-06-03/00:31:15.606Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)