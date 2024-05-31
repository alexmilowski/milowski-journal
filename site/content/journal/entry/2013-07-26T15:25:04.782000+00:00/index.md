---
title: "Green Turtle - Injection and Microdata Options"
date: "2013-07-26T15:25:04.782000Z"
url: "/journal/entry/2013-07-26T15:25:04.782000+00:00/"
params:
  author: Alex Miłowski
keywords:
  - Green Turtle
  - RDFa
  - Microdata
  - Chrome Extension
---

# Green Turtle - Injection and Microdata Options

I've just released version 1.2 of [Green Turtle](https://code.google.com/p/green-turtle/) and its [Chrome extension](https://chrome.google.com/webstore/detail/green-turtle-rdfa/loggcajcfkpdeoaeihclldihfefijjam) .  While there are minor bug fixes, there are three new features:

  * The way that the script on the Web page and the extension talk to each other has been greatly improved.  By doing so, I got rid of a hack where it used a meta element to pass triples to the extension.  The new method has the additional benefit of supporting other extensions--possibly in other browsers--with the same technique.


  * Microdata packaging and option.


  * Script injection.



#### Microdata Packaging

A packaging of Microdata has been added to both the script and the extension.  The experimental Microdata processor is now included with Green Turtle and can be enabled via a simple switch:

```

<script type="text/javascript">
GreenTurtle.implementation.processors["microdata"].enabled = true;
</script>

```
Including the above script just after the Green Turtle script will turn on Microdata support (off by default).  You can also disable [Turtle](http://www.w3.org/TR/turtle/) processing much the same way (on by default):

```

<script type="text/javascript">
GreenTurtle.implementation.processors["text/turtle"].enabled = false;
</script>

```
Any Microdata is turned into triples and added the the graph along with any RDFa or Turtle found in the document.  If the Microdata can't be turned into triples, it is just ignored.  It would be really nice if there was a specification for this but there really isn't as of yet.

Microdata is also packaged with the extension and is off by default.  You can enable this feature in the extension options page.

#### Injection

The other big new feature is injection of the processor into documents that don't already have Green Turtle.  When the extension detects a Web page that does not have Green Turtle, it will inject the script from a version stored in the extension.  The result is that `document.data` and all the APIs are available from the console.  This will enable you to do additional experimentation in the console or for other extensions to use the graph data.

This also provides a more efficient means for handling large documents.  This feature is on by default but you can turn it off in the extension options page.  If you turn it off, it will still try to harvest triples but they won't be available from the console.

#### Extension Options

The extension now has an options page.  Just go to the  “Extensions” menu item in Chrome and click on the  “Options” link next to Green Turtle.  Checking  “Enable Microdata” will automatically enable Microdata for all injected scripts.  There is also a control for turning off script injection.

