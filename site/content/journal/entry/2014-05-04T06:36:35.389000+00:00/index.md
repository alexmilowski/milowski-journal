---
title: "XProc to the Rescue: Restoring AtomPub"
date: "2014-05-04T06:36:35.389000Z"
url: "/journal/entry/2014-05-04T06:36:35.389000+00:00/"
params:
  author: Alex Miłowski
keywords:
  - XProc
  - atom
  - atompub
---

# XProc to the Rescue: Restoring AtomPub

## Restoring AtomPub via XProc

My website is driven by a set of Atom feeds that are organized by categorization.  Yes, I know, so old school.

I recently setup a new [MarkLogic](http://www.marklogic.com/) server and I needed to transition to it for my various research projects as well as my website. As it happens, my website is more complicated than my research simply because my research data is designed to be reloadble.  In my research, I've strived to achive idempotent data operation so I can simple just setup the new server, replay content events, and all will be well.

My website isn't quite so well organized and when things actually happened (i.e. when I wrote them) matters. The good news is, if you look at [AtomPub](https://tools.ietf.org/html/rfc5023) in the right way, you get idempontent operations. In theory, since I wrote my  [AtomPub](https://code.google.com/atomojo/) implementation, it should exhibit some of the desired behaviors.

### Tyrany of the Band of One

I wrote the AtomPub implemention and so I also wrote the backup and restore procedures.  Backup works great and restore kinda stinks. That's the tyrany of being a sole developer on something: when you write code that stinks, no one complains.

I struggled to bring my mind back several years as to why I approached the problem in that way. I fixed a few bugs in the AtomPub implementation but, still, it seemed like there should be a better way. I also wrote it all in Java and that can't be the best way to manipulate XML.

There is something else out there.  Something that might be better and I might know something about.



### Beating a Dead Horse or XProc?

I re-wrote the restore process in XProc and it essentially has to do the following:

  * Load the service document from the target AtomPub to understand what workspace the collections are being created within.
  * Traverse the service document for the source AtomPub (or backup) and for each collection:   * Create the collection.
  * Create an entry for each entry found in the source collection.



The XProc looks like this:

```

<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
    xmlns:app="http://www.w3.org/2007/app" xmlns:atom="http://www.w3.org/2005/Atom"
   name="restore">
   <p:input port="source" primary="true"/>
   <p:output port="result" primary="true"/>
   <p:option name="target"/>
   <p:option name="token"/>
   <!-- get the target service document -->
   <p:template>
      <p:with-param name="token" select="$token"/>
      <p:with-param name="target" select="$target"/>
      <p:input port="source"><p:empty/></p:input>
      <p:input port="template">
         <p:inline>
            <c:request method="GET" href="{$target}">
               <c:header name="Authorization" value="Bearer {$token}"/>
            </c:request>
         </p:inline>
      </p:input>
   </p:template>
   <p:http-request/>

   <p:group>
      <!-- get the URI for creating collections -->
      <p:variable name="target-collections" select="resolve-uri(/app:service/app:workspace/@href,$target)"/>

      <!-- viewport over the collections in the source service -->
      <p:viewport match="app:collection">
         <p:viewport-source>
            <p:pipe step="restore" port="source"/>
         </p:viewport-source>
         <p:variable name="slug" select="substring-after(substring-before(/app:collection/@href,'/__index__.atom'),'/')"/>
         <p:load>
            <p:with-option name="href" select="resolve-uri(/app:collection/@href,base-uri(/app:collection))"/>
         </p:load>
         <p:xslt>
            <p:input port="stylesheet"><p:document href="restore.xsl"/></p:input>
            <p:with-param name="target-collections" select="$target-collections"/>
            <p:with-param name="collection" select="$target-collections"/>
            <p:with-param name="slug" select="$slug"/>
            <p:with-param name="token" select="$token"/>
         </p:xslt>
         <p:viewport match="c:request">
            <p:http-request/>
         </p:viewport>
      </p:viewport>
   </p:group>
</p:declare-step>         

```
The referenced XSLT is fairly simple:

```

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="xs"
   version="2.0"
   xmlns:c="http://www.w3.org/ns/xproc-step"
   xmlns:app="http://www.w3.org/2007/app"
   xmlns:atom="http://www.w3.org/2005/Atom">

<xsl:param name="target-collections"/>
<xsl:param name="token"/>
<xsl:param name="slug"/>

<xsl:template match="atom:feed">
   <atom:feed>
   <c:request method="POST" href="{$target-collections}" status-only="true" detailed="true">
      <c:header name="Authorization" value="Bearer {$token}"/>
      <c:header name="Slug" value="{$slug}"/>
      <c:body content-type="application/atomsvc+xml">
         <app:collection>
            <xsl:copy-of select="atom:title|atom:category"/>
         </app:collection>
      </c:body>
   </c:request>
   <xsl:apply-templates select="atom:entry"/>
   </atom:feed>
</xsl:template>

<xsl:template match="atom:entry">
   <c:request method="POST" href="{$target-collections}{$slug}/" status-only="true" detailed="true">
      <c:header name="Authorization" value="Bearer {$token}"/>
      <c:body content-type="application/atom+xml">
         <xsl:copy>
            <xsl:apply-templates/>
         </xsl:copy>
      </c:body>
   </c:request>
</xsl:template>

<xsl:template match="atom:link[@rel='edit']|atom:link[@rel='edit-media']"/>

<xsl:template match="node()|@*">
   <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
   </xsl:copy>
</xsl:template>

</xsl:stylesheet>         

```


### Why?

You might look at this and think: "Why all the complexity?"  The Java code was worse.  In fact, any programming langauge code would be worse. XProc is really good at doing this kind of thing.

If it wasn't still Saturday night, I might do a better job explaining why.

