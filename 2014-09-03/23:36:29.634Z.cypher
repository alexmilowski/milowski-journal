
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2014-09-03T23:36:29.634000+00:00'})
SET n.genre = 'blog',
    n.headline = 'NASA OpenNEX Challenge and Processing HDF5 in Python',
    n.description = 'I\'ve recently been playing around a lot with HDF5 data as second part of the [<cite>NASA Challenge: New Ways to Use, Visualize, and Analyze OpenNEX Climate and Earth Science Data</cite>](https://www.innocentive.com/ar/challenge/9933584) . [Henry Thompson](http://www.ltg.ed.ac.uk/~ht/)  and I won a small award in the first challenge for our proposal to apply the PAN Methodology to the OpenNEX data.  Specifically, we are looking at the [NASA Earth Exchange (NEX) ](https://nex.nasa.gov/nex/static/htdocs/site/extra/opennex/) data sets that are [hosted by Amazon AWS](https://aws.amazon.com/nasa/nex/) that provides climate projects both retrospectively (1950-2005) and prospectively (2006-2099).',
    n.datePublished = '2014-09-03T23:36:29.634000+00:00',
    n.dateModified = '2014-09-03T23:36:29.634000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2014-09-03T23:36:29.634000+00:00'

MERGE (k0:Keyword {text:'OpenNEX'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'NASA'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'HDF'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'Python'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2014-09-03/23:36:29.634Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)