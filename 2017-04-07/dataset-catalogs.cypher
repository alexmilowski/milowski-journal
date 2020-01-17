
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2017-04-07T15:00:00-07:00'})
SET n.genre = 'blog',
    n.headline = 'Open Data in a Private Context',
    n.description = '> The open data premise is a grand idea which I fully support and need to replicate into other contexts.',
    n.datePublished = '2017-04-07T15:00:00-07:00',
    n.dateModified = '2017-04-07T15:00:00-07:00',
    n.url = 'http://www.milowski.com/journal/entry/2017-04-07T15:00:00-07:00'

MERGE (k0:Keyword {text:'Data sets'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'open data'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'schema.org'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'JSON-LD'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (k4:Keyword {text:'semantics'})
MERGE (n)-[:LabeledWith]->(k4)
MERGE (k5:Keyword {text:'Semantic Data Lakes'})
MERGE (n)-[:LabeledWith]->(k5)
MERGE (k6:Keyword {text:'analytics'})
MERGE (n)-[:LabeledWith]->(k6)
MERGE (k7:Keyword {text:'data science'})
MERGE (n)-[:LabeledWith]->(k7)
MERGE (k8:Keyword {text:'data engineering'})
MERGE (n)-[:LabeledWith]->(k8)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2017-04-07/dataset-catalogs.html'})
MERGE (n)-[:AssociatedMedia]->(r)