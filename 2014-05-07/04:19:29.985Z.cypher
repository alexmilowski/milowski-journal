
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2014-05-07T04:19:29.985000+00:00'})
SET n.genre = 'blog',
    n.headline = 'An Introduction to My PhD Research',
    n.description = 'This is the start of a series of journal entries about my recently completed dissertation titled <cite>Enabling Scientific Data on the Web</cite>at the [School of Informatics, University of Edinburgh](http://www.ed.ac.uk/schools-departments/informatics/) . As I wait to defend my dissertation (July?), I\'m going to try to explain what I\'ve been up to these past four years. My hope is that not only will people understand what I\'ve been doing, but also it will help me find new ways of explaining it other than a rather long document that few will actually read cover-to-cover.',
    n.datePublished = '2014-05-07T04:19:29.985000+00:00',
    n.dateModified = '2014-05-07T04:19:29.985000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2014-05-07T04:19:29.985000+00:00'

MERGE (k0:Keyword {text:'phd'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'science'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'PAN'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'web'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (k4:Keyword {text:'opendata'})
MERGE (n)-[:LabeledWith]->(k4)
MERGE (k5:Keyword {text:'Edinburgh'})
MERGE (n)-[:LabeledWith]->(k5)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2014-05-07/04:19:29.985Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)