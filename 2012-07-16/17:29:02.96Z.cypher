
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2012-07-16T17:29:02.960000+00:00'})
SET n.genre = 'blog',
    n.headline = 'Experiments with Big Weather Data in MarkLogic - Right-sizing and Indexing',
    n.description = 'A lot has happened since my last update on my  “big data” weather experiment with [MarkLogic](http://www.marklogic.com/) .  I\'ve been through a server crash, low memory trouble, reloaded my database, calculated the actual server requirements, and migrated to a new server.   In summary:  “Whew!  That was a lot of work and hair pulling.”',
    n.datePublished = '2012-07-16T17:29:02.960000+00:00',
    n.dateModified = '2012-07-16T17:29:02.960000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2012-07-16T17:29:02.960000+00:00'

MERGE (k0:Keyword {text:'MarkLogic'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'big data'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'weather'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2012-07-16/17:29:02.96Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)