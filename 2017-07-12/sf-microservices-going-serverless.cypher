
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2017-07-12T10:35:00-07:00'})
SET n.genre = 'blog',
    n.headline = 'SF Microservices Meetup - Going Serverless with Flask',
    n.description = 'I gave a talk last night (July 11th, 2017) about deploying [python Flask-based](http://flask.pocoo.org) on',
    n.datePublished = '2017-07-12T10:35:00-07:00',
    n.dateModified = '2017-07-12T10:35:00-07:00',
    n.url = 'http://www.milowski.com/journal/entry/2017-07-12T10:35:00-07:00'

MERGE (k0:Keyword {text:'python'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'Flask'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'Serverless'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'FaaS'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (k4:Keyword {text:'AWS Lambda'})
MERGE (n)-[:LabeledWith]->(k4)
MERGE (k5:Keyword {text:'OpenWhisk'})
MERGE (n)-[:LabeledWith]->(k5)
MERGE (k6:Keyword {text:'IBM Bluemix'})
MERGE (n)-[:LabeledWith]->(k6)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2017-07-12/sf-microservices-going-serverless.html'})
MERGE (n)-[:AssociatedMedia]->(r)