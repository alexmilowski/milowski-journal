
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2012-04-10T15:31:30.541000-07:00'})
SET n.genre = 'blog',
    n.headline = 'Experiments with Big Weather Data in MarkLogic - Introduction',
    n.description = 'Over the past couple months, I\'ve been experimenting with  “big data” on the web for scientific purposes. The goal is to take my research on geospatial scientific data on the web and use [MarkLogic](http://www.marklogic.com/) to create a repository for large sensor data. My current scientific area of focus is weather data (sensor data in general) that I\'m collecting through the [Citizen Weather Observation Program (CWOP)](http://www.wxqa.com/) .',
    n.datePublished = '2012-04-10T15:31:30.541000-07:00',
    n.dateModified = '2012-04-10T15:31:30.541000-07:00',
    n.url = 'http://www.milowski.com/journal/entry/2012-04-10T15:31:30.541000-07:00'

MERGE (k0:Keyword {text:'MarkLogic'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'big data'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'weather'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'APRS'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2012-04-10/15:31:30.541-07:00.html'})
MERGE (n)-[:AssociatedMedia]->(r)