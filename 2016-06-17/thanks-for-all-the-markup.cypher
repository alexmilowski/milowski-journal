
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2016-06-17T16:54:00-08:00'})
SET n.genre = 'blog',
    n.headline = 'Thanks for all the markup + ducks',
    n.description = 'My good friend Norm Walsh [recently posted](https://norman.walsh.name/2016/05/28/non-standard) about the state of standards development around XML:',
    n.datePublished = '2016-06-17T16:54:00-08:00',
    n.dateModified = '2016-06-17T16:54:00-08:00',
    n.url = 'http://www.milowski.com/journal/entry/2016-06-17T16:54:00-08:00'

MERGE (k0:Keyword {text:'Web'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'RDFa'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'JSON-LD'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'semantics'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (k4:Keyword {text:'Semantic Hybridization'})
MERGE (n)-[:LabeledWith]->(k4)
MERGE (k5:Keyword {text:'Semantic Data Lakes'})
MERGE (n)-[:LabeledWith]->(k5)
MERGE (k6:Keyword {text:'XML'})
MERGE (n)-[:LabeledWith]->(k6)
MERGE (k7:Keyword {text:'Markdown'})
MERGE (n)-[:LabeledWith]->(k7)
MERGE (k8:Keyword {text:'duckpond'})
MERGE (n)-[:LabeledWith]->(k8)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2016-06-17/thanks-for-all-the-markup.html'})
MERGE (n)-[:AssociatedMedia]->(r)