---
title: "Do Elements have URIs?"
date: "2014-06-17T02:44:55.301000Z"
url: "/journal/entry/2014-06-17T02:44:55.301000+00:00/"
params:
  author: Alex Miłowski
keywords:
  - RDFa
  - Web
  - Green Turtle
  - MarkLogic
  - XPointer
  - RDFa API
---

# Do Elements have URIs?

I was discussing a problem with triples generated from RDFa and the in-browser applications I have developed using [Green Turtle](https://github.com/alexmilowski/green-turtle)  with a learned colleague of mine whose opinions I value greatly. In short, I wanted to duplicate the kinds of processing I'm doing in the browser so I can run it through XProc and do more complicated processing of the documents. Yet, I rely on the *origin of triples*  in the document for my application to work.

His response was  “just generate a URI” and I pushed back a bit. I don't think of the origin of a triple as a thing that is easily named with a URI and I need to explain why I believe that.

Why do I care?  Because I do things with RDFa in the browser (a simple [example](http://www.milowski.com/journal/entry/2012-05-24T09:17:12.327-07:00/) and a [complicated one](http://www.mesonet.info/) ) and sometimes I want to do the same thing outside of the browser; other tools are failing me right now.

## A Bit of History

Some of you might remember [XPointer Framework ](http://www.w3.org/TR/xptr-framework/) that provided a mechanism for embedding a pointer into the fragment identifier.  In theory, you can point to specific elements [by using  “tumblers” ](http://www.w3.org/TR/xptr-element/) (e.g.,  `/1/2` is the second child of the first element) or by a [pointer](http://www.w3.org/TR/xptr-xpointer/) (i.e., an XPath expression) but you might need to deal with the complexity of whatever namespaces your document uses.  The result is something that might not be so easy to parse, cut-n-paste, or otherwise manipulate but it should work.

Yet, we really don't have XPointer functionality in browsers except possibly in relation to some minimal form necessary for [SVG's](http://www.w3.org/TR/SVG/) use of [XLink](http://www.w3.org/TR/xlink11/) .  Some of it might have to do with the complexity involved and diminishing returns.  That is, people have gotten along with naked fragment identifiers and the id attribute for quite awhile.  Others have usurped the fragment portion of the URI for other nefarious purposes (e.g., application state).



## Nothing is Free

In the browser, there is no support other than for naked fragment identifiers that map to HTML's id attribute.  We don't even have consistent `xml:id` support within the browsers.  Not to mention, there is the conflict of HTML's id attribute and xml:id when serializing as XML syntax.  Keep in mind, developers have to implement whatever we cook up and time or mind share is not on XPointer's side.

The net is that we get nothing for free and we have little to rely upon.



## Fragile Pointers

There is probably an implicit rule for the Web:

We learned that with links on the Web and gave things unique URIs.  We then we learned that we need to assign identifiers to portions of content within Web resources for similar reasons.  Extra identifiers don't hurt and they give people the ability to point at specific things in your content.  Thus, having a good scheme for a liberal sprinkling of identifiers is a good idea.

Unfortunately, thoughtful content doesn't always happen.  Some might say that it rarely happens.  As such, if you want to point to specific things and they don't have identifiers, you are out of luck.  XPointer was suppose to help solve that and you didn't get it.

But my original problem is not about linking and is instead about tracking origins  **during the processing** of the document. The [RDFa API](http://www.w3.org/TR/rdfa-api/) that Green Turtle implements provides the ability to get elements by their type or specific property values.  This allows the ability to write applications that process elements based on their type and various other annotations to go between the annotation graph of triples and the document to  “make things happen ” in the very same document.

I don't want to generate a URI, nor a pointer, and doing so feels like work around.  It is a result of a system that isn't designed to track origin or, dare I say, provenance.



## Provenance?

In my opinion, the origin of a triple isn't the common use of the term  “provenance” as used in many Semantic Web communities.  Often, provenance means the Web resource from whence the triple was generated and not the element node.  To complicate this, provenance can also mean the  “earliest known history” and so the term is very overloaded.

A triple in RDFa originates from a particular element. In a few cases (e.g.,  `typeof` attributes with more than one type), an element can generate more than one triple.  Meanwhile, in reverse, every triple from RDFa annotations has a single element node that is its origin.

Thus, I prefer  “origin” over  “provenance” so that I can avoid the overloaded and confusing use of the word provenance in both industry and research.



## Interoperability?

From any Web resource annotated with RDFa you can generate [Turtle](http://www.w3.org/TR/turtle/) or [JSON-LD](http://www.w3.org/TR/json-ld/) output that represents the triples harvested from the document. Unfortunately, we lose any information about the origin of a triple unless we generate more information.  Such additional information would need to have a URI or pointer to the element from which the triple was generated.  That brings us full circle and left holding an empty bag.

Any tool that processes the RDFa directly has this information when it harvests the triples.  Within that context, we can use that information, just like Green Turtle does, to provide the application a way to traverse between the annotation graph of triples and the document from whence they came.  Unfortunately, this seems to be a different model ftp, what many systems have implemented.

In the end, I am less concerned about interoperability, mainly because it is my tool chain that I am using to process information.  I'll use whatever tools that work and I don't intend to expose the intermediate states onto the Web.  Those might be famous last words, so I'll take some  “I told you so” tokens in advance.



## Still Searching for a Solution

I don't have a solution to do this right now.  I'm tempted to use [PhantomJS](http://phantomjs.org) or [node.js](http://nodejs.org) to run my application as if it was in the browser and then process the output with [XProc](http://www.w3.org/TR/XProc) .  This would satisfy my main use case of post-processing the results into static variants for various purposes.

I would like to put this content into [MarkLogic](http://www.marklogic.com/) and run some of the processing there, but they don't support RDFa and they don't have a notion of an origin of a triple.  It would be ideal to have this within the context of a database because the origin is a node and storing an internal reference should be straightforward (but I'm guessing).  I bet I could hack up [eXist](http://www.exist-db.org/exist/apps/homepage/index.html) and make it do this for me too.

Right now, I have too much to do.  The applications work in the browser and I'll let the dust settle for the rest of it.  Maybe I'll find a clever solution somewhere in the near future.

