
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2012-06-29T12:26:20.418000-07:00'})
SET n.genre = 'blog',
    n.headline = 'Too Much Data and Too Little Memory',
    n.description = 'Since my last update, I\'ve made a lot of good progress on my  “big weather data” project.  The goal was always to understand how to organize scientific sensor data like weather reports within a database system like MarkLogic.  Alas, I don\'t currently have access to the hardware to really produce a production quality system that actually stores terabytes of information.  I did want to see how far I could get and what the characteristics of cluster would be to store such large-scale information.',
    n.datePublished = '2012-06-29T12:26:20.418000-07:00',
    n.dateModified = '2012-06-29T12:26:20.418000-07:00',
    n.url = 'http://www.milowski.com/journal/entry/2012-06-29T12:26:20.418000-07:00'

MERGE (k0:Keyword {text:'MarkLogic'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'weather'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'XProc'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'big data'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2012-06-29/12:26:20.418-07:00.html'})
MERGE (n)-[:AssociatedMedia]->(r)