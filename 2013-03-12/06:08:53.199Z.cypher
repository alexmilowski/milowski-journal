
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2013-03-12T06:08:53.199000+00:00'})
SET n.genre = 'blog',
    n.headline = 'Refactoring the RDFa API - Getting the Data',
    n.description = 'After numerous inquires about my opinion on making the [RDFa API](http://www.w3.org/TR/rdfa-api/) simpler, I decided to do a bit of research. I\'ve written several fairly complex *in-situ* services that use the RDFa API to provide functionality within the browser. As such, I decided to look at which parts of the RDFa API or the extensions that [Green Turtle ](https://code.google.com/p/green-turtle/) provides are actually used.',
    n.datePublished = '2013-03-12T06:08:53.199000+00:00',
    n.dateModified = '2013-03-12T06:08:53.199000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2013-03-12T06:08:53.199000+00:00'

MERGE (k0:Keyword {text:'RDFa'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'JavaScript'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'RDFa API'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2013-03-12/06:08:53.199Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)