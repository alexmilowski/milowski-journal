
MERGE (n:Article {id:'http://www.milowski.com/journal/entry/2013-06-26T06:12:31.666000+00:00'})
SET n.genre = 'blog',
    n.headline = 'Disk Soup: AWS, EBS, RAID, MarkLogic, and Pinch of Salt!',
    n.description = 'At the [2013 MarkLogic User Conference](http://www.marklogic.com/events/marklogic-world-2013/) , I learned all kinds of interesting and valuable information about running [MarkLogic](http://www.marklogic.com/) on [AWS (Amazon Web Services) EC2 servers.](http://aws.amazon.com/) Most specifically, it was mentioned that I wasn\'t necessarily going to get a huge performance gain over regular EBS storage via the RAID 10 configuration that I cooked up.  That was good news to me because it costs me quite a bit to have all that extra EBS storage for RAID10.',
    n.datePublished = '2013-06-26T06:12:31.666000+00:00',
    n.dateModified = '2013-06-26T06:12:31.666000+00:00',
    n.url = 'http://www.milowski.com/journal/entry/2013-06-26T06:12:31.666000+00:00'

MERGE (k0:Keyword {text:'MarkLogic'})
MERGE (n)-[:LabeledWith]->(k0)
MERGE (k1:Keyword {text:'AWS'})
MERGE (n)-[:LabeledWith]->(k1)
MERGE (k2:Keyword {text:'RAID10'})
MERGE (n)-[:LabeledWith]->(k2)
MERGE (k3:Keyword {text:'EBS'})
MERGE (n)-[:LabeledWith]->(k3)
MERGE (a0:Author {name:'Alex Miłowski'})
MERGE (n)-[:AuthoredBy]->(a0)
MERGE (r:Resource { url: 'http://alexmilowski.github.io/milowski-journal/2013-06-26/06:12:31.666Z.html'})
MERGE (n)-[:AssociatedMedia]->(r)