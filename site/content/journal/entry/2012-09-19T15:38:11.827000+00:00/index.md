---
title: "RDFa in the Browser"
date: "2012-09-19T15:38:11.827000Z"
url: "/journal/entry/2012-09-19T15:38:11.827000+00:00/"
params:
  author: Alex Miłowski
keywords:
  - RDFa
  - browser
---


# RDFa in the Browser

While there is a lot talk about how [RDFa](http://www.w3.org/TR/rdfa-core/) is or will be used by search engines and others for indexing, my main focus has been on how authors can use RDFa to encode  “local knowledge.” Services that are local to the page, most often implemented by inclusion of some script, act upon such local knowledge that is encoded somewhere in the page.  In the past, people used the `class` or `id` attributes to identify the targeted content and then some amount of scripting made the rest of the connections.

I'm interested in using RDFa in this role of encoding local knowledge.  Once the author has made annotations using RDFa, a well-written service can just be included by referencing a script that acts upon the page by locating elements with certain type annotations.  An example of this is my post about [<cite>Using RDFa to Annotate Images</cite>](http://www.milowski.com/journal/entry/2012-05-24T09:17:12.327-07:00/) where images are overlaid with annotations drawn by inserting a canvas layer into the document.

The recent 0.19 release of [Green Turtle](http://code.google.com/p/green-turtle/) provides the [RDFa API](http://www.w3.org/TR/rdfa-api/) and extensions that make building these services much easier.  At the core is an RDFa 1.1 compliant processor that produces the underlying triples, stores them as a graph, and has back-pointers to their origins from the document.  With the RDFa API, you can use that API to go back and forth between the RDF graph and the document.




## Using Green Turtle

Using [Green Turtle](http://code.google.com/p/green-turtle/) to provide the [RDFa API](http://www.w3.org/TR/rdfa-api/) to your web page is as simple as just including a script.  The main script is available for [download](http://green-turtle.googlecode.com/files/RDFa.min.0.19.0.js) from the project page.  Once you've included the script, it will automatically attach itself to your HTML/XHTML web page.  After RDFa processing has completed, the triples are available to any local application.

Once the processing has completed, any script can access the triples.  For example, if you want to find specific elements by the `typeof` annotation used, you would write:

```

var elements = document.getElementsByType("http://example.org/mytype")

```
and the `elements` variable now holds an array of elements from the document that were annotated with the type URI `http://example.org/mytype` .




## RDFa in Action

It is quite simple to type links using RDFa by adding a `typeof` attribute to a anchor element:

```

<a href="http://www.milowski.com/#alex" typeof="http://example.org/Person/ref">Alex Milowski</a>

```
and elsewhere you can describe that link:

```

<div resource="http://www.milowski.com/#alex" typeof="Person" vocab="http://schema.org/">
<span property="email">alex@milowski.com</span>,
<span property="alumniOf">University of Minnesota</span>,
<span property="alumniOf">San Francisco State University</span>,
<span property="affiliation">University of Edinburgh</span>
</div>

```
And then you can make it do something:

using the following script:

```

var link = document.getElementsByType("http://example.org/Person/ref")[0];
var alumniOf = document.data.getValues(link.href,"http://schema.org/alumniOf");
var affiliation = document.data.getValues(link.href,"http://schema.org/affiliation");
link.onclick = function() {
    alert("Currently at "+affiliation+", alumni of "+alumniOf);
    return false;
}

```
<div resource="http://www.milowski.com/#alex" style="display: none" typeof="Person" vocab="http://schema.org/">
<span property="email">alex@milowski.com</span>,
<span property="alumniOf">University of Minnesota</span>,
<span property="alumniOf">San Francisco State University</span>,
<span property="affiliation">University of Edinburgh</span>
</div><script type="text/javascript">
document.addEventListener(
      &quot;rdfa.loaded&quot;,
      function() {
         var link = document.getElementsByType(&quot;http://example.org/Person/ref&quot;)[0];
         var alumniOf = document.data.getValues(link.href,&quot;http://schema.org/alumniOf&quot;);
         var affiliation = document.data.getValues(link.href,&quot;http://schema.org/affiliation&quot;);
         link.onclick = function() {
            alert(&quot;Currently at &quot;+affiliation+&quot;, alumni of &quot;+alumniOf);
            return false;
         }
      },
      false
    );
</script>

## Extensions

The [RDFa API](http://www.w3.org/TR/rdfa-api/) is only a working group note.  As such, there is still debate about what it should and shouldn't contain. Meanwhile, Green Turtle provides a number of useful extensions that are documented on the [project page](http://code.google.com/p/green-turtle/) .

Notably, every element that is a subject origin (e.g. something with an `about` , `typeof` , or `resource` attribute) has a property called data.  This property provides the subject URI and types:

  1. `element.data.id` - the subject URI.
  1. `element.data.types` - an array of type URIs.

This becomes very useful to find the subject URI when you retrieve an element by type:

```

document.getElementsByType("http://example.org/mytype")[0].data.id

```
Another useful extension is the ability to get descendant elements by type.  Often, once you've located an element, you may want to find a descendant of a specific type.  The `Element.getElementsByType(uri)` method takes a type URI and finds all descendant elements which have been annotated with a `typeof` attribute with that specific value.

Again, all of these extensions are documented on the [project page](http://code.google.com/p/green-turtle/) .

## Using the RDFa Processor Directly

Some users may want to harvest the triples for their own purposes without using the RDFa API.  There is [another packaging](http://green-turtle.googlecode.com/files/RDFaProcessor.min.0.19.0.js) of Green Turtle for this purpose.  A simple callback processor can be created by extending the `RDFaProcessor` class:

```

CallbackProcessor.prototype = new RDFaProcessor();
CallbackProcessor.prototype.constructor=RDFaProcessor;
function CallbackProcessor() {
   RDFaProcessor.call(this);
}

CallbackProcessor.prototype.newSubjectOrigin = function(origin,subject) {
   console.log("New origin for "+subject);
}

CallbackProcessor.prototype.addTriple = function(origin,subject,predicate,object) {
   console.log("New triple: "+subject+", predicate "+predicate+
               ", object "+object.value+", "+object.language+", "+object.type);
}

```
## Tricky Bits: Timing, Changes, and Other Documents

When you include the script, by default it will process the current document and at some point, shortly after the document has completely loaded, the RDFa processing will be completed.  This is the consequence of the browser not having a native implementation of RDFa.  As a result, if you have other scripts that want to consume RDFa and also act when the document has loaded, you have a timing problem.

Green Turtle provides a `rdfa.loaded` event that can be used to detect when the RDFa processing is complete after document loading has completed.  The use of the event is straight forward:

```

document.addEventListener(
   "rdfa.loaded",
   function() {
      // your stuff here
   },
   false
);

```
Also, currently Green Turtle doesn't track changes to the document.  If you update the document locally, you'll need to re-process the document to update the RDF graph.  This is a simple call:

```

RDFa.attach(document,true);

```
The second argument of true tells the processor that it needs to update the graph.

 In general, the `RDFa.attach()` function can be used to invoke RDFa processing on any document.  If you load another document via `XMLHttpRequest` , you can harvest RDFa from that document by just calling `RDFa.attach(document)` .

