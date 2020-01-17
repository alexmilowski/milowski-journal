
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2013-12-22T17:51:55.706000+00:00'})
SET n.genre = 'blog',
    n.headline = 'MathML Christmas',
    n.description = 'For users with browsers that support [MathML](http://www.w3.org/Math/) :',
    n.datePublished = '2013-12-22T17:51:55.706000+00:00',
    n.dateModified = '2013-12-22T17:51:55.706000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2013-12-22T17:51:55.706000+00:00'

MERGE (k0:Keyword {text:'MathML'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2013-12-22/17:51:55.706Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)