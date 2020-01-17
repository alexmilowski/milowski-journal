
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2012-09-19T15:38:11.827000+00:00'})
SET n.genre = 'blog',
    n.headline = 'RDFa in the Browser',
    n.description = 'While there is a lot talk about how [RDFa](http://www.w3.org/TR/rdfa-core/) is or will be used by search engines and others for indexing, my main focus has been on how authors can use RDFa to encode  “local knowledge.” Services that are local to the page, most often implemented by inclusion of some script, act upon such local knowledge that is encoded somewhere in the page.  In the past, people used the `class` or `id` attributes to identify the targeted content and then some amount of scripting made the rest of the connections.',
    n.datePublished = '2012-09-19T15:38:11.827000+00:00',
    n.dateModified = '2012-09-19T15:38:11.827000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2012-09-19T15:38:11.827000+00:00'

MERGE (k0:Keyword {text:'RDFa'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'browser'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2012-09-19/15:38:11.827Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)