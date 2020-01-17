
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2012-09-21T22:03:43.720000+00:00'})
SET n.genre = 'blog',
    n.headline = 'A Clarification for RDFa in the Browser',
    n.description = 'On [International Talk Like a Pirate Day](http://www.talklikeapirate.com) , September 19th, I happen to post my [<cite>RDFa in the Browser</cite>](http://www.milowski.com/journal/entry/2012-09-19T15:38:11.827Z/) entry about using [Green Turtle](http://code.google.com/p/green-turtle/) .  I have received some feedback about my use of  “typed links” when demonstrating RDFa in action.',
    n.datePublished = '2012-09-21T22:03:43.720000+00:00',
    n.dateModified = '2012-09-21T22:03:43.720000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2012-09-21T22:03:43.720000+00:00'

MERGE (k0:Keyword {text:'RDFa'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'javascript'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'browser'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2012-09-21/22:03:43.72Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)