---
title: "WebKit MathML is Progressing"
date: "2010-03-11T01:27:28-05:00"
url: "/journal/entry/2010-03-11T01:27:28-05:00/"
params:
  author: Alex Miłowski
keywords: []
---


# WebKit MathML is Progressing

I've been able to make some progress getting MathML into the trunk of [WebKit](http://www.webkit.org/) .  You can see from the [master MathML Bug](https://bugs.webkit.org/show_bug.cgi?id=3251) that there are only a few patches that aren't in the trunk.  In fact, [33703](https://bugs.webkit.org/show_bug.cgi?id=33703) doesn't count because it is a union of other patches for others who want to play and is now almost obsolete.

Just [`mfrac` ](https://bugs.webkit.org/show_bug.cgi?id=34741) , `mroot` , and `msqrt` to go and we'll have a some basic MathML that is usable.  There is, of course, quite a bit more to do.

