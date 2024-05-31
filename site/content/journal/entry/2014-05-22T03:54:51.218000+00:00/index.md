---
title: "XProclet Released"
date: "2014-05-22T03:54:51.218000Z"
url: "/journal/entry/2014-05-22T03:54:51.218000+00:00/"
params:
  author: Alex Miłowski
keywords:
  - XProc
  - Restlet
  - web
  - github
---


# XProclet Released

## What is it?

XProclet lets you build Web applications with XProc with help from Restlet.

I've been building Web application using Restlet for many years. It is a great toolkit that allows you to build services and just run them. That means you don't need to setup complicated J2EE servers if you don't really need to do so.

Along the way, I decided to refactor my [Atomojo project ](http://code.google.com/p/atomojo/) to utilize both Restlet better and to use [MarkLogic](http://www.marklogic.com/) . At a certain point, I had almost completed refactored a core server that allowed simple configuration of services via an XML document and, within that document, the configuration of XProc as service implementations.

It was a bit messy and dependent on too many things within the Atomojo project. I recently cleaned it up, refactored it a bit, and put it up on Github!



## The Lowdown

  * XProclet is a full Web server that relies on Restlet.  You can use any server implementation from Restlet that you desire but I package the Jetty embedded server.


  * You can run XProc directly by just associated a URI path with your XProc pipeline:

```

<route match="/make-it-go" ref="xproc">
   <parameter name="xproc.href" href="go.xpl"/>
</route>

```

  * If you want to get more complicated and handle different methods with different pipelines, you can:

```

<route match="/" ref="xproclet">
   <attribute name="xproc.configuration">
      <xproc:method name="HEAD" href="head.xpl" bind-output="true"/>
      <xproc:method name="GET" href="get.xpl"/>
      <xproc:method name="PUT" href="echo.xpl"/>
      <xproc:method name="POST" href="echo.xpl"/>
   </attribute>
</route>               

```

  * You can do all the things you normally would with the server: host content, route requests, redirects, etc.


  * It is really easy to write Restlet code and have it run side-by-side with your XProc.


  * You can take full advantage of Restlet's router, guard, filter, and resource architecture but with an XML syntax.





## Get it on Github

The project is at [alexmilowski / xproclet](https://github.com/alexmilowski/xproclet) .

The current release is [version 1.0.m1 (milestone 1) ](https://github.com/alexmilowski/xproclet/releases/tag/v1.0.m1) (m1 = I got off my keister and released the code).

I also tried to document all the basics in the [wiki](https://github.com/alexmilowski/xproclet/wiki) so you can get started.



## Where is it used?

I use it.  Just me, so far ...

I use it for this website, for my AtomPub implementation that runs this website, and for my research with [mesonet.info](http://www.mesonet.info/) . I've burned it in for quite awhile now (years) and it seems to work reasonably well.



## What's Next?

There is more behaviour to document:

  1. There is support for authentication via OpenID and Google's ClientLogin
  1. There is a whole package for managing identities, authentication tokens (OAuth2), and the like.
  1. There is an AtomPub implementation that stores content on [MarkLogic](http://www.marklogic.com/) .

Try it out and tell me what you think.

