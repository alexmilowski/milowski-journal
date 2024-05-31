---
title: "Unified Content Descriptors"
date: "2013-05-06T20:42:15.965000Z"
url: "/journal/entry/2013-05-06T20:42:15.965000+00:00/"
params:
  author: Alex Miłowski
keywords:
  - RDFa
  - IVOA
  - Astronomy
  - schema.org
---

# Unified Content Descriptors

The [International Virtual Observatory Alliance (IVOA)](http://www.ivoa.net/) is an organization that helps set the technology standards used by Astronomers on the Web to exchange information.  One interesting aspect of astronomical data is that how the data was collected is as important as the particular measurements or images of specific targets.  As such, when information is exchanged, semantics about what particular columns of data actual mean and how they related to each other (e.g. an error estimate for another column) is very important.

The promise of Semantic Web technologies has been that we can encode these semantics but the idea that we will encode all specifics into URIs, especially when some future combinations are unknown, is a daunting task.  What are the standards, conventions, and naming idioms that we will use to accomplish that?  How will we entice people to use this URIs and will they be convenient enough that they won't develop their own?

The IVOA has an interesting take on this coding problem called [Unified Content Descriptors (UCD)](http://www.ivoa.net/documents/REC/UCD/UCD-20050812.html) which has some interesting features.  First, there is always a base value: are we measuring photometric magnitude, statistical error, angular momentum, the time observed, or is this just a value like a URI?

Second, semantics are conveyed by a combination of  “words” : photometric magnitude + statistical error = the statistical error for the measured photometric magnitude.  In general, a UCD is a sequence of words that are used to build up a concept.

Third, words are build from  “atoms” that are universally accepted.  Thus, when words are created  “em” always means  “Electromagnetic Spectrum” and  “dec” is always  “declination” .  This brings some consistency to the construction of words.

### UCD Syntax

The rules are simple:

  * Atoms are simple short tokens, hyphens are discourage, and periods and semicolons are avoided.
  * Words are formed from atoms that are separated by periods.
  * Words start with the most general and proceed left-to-right to the more specific.
  * A UCD is a sequence of words separated by semicolons.
  * A UCD always starts with a primary word that represents the base value (e.g. a photometric magnitude reading or a statistical error quantity).

For example, the measurement of magnitude in the J band is the UCD `photo.mag;em.IR.J` while the statistical error for that measurement is `stat.error;photo.mag;em.IR.J` .

Of course, this works for the IVOA community because they decide on the atoms and words in advance and they have a process for continuously modifying that list.  You can see the [current list online](http://www.ivoa.net/documents/REC/UCD/UCDlist-20070402.html) and they have a [wiki](http://wiki.ivoa.net/twiki/bin/view/IVOA/IvoaUCD) that describes the whole process.

### Application to RDFa

What I want to consider is how this useful and successful concept of a UCD can be used by RDFa vocabularies.  Specifically, how do we embed these into URIs and still retain the flexibility they represent for recombining known words into new content descriptions.

Fortunately, according to [RFC 2396, Uniform Resource Identifiers (URI): Generic Syntax, §3.3 Path Component](http://tools.ietf.org/html/rfc2396#section-3.3) , UCDs are completely valid in a path segment.  The primary word becomes the segment and each subsequence word become parameters.  In my thinking, that works quite well for me because they really are parameters to the base value represented by the primary word.

That means the IVOA could easily encode each UCD into a URI just by prefixing with a known URI:

```

http://www.ivoa.net/ucd/photo.mag;em.IR.J
http//www.ivoa.net/ucd/stat.error;photo.mag;em.IR.J

```
From an RFDa usage perspective, I want to take this into other application domains.  So, my next question is essentially: how would this idea change or solve problems in existing vocabularies like [schema.org](http://schema.org/) ?

