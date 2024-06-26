---
title: "Experiments with Big Weather Data in MarkLogic - The Naive Approach"
date: "2012-04-11T11:08:29.620000-07:00"
url: "/journal/entry/2012-04-11T11:08:29.620000-07:00/"
params:
  author: Alex Miłowski
keywords:
  - MarkLogic
  - big data
  - weather
---


# Experiments with Big Weather Data in MarkLogic - The Naive Approach

I've heard over-and-over that [MarkLogic](http://www.marklogic.com/) is a fantastic XML database--you just import your documents and query away!  Given the quality of the people that I personally know at MarkLogic, I'm sure that's true.  Still, I wanted to put that to the test.  Every database system has techniques for getting reasonable or  “blindingly fast” performance and I wanted to see how that works and at what cost.

The process that receives the APRS weather reports from the [CWOP](http://www.wxqa.com/) produces data in five minute segments stored in separate documents and from each of the three APRS-IS servers.  Each document produced is between 130K and 430K in size and contains between 450 to 1600 weather reports.  Each hour, 36 of those documents are produced.  On average, about 17MB per hour, or 12GB per month, of data is produced.

The documents produced have the following structure:

```
<aprs xmlns="http://weather.milowski.com/V/APRS/" source="cwop.tssg.org" start="2012-04-11T16:03:29Z">
<report from="CW1367" type="weather" latitude="40.7" longitude="-74.2" 
received="2012-04-11T16:03:29Z" at="2012-04-13T17:12:00Z"
wind-dir="340" wind-speed="9" wind-gust="14"
temperature="53" rain-hour="0" rain-midnight="0" humidity="40" pressure="10090" />
...
</aprs>
```
The naive approach is to just import these documents verbatim into one large collection and setup a few basic indices:

  1. a `xs:string` index on `s:report/@from` ,
  1. a `xs:dateTime` index on `s:report/@received` ,
  1. a geospatial index on the attribute pair `s:report/@longitude` and `s:report/@latitude.`

My tool of choice for importing these documents is [XProc](http://www.w3.org/TR/xproc) .  The pipeline is rather simple:

```
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:ml="http://xmlcalabash.com/ns/extensions/marklogic"
                xmlns:s="http://weather.milowski.com/V/APRS/"
                version="1.0"
                name="insert-weather">
<p:option name='xdb.user'/>
<p:option name='xdb.password'/>
<p:option name='xdb.host'/>
<p:option name='xdb.port'/>
<p:input port="source"/>

<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>

<p:delete match="/s:aprs/s:report[@type='encoded']"/>

<p:delete match="/s:aprs/s:report[@error]"/>

<ml:insert-document name="insert" collections="http://weather.milowski.com/weather/">
```
```
   <p:with-option name='user' select='$xdb.user'/>
   <p:with-option name='password' select='$xdb.password'/>
   <p:with-option name='host' select='$xdb.host'/>
   <p:with-option name='port' select='$xdb.port'/>
   <p:with-option name="uri" 
                  select="concat('http://weather.milowski.com/',/s:report/@source,'-',/s:report/@start,'.xml')"/>
```
```
</ml:insert-document>

```
```
</p:declare-step>
```
You'll notice that I decided to remove errors and encoded data from the original source.  Errors are reports I couldn't parse according the APRS rules and encoded data are non-standard encodings of weather data.  These turn out to be very small percentages of the actual received data.  That is, almost everyone is producing data correctly by the standardize set of rules.

To apply that pipeline over and over again to the documents, I wrote a little daemon process that uses [Calabash's](http://xmlcalabash.com/) API to run the pipeline.  The daemon waits for the files to show up in a particular directory, applies the pipeline to documents it discovers, and then moves them to an archive directory.  That allows me to re-process them in the future if I change my mind--which I did.

A bit of foreshadowing never hurts.  I'll post more on the results of this later.  I've got some queries to write.

