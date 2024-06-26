---
title: "XProc on My Website"
date: "2011-12-06T17:15:29.944000-08:00"
url: "/journal/entry/2011-12-06T17:15:29.944000-08:00/"
params:
  author: Alex Miłowski
keywords:
  - XProc
  - atomojo
  - restlet
  - MarkLogic
---

# XProc on My Website

I've migrated my whole website to run on a combination of [XProc](http://www.w3.org/TR/XProc) , [Restlet](http://www.restlet.org) , and the new [Atomojo V2](http://code.google.com/p/atomojo) server.  Atomojo V2 provides an Atom APP backend powered by XProc and [MarkLogic](http://www.marklogic.com) glued together using Restlet.  The same archictecture has been use to deploy this website.  That is, almost all the pages are the result of running some XProc-enabled process.

Over the next few weeks I'll be detailing how this whole system works.  I'll start with some simple examples.  In the end, I hope I'll have convinced you that XProc makes my life easier.  If not, well, you can walk away thinking: "I hope he thinks so!"

