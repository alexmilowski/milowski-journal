
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2013-07-26T15:25:04.782000+00:00'})
SET n.genre = 'blog',
    n.headline = 'Green Turtle - Injection and Microdata Options',
    n.description = 'I\'ve just released version 1.2 of [Green Turtle](https://code.google.com/p/green-turtle/) and its [Chrome extension](https://chrome.google.com/webstore/detail/green-turtle-rdfa/loggcajcfkpdeoaeihclldihfefijjam) .  While there are minor bug fixes, there are three new features:',
    n.datePublished = '2013-07-26T15:25:04.782000+00:00',
    n.dateModified = '2013-07-26T15:25:04.782000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2013-07-26T15:25:04.782000+00:00'

MERGE (k0:Keyword {text:'Green Turtle'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'RDFa'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'Microdata'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'Chrome Extension'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2013-07-26/15:25:04.782Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)