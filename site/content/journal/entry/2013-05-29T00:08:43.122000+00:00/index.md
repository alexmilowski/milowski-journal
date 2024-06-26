---
title: "Green Turtle 1.0 Released!"
date: "2013-05-29T00:08:43.122000Z"
url: "/journal/entry/2013-05-29T00:08:43.122000+00:00/"
params:
  author: Alex Miłowski
keywords:
  - RDFa
  - JavaScript
  - Turtle
  - Green Turtle
---

# Green Turtle 1.0 Released!

I've just released 1.0 of [Green Turtle](https://code.google.com/p/green-turtle/) .  My implementation now passes **all** the tests in the W3C conformance test suite for both [RDFa 1.1](http://www.w3.org/TR/rdfa-core/) and [Turtle](http://www.w3.org/TR/turtle/) .

There is also a great new feature that integrates Turtle handling directly into the API and allows for automatic processing of embedded Turtle.  This allows data providers to use RDFa or [embedded Turtle](http://www.w3.org/TR/turtle/#in-html) directly in their documents and Green Turtle will do the right thing!

Also, this release supports RDFa in HTML as specified in the [latest draft](http://www.w3.org/TR/html-rdfa/) and passes all the relevant tests for that processing mode.

Finally, [the API](https://code.google.com/p/green-turtle/wiki/MicroAPI) has been adjusted to allow direct access to representation parsers (e.g. Turtle).  This feature allows a developer to retrieve or construct triples via a representation like Turtle and then merge them into the current document's data.  As such, all the nice features of the RDFa API are available to the developer for Turtle as well.

