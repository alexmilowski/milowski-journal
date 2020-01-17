
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2013-03-12T20:32:24.068000+00:00'})
SET n.genre = 'blog',
    n.headline = 'What is the Subject Origin?',
    n.description = '[RDFa](http://www.w3.org/TR/rdfa-core/) allow annotations of subjects (identifiers) to exist in multiple locations within a document. When a user tries to retrieve elements by this subject identifier, what element is returned? Currently, the [RDFa API](http://www.w3.org/TR/rdfa-api/) says that all the element origins in the document identified via `@about` , `@resource,`   `@src` , `@href` are returned by the  `document.getElementsBySubject()` API method.',
    n.datePublished = '2013-03-12T20:32:24.068000+00:00',
    n.dateModified = '2013-03-12T20:32:24.068000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2013-03-12T20:32:24.068000+00:00'

MERGE (k0:Keyword {text:'RDFa'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'RDFa API'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'JavaScript'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2013-03-12/20:32:24.068Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)