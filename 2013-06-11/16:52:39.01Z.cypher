
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2013-06-11T16:52:39.010000+00:00'})
SET n.genre = 'blog',
    n.headline = 'Microdata in Green Turtle',
    n.description = 'After being asked how hard it would be to add [Microdata](http://dev.w3.org/html5/md-LC/) , at least in some minimal way, to [Green Turtle](https://code.google.com/p/green-turtle/) I decided to find out.  Since I already have a bunch of infrastructure, this didn\'t feel like a hard thing to add.  If I did add support, at least experimentally, microdata and RDFa could use the same API and scripting support.',
    n.datePublished = '2013-06-11T16:52:39.010000+00:00',
    n.dateModified = '2013-06-11T16:52:39.010000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2013-06-11T16:52:39.010000+00:00'

MERGE (k0:Keyword {text:'RDFa'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'Microdata'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'Green Turtle'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2013-06-11/16:52:39.01Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)