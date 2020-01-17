
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2013-07-26T19:33:06.198000+00:00'})
SET n.genre = 'blog',
    n.headline = 'Problems with Microdata',
    n.description = 'Given my recent grumbling about Google Blink developers trying to [remove XSLT](https://groups.google.com/a/chromium.org/forum/#!topic/blink-dev/zIg2KC7PyH0) from Chrome, the current state of Microdata vs [RDFa](http://www.w3.org/TR/rdfa-core/) makes me think we\'re creating another level of incompatibilities on the Web.  XSLT generally failed client-side on the Web due to the poor implementation within the various browsers.  At this point, of course people aren\'t using it en masse because it just didn\'t work.',
    n.datePublished = '2013-07-26T19:33:06.198000+00:00',
    n.dateModified = '2013-07-26T19:33:06.198000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2013-07-26T19:33:06.198000+00:00'

MERGE (k0:Keyword {text:'Microdata'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'RDFa'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'schema.org'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2013-07-26/19:33:06.198Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)