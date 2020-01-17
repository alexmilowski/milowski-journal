
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2012-04-11T11:08:29.620000-07:00'})
SET n.genre = 'blog',
    n.headline = 'Experiments with Big Weather Data in MarkLogic - The Naive Approach',
    n.description = 'I\'ve heard over-and-over that [MarkLogic](http://www.marklogic.com/) is a fantastic XML database--you just import your documents and query away!  Given the quality of the people that I personally know at MarkLogic, I\'m sure that\'s true.  Still, I wanted to put that to the test.  Every database system has techniques for getting reasonable or  “blindingly fast” performance and I wanted to see how that works and at what cost.',
    n.datePublished = '2012-04-11T11:08:29.620000-07:00',
    n.dateModified = '2012-04-11T11:08:29.620000-07:00',
    n.url = 'http://www.milowski.com/journal/entry/2012-04-11T11:08:29.620000-07:00'

MERGE (k0:Keyword {text:'MarkLogic'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'big data'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'weather'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2012-04-11/11:08:29.62-07:00.html'})
MERGE (n)-[:AssociatedMedia]->(r)