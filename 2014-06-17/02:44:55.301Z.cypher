
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2014-06-17T02:44:55.301000+00:00'})
SET n.genre = 'blog',
    n.headline = 'Do Elements have URIs?',
    n.description = 'I was discussing a problem with triples generated from RDFa and the in-browser applications I have developed using [Green Turtle](https://github.com/alexmilowski/green-turtle)  with a learned colleague of mine whose opinions I value greatly. In short, I wanted to duplicate the kinds of processing I\'m doing in the browser so I can run it through XProc and do more complicated processing of the documents. Yet, I rely on the *origin of triples*  in the document for my application to work.',
    n.datePublished = '2014-06-17T02:44:55.301000+00:00',
    n.dateModified = '2014-06-17T02:44:55.301000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2014-06-17T02:44:55.301000+00:00'

MERGE (k0:Keyword {text:'RDFa'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'Web'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'Green Turtle'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'MarkLogic'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (k4:Keyword {text:'XPointer'})
MERGE (n)-[:LabeledWith]->(k4)
MERGE (k5:Keyword {text:'RDFa API'})
MERGE (n)-[:LabeledWith]->(k5)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2014-06-17/02:44:55.301Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)