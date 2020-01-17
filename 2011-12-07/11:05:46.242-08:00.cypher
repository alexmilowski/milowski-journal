
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2011-12-07T11:05:46.242000-08:00'})
SET n.genre = 'blog',
    n.headline = 'Bad Choices in Forwards Compatibility within IE',
    n.description = 'In the final throws of working on this website update, I had to go and test on different versions of IE.  I knew a lot of things were not going to work in anything before IE (Internet Explorer) 9.  Nevertheless, I needed something to show up for the poor folks still using a broken browser.',
    n.datePublished = '2011-12-07T11:05:46.242000-08:00',
    n.dateModified = '2011-12-07T11:05:46.242000-08:00',
    n.url = 'http://www.milowski.com/journal/entry/2011-12-07T11:05:46.242000-08:00'

MERGE (k0:Keyword {text:'html5'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'IE'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'web'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2011-12-07/11:05:46.242-08:00.html'})
MERGE (n)-[:AssociatedMedia]->(r)