---
title: "Refactoring the RDFa API - Getting the Data"
date: "2013-03-12T06:08:53.199000Z"
url: "/journal/entry/2013-03-12T06:08:53.199000+00:00/"
params:
  author: Alex Miłowski
keywords:
  - RDFa
  - JavaScript
  - RDFa API
---


# Refactoring the RDFa API - Getting the Data

After numerous inquires about my opinion on making the [RDFa API](http://www.w3.org/TR/rdfa-api/) simpler, I decided to do a bit of research. I've written several fairly complex *in-situ* services that use the RDFa API to provide functionality within the browser. As such, I decided to look at which parts of the RDFa API or the extensions that [Green Turtle ](https://code.google.com/p/green-turtle/) provides are actually used.

I went through all my code and unceremonious counted all the different bits of RDFa related API calls I make. Here is the breakdown:

<table>
         <thead>
	    <tr>
	      <th colspan="1" nowrap="none" rowspan="1">Count</th>
	      <th colspan="1" nowrap="none" rowspan="1">API</th>
	      <th colspan="1" nowrap="none" rowspan="1">Description</th>
	    </tr>
	  </thead>
         <tbody>
	    <tr>
	      <td colspan="1" nowrap="none" rowspan="1">64</td>
	      <td colspan="1" nowrap="none" rowspan="1"><code>document.data.getValues()</code></td>
	      <td colspan="1" nowrap="none" rowspan="1">Values given a subject and property URI.</td>
	    </tr>
	    <tr>
	      <td colspan="1" nowrap="none" rowspan="1">15</td>
	      <td colspan="1" nowrap="none" rowspan="1"><code>element.data.id</code></td>
	      <td colspan="1" nowrap="none" rowspan="1">(*) The subject URI for an
                  element.</td>
	    </tr>
	    <tr>
	      <td colspan="1" nowrap="none" rowspan="1">10</td>
	      <td colspan="1" nowrap="none" rowspan="1"><code>document.getElementsByType()</code></td>
	      <td colspan="1" nowrap="none" rowspan="1">Elements typed with a specific URI.</td>
	    </tr>
	    <tr>
	      <td colspan="1" nowrap="none" rowspan="1">6</td>
	      <td colspan="1" nowrap="none" rowspan="1"><code>document.getElementsBySubject()</code></td>
	      <td colspan="1" nowrap="none" rowspan="1">Elements identified by a specific subject.</td>
	    </tr>
	    <tr>
	      <td colspan="1" nowrap="none" rowspan="1">4</td>
	      <td colspan="1" nowrap="none" rowspan="1"><code>document.data.getSubjects()</code></td>
	      <td colspan="1" nowrap="none" rowspan="1">Subjects matching a given property and value.</td>
	    </tr>
	    <tr>
	      <td colspan="1" nowrap="none" rowspan="1">3</td>
	      <td colspan="1" nowrap="none" rowspan="1"><code>element.getElementsByType()</code></td>
	      <td colspan="1" nowrap="none" rowspan="1">(*) Descendants typed with a specific
                  URI.</td>
	    </tr>
	    <tr>
	      <td colspan="1" nowrap="none" rowspan="1">2</td>
	      <td colspan="1" nowrap="none" rowspan="1"><code>element.data.getValueOrigins()</code></td>
	      <td colspan="1" nowrap="none" rowspan="1">(*) Element origins of specific
                  property values.</td>
	    </tr>
	    <tr>
	      <td colspan="1" nowrap="none" rowspan="1">1</td>
	      <td colspan="1" nowrap="none" rowspan="1"><code>element.getElementsBySubject()</code></td>
	      <td colspan="1" nowrap="none" rowspan="1">(*) Descendants with a specific
                  subject.</td>
	    </tr>
	    <tr>
	      <td colspan="1" nowrap="none" rowspan="1">1</td>
	      <td colspan="1" nowrap="none" rowspan="1"><code>element.getFirstElementByType()</code></td>
	      <td colspan="1" nowrap="none" rowspan="1">(*) First descendant typed with a
                  specific URI.</td>
	    </tr>
	  </tbody>
      </table>


(*) A Green Turtle extension.

The first thing that should be noted is that Green Turtle contains a bunch of extensions. I added these because either they were useful and, often, they accomplished a task that wasn't exposed through the normal API.  Specifically, element descendant local operations aren't really covered by the current RDFa API and this can be very important when trying to find annotations to elements within a specific part of the document.

From all of this I can say a few things right away:

  * An enormous amount of work is just getting property values.  This needs to be easier and much less verbose.
  * There needs to be some parity between document and element/descendant operations. Specifically, getting elements by type or subject should be allowed at the document or element level.
  * A local data structure on elements with RDFa annotations is very useful and sometimes required.
  * On balance, so many odd little extensions isn't good.  If possible, I should probably figure out a way to not use them.

Further, in looking at the use of the RDFa API, the most common design pattern was:

  * Locate an element via `document.getElementsByType()` .
  * Get the subject URI associated with the element found in (1).
  * Poke at the annotation graph with `document.data.getValues()` .

Note that (2) is actually quite hard to do with the plain RDFa API without some kind of extension that stores the subject URI on the element.  All the information is in the RDFa implementation's graph if it is going to support  `document.getElementsBySubject()` .  Yet, while you can easily get the type from a given subject URI associated with a particular element but you can't do the reverse without knowing the internals of how the annotation graph was generated.

Making this design pattern work really well with concise code and without excluding more complex operations should be the goal of any minimal API.

