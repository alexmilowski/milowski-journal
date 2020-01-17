
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2013-05-06T20:42:15.965000+00:00'})
SET n.genre = 'blog',
    n.headline = 'Unified Content Descriptors',
    n.description = 'The [International Virtual Observatory Alliance (IVOA)](http://www.ivoa.net/) is an organization that helps set the technology standards used by Astronomers on the Web to exchange information.  One interesting aspect of astronomical data is that how the data was collected is as important as the particular measurements or images of specific targets.  As such, when information is exchanged, semantics about what particular columns of data actual mean and how they related to each other (e.g. an error estimate for another column) is very important.',
    n.datePublished = '2013-05-06T20:42:15.965000+00:00',
    n.dateModified = '2013-05-06T20:42:15.965000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2013-05-06T20:42:15.965000+00:00'

MERGE (k0:Keyword {text:'RDFa'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'IVOA'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'Astronomy'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'schema.org'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2013-05-06/20:42:15.965Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)