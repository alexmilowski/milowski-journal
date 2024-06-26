---
title: "Bad Choices in Forwards Compatibility within IE"
date: "2011-12-07T11:05:46.242000-08:00"
url: "/journal/entry/2011-12-07T11:05:46.242000-08:00/"
params:
  author: Alex Miłowski
keywords:
  - html5
  - IE
  - web
---


# Bad Choices in Forwards Compatibility within IE



In the final throws of working on this website update, I had to go and test on different versions of IE.  I knew a lot of things were not going to work in anything before IE (Internet Explorer) 9.  Nevertheless, I needed something to show up for the poor folks still using a broken browser.

After fussing a bit with a post-process filter in Restlet, I adjusted the website to switch to the media type `text/html` when it detects any version of IE before 9.  The theory was that I could squeak by and deliver hacked up XHTML to IE and get something to render.  That theory was quite wrong.

See, folks, I use a variety of modern browsers (Chrome, Safari, Firefox), on a variety of operating systems (OS X, Android, iOS), on a variety of platforms (Mac, iPhone/iPod, Android Phones, Nook Tablets).  Everything works the way I expect it except on Windows with IE.  I knew that and I avoid bastardizing my projects just to make IE work.

The engineers that made IE made what I believe to be the worse decision in forwards compatibility I could imagine for any system that processes markup.  Instead of just ignoring tags it doesn't understand, it automatically closes them and makes the child a sibling.  This completely destroys any kind of forwards compability as the DOM used by the browser is now enormously different than expected.

For example, in my pages I use the HTML5 article structure.  Whenever an `article` , `section` , or other such HTML5 elements occurs, such as:

```

<article>
<h1>Test Article</h1>
<section>
<h2>Overview</h2>
<p>In the beginning ...

```
in IE 8 or previous versions, you'll get:

```

<article/>
<h1>Test Article</h1>
<section/>
<h2>Overview</h2>
<p>In the beginning ...

```
As the containers are gone, the stylesheets won't work properly, and everything looks funny.

