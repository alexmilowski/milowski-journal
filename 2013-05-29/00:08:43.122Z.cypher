
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2013-05-29T00:08:43.122000+00:00'})
SET n.genre = 'blog',
    n.headline = 'Green Turtle 1.0 Released!',
    n.description = 'I\'ve just released 1.0 of [Green Turtle](https://code.google.com/p/green-turtle/) .  My implementation now passes **all** the tests in the W3C conformance test suite for both [RDFa 1.1](http://www.w3.org/TR/rdfa-core/) and [Turtle](http://www.w3.org/TR/turtle/) .',
    n.datePublished = '2013-05-29T00:08:43.122000+00:00',
    n.dateModified = '2013-05-29T00:08:43.122000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2013-05-29T00:08:43.122000+00:00'

MERGE (k0:Keyword {text:'RDFa'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'JavaScript'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'Turtle'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'Green Turtle'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2013-05-29/00:08:43.122Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)