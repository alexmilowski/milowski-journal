
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2013-06-07T15:22:33.260000+00:00'})
SET n.genre = 'blog',
    n.headline = 'Scientific Measurements in Schema.org',
    n.description = 'The physical sciences use the idea of a [quantity](http://en.wikipedia.org/wiki/Quantity#Quantity_in_physical_science) to measure the world around us.  While that might seem simple, basing a measurement on a system of units that can be quantified, measured accurately, verified isn\'t exactly simple.  Nevertheless, a great deal of time and effort has converged into the [International System of Units (SI)](http://en.wikipedia.org/wiki/International_System_of_Units) .',
    n.datePublished = '2013-06-07T15:22:33.260000+00:00',
    n.dateModified = '2013-06-07T15:22:33.260000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2013-06-07T15:22:33.260000+00:00'

MERGE (k0:Keyword {text:'rdfa'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'schema.org'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'science'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'SI units'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2013-06-07/15:22:33.26Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)