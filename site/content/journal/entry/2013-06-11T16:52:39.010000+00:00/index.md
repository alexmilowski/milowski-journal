---
title: "Microdata in Green Turtle"
date: "2013-06-11T16:52:39.010000Z"
url: "/journal/entry/2013-06-11T16:52:39.010000+00:00/"
params:
  author: Alex Miłowski
keywords:
  - RDFa
  - Microdata
  - Green Turtle
---

# Microdata in Green Turtle

After being asked how hard it would be to add [Microdata](http://dev.w3.org/html5/md-LC/) , at least in some minimal way, to [Green Turtle](https://code.google.com/p/green-turtle/) I decided to find out.  Since I already have a bunch of infrastructure, this didn't feel like a hard thing to add.  If I did add support, at least experimentally, microdata and RDFa could use the same API and scripting support.

Of course, this requires understanding how to interpret microdata and generate a triples graph from it.  There are some pathological cases, such as untyped items, that are just impossible.  For example:

```
<div itemscope>
<p itemprop="name">Alex Milowski</p>
</div>

```
Is it someone's attempt at encoding a person?  Does it have any interchange semantics over the Web?  Probably not and so I just ignore things that don't map easily.

Meanwhile, properly encoded [schema.org](http://www.schema.org) items should map quite well.  In the context of a schema.org item type, the property names map in a uniform way and the triples graph is easy to generate.  Other well structured namespaces will map as well (e.g. those with hash names or URI structured the same as schema.org).

Let's get down to the details:

  * You can do this right now with [Green Turtle 1.0](https://code.google.com/p/green-turtle/) .
  * I've implemented an experimental processor.
  * You can use that right now too!

Here's how:

  * Until I package this implementation somehow, you'll need to include three Javascript files: [URI.js](https://green-turtle.googlecode.com/svn/trunk/src/URI.js) , [RDFaGraph.js](https://green-turtle.googlecode.com/svn/trunk/src/RDFaGraph.js) , and [Microdata.js](https://green-turtle.googlecode.com/svn/trunk/src/Microdata.js)
  * Register a processor with Green Turtle for Microdata: ```
<script type="text/javascript">
GreenTurtle.implementation.processors["microdata"] = {
   process: function(node,options) {
      var owner = node.nodeType==Node.DOCUMENT_NODE ? node : node.ownerDocument;
      if (!owner.data) {
         return false;
      }
      var processor = new GraphMicrodataProcessor(owner.data.graph);
      processor.process(node);
      return true;
   }
};
</script>

```


That's it!  The Green Turtle runs after the document has loaded and so any registered processors will run against the document.  In this example, the Microdata triples are merged into the same graph as the RDFa.  Beware, there be dragons here!

An example of the above is [available here](https://code.google.com/p/green-turtle/source/browse/trunk/tests/microdata.html) .

Now, the question remains as to what I should do with this.  I'm not a huge fan of Microdata but embracing users of Microdata and giving them a way to co-exist or transition to RDFa feels like a good idea.

The questions that need to be answered are:

  * Do I integrate this into Green Turtle as a standard feature?
  * Should it be enabled by default?
  * If I don't integrated it, how should it be packaged for ease of use?

It is important to understand that there is code being duplicated.  Both `URI.js` and `RDFaGraph.js` are already packaged with Green Turtle but they are hidden from general use as to not clutter the global namespace.  As such, you unfortunately need to include them again.  As such, something needs to be done to make this easy to distribute.

