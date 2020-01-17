
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2010-03-11T01:27:28-05:00'})
SET n.genre = 'blog',
    n.headline = 'WebKit MathML is Progressing',
    n.description = 'I\'ve been able to make some progress getting MathML into the trunk of [WebKit](http://www.webkit.org/) .  You can see from the [master MathML Bug](https://bugs.webkit.org/show_bug.cgi?id=3251) that there are only a few patches that aren\'t in the trunk.  In fact, [33703](https://bugs.webkit.org/show_bug.cgi?id=33703) doesn\'t count because it is a union of other patches for others who want to play and is now almost obsolete.',
    n.datePublished = '2010-03-11T01:27:28-05:00',
    n.dateModified = '2010-03-11T01:27:28-05:00',
    n.url = 'http://www.milowski.com/journal/entry/2010-03-11T01:27:28-05:00'

MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2010-03-11/01:27:28-05:00.html'})
MERGE (n)-[:AssociatedMedia]->(r)