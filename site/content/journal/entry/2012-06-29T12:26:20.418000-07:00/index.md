---
title: "Too Much Data and Too Little Memory"
date: "2012-06-29T12:26:20.418000-07:00"
url: "/journal/entry/2012-06-29T12:26:20.418000-07:00/"
params:
  author: Alex Miłowski
keywords:
  - MarkLogic
  - weather
  - XProc
  - big data
---


# Too Much Data and Too Little Memory

Since my last update, I've made a lot of good progress on my  “big weather data” project.  The goal was always to understand how to organize scientific sensor data like weather reports within a database system like MarkLogic.  Alas, I don't currently have access to the hardware to really produce a production quality system that actually stores terabytes of information.  I did want to see how far I could get and what the characteristics of cluster would be to store such large-scale information.

Unfortunately, I pushed things a bit too far.  As you may have read, I had some troubles with disk space that set me back quite a bit.  After recovering from that near disaster, I continue to be impressed by MarkLogic's ability to persevere when faced with limited resources.  While that's an interesting and valuable facet of a database system, I now need to scale back the about of data to a reasonable size for the hardware I have and determine how this system should scale.

What that really means is that I need:

  1. to understand the per-gigabyte (or number of reports) system requirements in terms of CPU, disk space, and memory;
  1. to right-scale the system I'm using to a rational segment of data (a month?  two months?);
  1. to project a plan for how this system would cluster and scale.

Meanwhile, I have my current database that is far too large for the amount of memory I have available.  As I have the raw source and can re-create the database given enough time, I need to delete weather reports from the database till the system performs reasonably well.  That will allow me to finish testing the queries and index structures while also enabling better measurement of the system resources needed.

Given how much data I've pumped into the database, deleting content has become a problem.  If you select too large of a segment to delete, the query will time out and nothing will actually get deleted.  As such, the reports to delete need to be segmented into small transactions.

Also, given the low-memory conditions, these deletes needs to be performed in sequence.  I've tried using `xdmp:spawn,` but running deletes in parallel isn't helpful as the operations compete for resources and run slower (possibly timing out).  Also, keep in mind that the time segments to delete need to be small enough as there are around 66K weather reports per hour and each of those weather reports are now separate documents.

This is where using [XProc](http://www.w3.org/TR/XProc) with MarkLogic really shines.  XProc allows me to write a long-running script that will sequence a set of delete requests to the database.  The control of that script is the XProc engine, [calabash](http://xmlcalabash.com/) , and so I don't have to worry about timeouts within the database server as long as the requests are small enough.

Here's the outline of what the XProc needs to do:

  * Start with a day and generate a sequence of start times from which we'll delete (e.g. 2012-04-01T05:30:00Z ).
  * For each start time, send a query to MarkLogic that will delete reports from the start date for a certain duration (e.g. 5 minutes).

I can generate the list of start times easily with the XQuery:


```
declare variable $date external;
<starts>
{
let $start := xs:dateTime(concat($date,"T00:00:00Z")),
    $duration := xs:dayTimeDuration("PT5M")
    for $i in (0 to 287)
       return <start>{$start + $i*$duration}</start>
}
</starts>
```
The weather reports are also easily deleted by the XQuery:

```
declare namespace s="http://.../V/APRS/";
declare variable $start external;
declare variable $duration external;

<operation>deleted {$start} for {$duration}{
let $dstart := xs:dateTime($start),
    $dend := $dstart + xs:dayTimeDuration($duration)
   for $r in collection("http://.../weather/")/s:report[@received>=$dstart and @received<$dend]
      return xdmp:document-delete(base-uri($r))
}
</operation>

```
and I can sequence them in XProc as follows:

```
<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
    xmlns:ml="http://xmlcalabash.com/ns/extensions/marklogic"
    xmlns:cx="http://xmlcalabash.com/ns/extensions"    
    >
    <p:option name='xdb.user'/>
    <p:option name='xdb.password'/>
    <p:option name='xdb.host'/>
    <p:option name='xdb.port'/>
    <p:option name="day"/>
    <p:output port="result"/>

    <p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>

    <!-- generate the start times -->

    <p:xquery>
        <p:with-param name="date" select="$day"/>
        <p:input port="source"><p:inline><doc/></p:inline></p:input>
        <p:input port="query">
            <p:data wrapper="c:data" href="generate-start.xq" content-type="text/plain"/>
        </p:input>
    </p:xquery>

    <!-- iterate over the start times and delete reports from the database -->

    <p:viewport match="/starts/start">

        <cx:message>
            <p:with-option name="message" select="concat('Processing ',/start)"/>
        </cx:message>

        <ml:adhoc-query>
            <p:with-option name='user' select='$xdb.user'/>
            <p:with-option name='password' select='$xdb.password'/>
            <p:with-option name='host' select='$xdb.host'/>
            <p:with-option name='port' select='$xdb.port'/>
            <p:with-param name="start" select="string(/start)"/>
            <p:with-param name="duration" select="'PT5M'"/>
            <p:input port="source">
                <p:data wrapper="c:query" href="delete-report-duration.xq" content-type="text/plain"/>
            </p:input>
        </ml:adhoc-query>

    </p:viewport>

</p:declare-step>

```
My current plan is to use a similar XProc process to trim content from the database while new content is continually streamed into it.  This will allow me to keep the current weather data within the database while I determine a larger strategy to store all of it.

