---
title: "Experiments with Big Weather Data in MarkLogic - Doomed Approach"
date: "2012-04-13T15:49:24.758000-07:00"
url: "/journal/entry/2012-04-13T15:49:24.758000-07:00/"
params:
  author: Alex Miłowski
keywords:
  - MarkLogic
  - big data
  - weather
---


# Experiments with Big Weather Data in MarkLogic - Doomed Approach

The [ “Naive Approach” ](http://www.milowski.com/journal/entry/2012-04-11T11:08:29.62-07:00/) of just importing the weather reports verbatim works if all you want to do is enumerate a particular weather report's data by segments of time.  That is, this expression works really well:

```
/s:aprs/s:report[@from='DW8568' and @received>$start and @received<$end]
```
If you look at the results `xdmp:plan` , you'll see the query plan hits all the indices.  I've compared that simple expression with more complicated expressions that use `cts:search` and the results are effectively the same.  That's good as that means the query optimizer is doing its job.

Unfortunately, there are other queries where this approach fails to perform.  Before I get into that, I need to say what I mean by  “performance.” My goal is to produce small segments of data as web resources that match certain criteria (e.g. weather reports for the last hour within a geospatial region).  Those resources need to be produced in a reasonably short and constant amount of time; reasonable short means a few seconds--but less is always better.  To scope this a big more, if you ask for too large of a time period or too large of a geospatial region, then you've made an unreasonable request.  Further, as the number of reports increases over time, I want the query time to be constant.

The first query that is problematic is the list of station identifiers.  If you were using  “regular” XQuery, you'd try something like this:

```
for $id in distinct-values(/s:aprs/s:report/@from)
   return element station { $id }
```
Unfortunately, even though there is an index on `s:report/@from` , it isn't used in that expression and the performance is terrible.

It is easy to fix that problem by using `cts:element-attribute-values(),` but what you really want to do is summarize each station something like this:

```
for $id in cts:element-attribute-values( xs:QName("s:report"), xs:QName("from"),"","item-frequency")
    let $last := (for $r in /s:aprs/s:report[@from=$id] order by $r/@received return $r)[1],
        $location := (for $r in /s:aprs/s:report[@from=$id][@latitude and @longitude] order by $r/@received return $r)[1]
    return element s:station {
       attribute call { $id },
       attribute count {cts:frequency($id)},
       attribute last-received {$last/@received},
       if ($location)
       then ($location/@latitude, $location/@longitude)
       else ()
    }

```
where we retrieve the last weather report received from the station.  This query doesn't perform very well at all.  As the number of reports in the database increases, searching for the last report for each station identifier just isn't efficient as specified.  From this you can start to see how the [Naive Approach](http://www.milowski.com/journal/entry/2012-04-11T11:08:29.62-07:00/) starts to fall apart.

The second problem relates to geospatial queries and suffers from the same issues as the number of reports increases.  Since there is a geospatial index on the `s:report/@latitude` and `s:report/@longitude` attribute pair, we'd like to be able to search within a certain geospatial region for recent reports.  That query looks something like this:

```
let $now := current-dateTime(), $start := $now - xs:dayTimeDuration("PT1H")
   for $r in
      cts:search(/s:aprs/s:report[@received > $start],
        cts:element-attribute-pair-geospatial-query(xs:QName("s:report"),
          xs:QName("latitude"), xs:QName("longitude"), cts:circle(5, cts:point(37,-122))))
      order by $r/@received
      return $r
```
Again, the problem is the location is buried with a large pile of `s:report` elements.  MarkLogic does produce the query results but not within the performance metrics I'd prefer.  Keep in mind that this is still impressive for the  “shove it in a go” (Naive) approach: it takes 10's of seconds for 30+ million reports.  The problem is that it just isn't setup to perform and the query times increase as the number of reports increases.

As structured, the data is a classic example of denormalized data.  The location and other station summary information is repeated over and over again on the `s:report` elements.  Even though there are indices setup `@from` , `@latitude` , `@longitude` , and `@received` , it won't help over time.  The number of `s:report` elements will just be overwhelming as we're trying to extract a unique view of the normalized data (i.e. the latest station summary).

The conclusion is that the [Naive Approach](http://www.milowski.com/journal/entry/2012-04-11T11:08:29.62-07:00/) is *doomed* for big data.  That's not a huge surprise.  I expected it to fail and I wanted to see where.

MarkLogic is still a database system and, as I've been told, even for them, there isn't a free lunch.  You have to organize your information into rational collections; one giant collection to hold them all just won't scale.  As such, the solution is quite simple: more collections containing different views of the raw data.

As I'm local to MarkLogic, I took this problem as an opportunity to visit the wonderfully helpful folks at MarkLogic.  While I could have made up my own solutions, I wanted to understand what they would recommend.  It was a clean slate and I wasn't committed to any design.  I presented my current work literally as the Naive Approach and talked a bit about my problems.

One recommendation was, for the above queries, to keep a separate collection with up-to-date station summaries of each station.  While the database contains many millions of weather reports that will grow significantly, there are only about 10,000 stations right now.  The number of stations is unlikely to grow very fast in comparison to the number of reports.  As the weather reports are imported, keep a separate set of station summary documents, in a separate collection, for each of the 10,000 stations, and these problems should go away.  The problems did go away and the query times became constant and fast.  So, the solution was to normalize your data!

In relational databases, you often denormalize your data to improve performance.  In this case, the solution was to actually normalize your data.  That isn't a ground shaking revelation.  You wouldn't want only one large table of reports in a relational database either.  The difference is that you can get away with a lot within MarkLogic without having to think about information organization.  That is, until things go wrong.

The nice bit about this change is that in the cts:search queries, only the target nodes have to change:

```
collection("http://weather.milowski.com/stations/")//s:position
```
and the enumeration of stations becomes a document enumeration:

```
collection("http://weather.milowski.com/stations/")/s:station/@id

```
Best of all, this was an easy change to implement.  Why?  I'm using [XProc](http://www.w3.org/TR/xproc) and all I had to do was make a simple change to my import pipeline.  I'll post that bit next.

