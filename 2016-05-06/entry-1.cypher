
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2016-05-06T15:00:00-08:00'})
SET n.genre = 'blog',
    n.headline = 'Changing Technology for the Web and Open Government?',
    n.description = '[Code for America](https://www.codeforamerica.org) is a great organization that is helping city, county, and state governments deliver technology that serves their communities.  I was researching projects and whether there was some place I could lend my expertise when I happened to discover that [they have at API](http://codeforamerica.org/api/)!  Being a data geek, I thought it would be easier to crunch the data than navigate the website.',
    n.datePublished = '2016-05-06T15:00:00-08:00',
    n.dateModified = '2016-05-06T15:00:00-08:00',
    n.url = 'http://www.milowski.com/journal/entry/2016-05-06T15:00:00-08:00'

MERGE (k0:Keyword {text:'Code for America'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'Web'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'data science'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'API'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (k4:Keyword {text:'Friday Hacking'})
MERGE (n)-[:LabeledWith]->(k4)
MERGE (k5:Keyword {text:'Python'})
MERGE (n)-[:LabeledWith]->(k5)
MERGE (k6:Keyword {text:'open data'})
MERGE (n)-[:LabeledWith]->(k6)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2016-05-06/entry-1.html'})
MERGE (n)-[:AssociatedMedia]->(r)