
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2017-03-31T15:00:00-08:00'})
SET n.genre = 'blog',
    n.headline = 'New Research Agenda',
    n.description = 'I have been rather silent for awhile and environment has everything to do with that.  Many startups work under the guise of secrecy and my day-to-day work kept me quite busy without much opportunity to communicate.  In my new endeavours at [Orange Silicon Valley](http://www.orangesv.com) (really, San Francisco) my role is a communicator of new and interesting things.  As such, keeping this blog up-to-date with what is rolling around in my mind is one aspect of that.',
    n.datePublished = '2017-03-31T15:00:00-08:00',
    n.dateModified = '2017-03-31T15:00:00-08:00',
    n.url = 'http://www.milowski.com/journal/entry/2017-03-31T15:00:00-08:00'

MERGE (k0:Keyword {text:'Web'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'JSON-LD'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'Microservices'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'semantics'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (k4:Keyword {text:'Semantic Data Lakes'})
MERGE (n)-[:LabeledWith]->(k4)
MERGE (k5:Keyword {text:'duckpond'})
MERGE (n)-[:LabeledWith]->(k5)
MERGE (k6:Keyword {text:'analytics'})
MERGE (n)-[:LabeledWith]->(k6)
MERGE (k7:Keyword {text:'data flow languages'})
MERGE (n)-[:LabeledWith]->(k7)
MERGE (k8:Keyword {text:'Pipelines'})
MERGE (n)-[:LabeledWith]->(k8)
MERGE (k9:Keyword {text:'data science'})
MERGE (n)-[:LabeledWith]->(k9)
MERGE (k10:Keyword {text:'data engineering'})
MERGE (n)-[:LabeledWith]->(k10)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2017-03-31/new-agenda.html'})
MERGE (n)-[:AssociatedMedia]->(r)