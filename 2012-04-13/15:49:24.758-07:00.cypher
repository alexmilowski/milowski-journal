
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2012-04-13T15:49:24.758000-07:00'})
SET n.genre = 'blog',
    n.headline = 'Experiments with Big Weather Data in MarkLogic - Doomed Approach',
    n.description = 'The [ “Naive Approach” ](http://www.milowski.com/journal/entry/2012-04-11T11:08:29.62-07:00/) of just importing the weather reports verbatim works if all you want to do is enumerate a particular weather report\'s data by segments of time.  That is, this expression works really well:',
    n.datePublished = '2012-04-13T15:49:24.758000-07:00',
    n.dateModified = '2012-04-13T15:49:24.758000-07:00',
    n.url = 'http://www.milowski.com/journal/entry/2012-04-13T15:49:24.758000-07:00'

MERGE (k0:Keyword {text:'MarkLogic'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'big data'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'weather'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2012-04-13/15:49:24.758-07:00.html'})
MERGE (n)-[:AssociatedMedia]->(r)