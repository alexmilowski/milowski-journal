
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2014-05-23T23:23:03.290000+00:00'})
SET n.genre = 'blog',
    n.headline = 'Astroinformatics on the Web',
    n.description = 'This is the second entry in my series on my PhD dissertation titled <cite>Enabling Scientific Data on the Web</cite>.  In this entry, we will explore how astronomers use the Web to share data, some of standards and technologies they have developed, and bit about the history of their development.',
    n.datePublished = '2014-05-23T23:23:03.290000+00:00',
    n.dateModified = '2014-05-23T23:23:03.290000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2014-05-23T23:23:03.290000+00:00'

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
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2014-05-23/23:23:03.29Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)