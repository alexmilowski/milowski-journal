title: Thanks for all the markup + ducks
author: Alex Miłowski
published: 2016-06-17T16:54:00-08:00
updated: 2016-06-17T16:54:00-08:00
keywords: Web
                 RDFa
                 JSON-LD
                 semantics
                 Semantic Hybridization
                 Semantic Data Lakes
                 XML
                 Markdown
                 duckpond

# Thanks for all the markup + ducks

My good friend Norm Walsh [recently posted](https://norman.walsh.name/2016/05/28/non-standard) about the state of standards development around XML:

>"At the end of the day, I have come to accept the unpalatable truth that there are fewer and fewer organizations interested in continued development of XML standards and a tiny minority of overworked volunteers attempting to accomplish them."

My post is certainly not as well thought out as Norm's and I encourage you to read his post.

Previously, we've been working on the same standard (XProc) at the W3C and struggling with the same issues.   I had hoped for a different outcome for XProc but the lack of interest was too easy to see.  I feel the same but my contributions in this space pale in comparison; spending my time on "other things" will hardly be noticed.

## We're done folks.

Over time, technologies fade out of popularity, their use wanes, regardless of how well they do what they were designed to do.  For example, San Francisco still uses [fire alarm call boxes](https://en.wikipedia.org/wiki/Fire_alarm_call_box) that uses telegraph to communicate.  The system works well, the infrastructure is there, and they work in situations (disasters) when other things do not.  Your cell phone doesn't use telegraphs but you'll be happy that the fire alarm call box does when an earthquake happens.

That XML is no longer popular is not a great surprise.  My favorite joke is that we've replaced the letter 'x' with 'j' in the alphabet.  Many of my markup geek friends fail to laugh at that and, instead, order another beer for their tears.

That said, XML is a good syntax for certain kinds of data: documents.  There are plenty of domains where you just can't do without it, HTML will never suffice, and that's okay.

By the way, HTML is great and shares a common heritage (SGML).  SGML is also turns 30 years old this year.  That means many people who are using HTML weren't alive to experience its development, see the disruption (and dislike) from those work on SGML applications, or understand how we've had this problem of accepting new syntaxes for markup or data. 

I was there.  I started working with SGML in 1991, young, naive, and willing to try out the "koolaid".  It didn't kill me and there were plenty of interesting things you could do with it.  At the time, I felt like I joined a revolution.  In retrospect, it was XML that was the revolution and we all contributed to something that got us to where we are today.  It was an essential step.

## Data or documents?

We've been here before.  When we developed XML, it ushered in a whole new paradigm and many took that paradigm a bit too far.  It was going to be the new Remote Procedure Call (RPC) format, it was going to be for system-to-system (B2B, EDI, web services, etc.) exchange, it was going allow us to finally structure our content with "meaningful" markup, ... it was also going to slice bread, make us a sandwich, solve world peace, ... everything was going to be XML.

Replace "XML" with "JSON" and you've got today.

I like JSON.  It works well for certain kinds of object-structured data which is not a surprise given the acronym stands for "JavaScript Object Notation".  If you have objects and need to represent them for data transfer, JSON is a far better choice than XML.

In contrast, if you have a document and need to convey its structure, you have some choices in format but what you need is a markup language.  XML is a markup language.  HTML is a markup language. JSON is **not** a markup language.

There is a blurry distinction between "data" and "documents".  That is where the world gets less clear.  Reality is never easy but I choose to participate in it rather than a fantasy.

## XML hangovers

If you live in that blurry, gray area where things that are "data" are sometimes "documents" and "documents" are sometimes "data", I feel for you.  That is what I always thought we wanted XML to be used for but now that is in serious question.  If investment in XML technologies is coming to a close, where does that leave you?  HTML?

It isn't all that bad. I think we can get along quite well with a few things in our "back pockets":

 * HTML is pretty good for a lot of things
 * RDFa and JSON-LD allow you to annotate your HTML markup and make it more precise.
 * Web components allow you to create new markup structures that have operational semantics in the web browser.

So, the party is over and we still have markup.  It is different, not really as some of us imagined, and that is actually okay.

## Moving on

I really have moved on.  I mostly work on data that isn't XML and I use "other" markup languages for things.  I really like XML and it is something I don't have to think about.  It works well for me but I guess I'm just old school.

I've been working to expunge "old stuff" that doesn't work (no telegraph fire alarm boxes for me) and replace them with new things that work "better".  In some cases, I just want to try out new technologies. Given the limits on my time, I really want things to work better.  I also want to write more about technology.

My website was driven by Atom XML feeds with technology I cooked up in my "Mad XML Scientist" lab.  The three-headed XProc/XQuery/AtomPub monster actually prevented me from writing.  Why? Because I never got around to making it easy enough to use well.  AtomPub was the interface and it was an XML-based protocol.  It worked but I need better tools and no one was writing them.  Also, when things broke ... well, it was my own doing.

There had to be a better way.

## Ducks

If I was going to throw out the old, what is the new?  Given my recent research, I knew a few things:

 * use RDFa and JSON-LD to enhance my content.
 * writing needs to be easy ... markdown kind of easy
 * complex things need to be possible
 * semantics, semantics, semantics
 * drive things by querying semantics (e.g., SPARQL)
 * did I mention semantics?

So, that's what I did.  For some of you, I've gone to "the dark side":

 * converted my whole atom feed to Markdown (CommonMark, actually)
 * used an extension to encode "metadata"
 * converted the whole thing to semantic-hybridized HTML articles
 * extracted triples to store in a triple repository
 * built a Python Flask web application driven by SPARQL queries to find and display content

It is based on the idea of semantic data lakes.  But, I have so little "data", it is more like a pond.  A pond with ducks paddling around in it that I feed every so often.

You can see my new project on Github ([duckpond](https://github.com/alexmilowski/duckpond)).

What can I say other than:

>So long and thanks for all the markup!
