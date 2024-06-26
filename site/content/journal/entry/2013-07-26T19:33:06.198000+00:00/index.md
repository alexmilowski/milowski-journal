---
title: "Problems with Microdata"
date: "2013-07-26T19:33:06.198000Z"
url: "/journal/entry/2013-07-26T19:33:06.198000+00:00/"
params:
  author: Alex Miłowski
keywords:
  - Microdata
  - RDFa
  - schema.org
---

# Problems with Microdata

Given my recent grumbling about Google Blink developers trying to [remove XSLT](https://groups.google.com/a/chromium.org/forum/#!topic/blink-dev/zIg2KC7PyH0) from Chrome, the current state of Microdata vs [RDFa](http://www.w3.org/TR/rdfa-core/) makes me think we're creating another level of incompatibilities on the Web.  XSLT generally failed client-side on the Web due to the poor implementation within the various browsers.  At this point, of course people aren't using it en masse because it just didn't work.

Microdata and its unknown status makes me feel like we're headed for more broken, partial ideas on the Web.  We'd get proper adoption of some kind of  “Semantic Web Annotation”  if there was one syntax that everyone was using.  Yet, the [schema.org](http://schema.org/) folks (Google et. al.) keep pushing Microdata.  I'd personally prefer [RDFa](http://www.w3.org/TR/rdfa-core/) .

It is remarkable that while the W3C members seem to have chosen to only have one specification ( [RDFa!](http://www.w3.org/TR/rdfa-core/) ), schema.org seems to keep chugging along with Microdata.  The status of whatever  “Microdata” really is within the W3C or on the Web is really unknown--even to people like myself who try to keep close tabs on such things.

#### What is Microdata?

Attempting to answer the question  “What exactly is Microdata?” only leads to more questions.  First, which specification are we going to use: [the 24 May 2011 draft](http://dev.w3.org/html5/md-LC/) linked to from the schema.org page, the [latest draft dated 25 Oct 2012 ](http://www.w3.org/TR/microdata/) ,  or the [WhatWG draft ](http://www.whatwg.org/specs/web-apps/current-work/multipage/microdata.html) that can change randomly?

The real problem is that this specification is in limbo as it has been derailed from a   “recommendation track” document.  Essentially, there was [push back](http://lists.w3.org/Archives/Public/public-html-comments/2012Nov/) , some very well thought out arguments against Microdata (e.g. by [Manu Sporny](http://manu.sporny.org/2012/microdata-cr/) ), and a task force for some kind of unification or co-existence (read [Jeni Tennison's blog post](http://www.jenitennison.com/blog/node/165) about this).

There's a lot of passion packed into this debate and, yet, after all this time, nothing has really changed that much.  It is unclear what the status of Microdata is at the [W3C](http://www.w3.org/) and schema.org just plugs on ahead assuming that we all know and want this thing called Microdata.

#### My Problems with Microdata

While I have huge issues with the process that has led us into this mess, as the implementer of [Green Turtle](http://code.google.com/p/green-turtle/) , I have many technical issues when it comes to implementing Microdata (assuming I can pick a spec against which to implement):

  * *Lack of a default vocabulary mechanism.* Inferring property value URIs from an overt type (e.g. the `itemtype` attribute) feels like a pure hack.  It works in closed type systems like schema.org but it doesn't in general.   RDFa has the `vocab` attribute that allows an author to declare a default.  That feels like a missing feature for Microdata.
  * *Items without types?* What's the point of having an untyped item?  It isn't useful to schema.org nor to any other comparable use.  All a processor knows is that there is an item with some properties whose unique names can't be determined.  Of course, this is the red herring of Microdata: oh look, all you really need is a itemscope attribute (unless you want to do something useful and then you need an itemtype attribute too).
  * *No Shorthand Mechanism.* Prefixes and default vocabularies are  “ugly” until you have real data with very verbose type and property URIs mixed from different real-world vocabularies.  At that point, prefixes to shorten URIs (e.g. [CURIEs](http://www.w3.org/TR/curie/) ) seem like a really nice feature.
  * *No Tests!!!* A specification without tests guarantees interoperability problems.  There are no well-defined, publicly available, and agreed upon tests for Microdata.  That's a real problem.
  * *No defined Semantic Web mapping.* If Microdata is to exist on the Web, it really needs to play well with others.  Specifically, as it is adding semantic annotations to Web pages, it needs to have a well-defined mapping into triples and the Semantic Web.  That's a real problem for Microdata because you can annotate items without ever giving a context for identifying the vocabulary.  The result is that some Microdata maps to triples well and some does not without a great deal of assumptions.

I could go on but I'll stop there.

#### Clean Up Your Mess!

Bing, Google, Yahoo, and Yandex ran on ahead with Microdata on schema.org.  Because Google is there (and possibly the others too), everyone just assumes Microdata has some legitimacy.  Maybe it does or maybe it is a disaster.

I have one thing to say: clean up your mess!  If my 8 year old son spills his milk, he gets a towel (sometimes at my suggestion) and cleans up his mess.  Google et. al. has spilled the trash can of partially-abandoned specifications onto the Web and they need to get a towel and clean it up. 

