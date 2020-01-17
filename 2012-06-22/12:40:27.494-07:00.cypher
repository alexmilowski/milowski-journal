
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2012-06-22T12:40:27.494000-07:00'})
SET n.genre = 'blog',
    n.headline = 'Disk Space is Important!',
    n.description = 'Sometimes you learn interesting things under duress, reaffirm things you already know, and pay for not doing it right the first time.',
    n.datePublished = '2012-06-22T12:40:27.494000-07:00',
    n.dateModified = '2012-06-22T12:40:27.494000-07:00',
    n.url = 'http://www.milowski.com/journal/entry/2012-06-22T12:40:27.494000-07:00'

MERGE (k0:Keyword {text:'MarkLogic'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'AWS'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'EBS'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2012-06-22/12:40:27.494-07:00.html'})
MERGE (n)-[:AssociatedMedia]->(r)