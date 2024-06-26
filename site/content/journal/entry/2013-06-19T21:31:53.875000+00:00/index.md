---
title: "Managing Documents in MarkLogic with XProc"
date: "2013-06-19T21:31:53.875000Z"
url: "/journal/entry/2013-06-19T21:31:53.875000+00:00/"
params:
  author: Alex Miłowski
keywords:
  - XProc
  - MarkLogic
  - XQuery
  - big data
  - Calabash
  - MLD Approach
---

# Managing Documents in MarkLogic with XProc

### Summary

The * “many little documents” (MLD) approach * has the consequence of needing to manage massive numbers of individual documents.  XProc is an invaluable tool for managing documents and solving problems encountered with the *MLD approach* .  This rather long post will step through the problem and how you can solve it with a combination of [XProc](http://www.w3.org/TR/XProc) and [XQuery](http://www.w3.org/TR/xquery/) for [MarkLogic](http://www.marklogic.com/) .


### The Problem

One of the problems with the * “many little documents” (MLD) approach * to big data is that you end up with millions of documents to manage.  In my particular case, each day I receive about 1.5 million weather reports and each is stored as a separate document.  This gives my import and other process the wonderful property of idempotence but it does end up costing me in other ways:

  * It is pointless to enable a document URI lexicon in MarkLogic as it would end up being massive and costly.
  * Without a document URI lexicon, address documents by a constructed URI is less efficient.
  * Manipulating a day or month's worth of data means handling a lot of documents all at once.
  * Handling individual documents often means addressing them by URI.

Also, because of the experimental nature of my research, I don't intend on keeping a full archive of the [CWOP weather data](http://wxqa.com/) and the time has come to cull months from the database that I don't need and can't afford to store.  In general, my server can support 3-4 months of data before I need more disk space or possibly more memory.

So, the task at hand is to delete several months worth of data.  Sounds simple, right?  Remember, each month represents 45 million documents whose access by URI isn't preferred.  As such, finding and deleting weather report document by a simple query can be expensive:

```
declare namespace s="http://weather.milowski.com/V/APRS/";
let $dtstart := xs:dateTime("2013-01-01T00:00:00Z"),
    $dtend := xs:dateTime("2013-02-01T00:00:00Z")
   for $r in collection("http://weather.milowski.com/weather/")/s:report[@received>=$dtstart and @received<$dtend]
      return xdmp:document-delete(base-uri($r))

```
That's an iteration over 45+ million documents and so we expect that to be very, very slow.  In fact, it will most certainly timeout on the server and nothing will actually get deleted.

For any problem like this, we need to divide the task into reasonable sized smaller tasks which the server can complete within the allocated time limit. With the *MLD approach* , we need to rely on the organization of the documents.  That is, deleting collections or directories is very fast in comparison to deleting each document individually.

Unfortunately for me, I didn't organize my weather data by time periods like days or months.  Instead, I organized it by metadata like station identifier.  As such, I have no way to easily delete my data by month and so the first task is to organize my data.

### XProc to the Rescue!

Fortunately, technologies like [XProc](http://www.w3.org/TR/XProc) exist and have easy ways to interact with [MarkLogic](http://www.marklogic.com/) .  In fact, [Calabash](http://xmlcalabash.com/) ships with MarkLogic specific steps that let me send adhoc queries to the server.  This allows me to poke at data or, in this case, delete documents.

In my testing, empirical evidence suggests that I can delete a day's worth (1.5 million documents) easily within the transaction time limit.  All I need to do is create collections for each day, assign the appropriate weather report documents to those collections, and then we're ready to delete.   That does mean we need to iterate through each day's worth of documents.

Iterating 1.5+ million documents in a single transaction is still a bad idea even though adjusting metadata (e.g. collections that they belong to) is reasonably fast.  As such, we need to group documents into even smaller partitions (e.g. 1 hour segments) and process them as separate transactions.  That results in a more reasonable number of about 62,000 documents per transaction.

The strategy for the processing is simple:

  * The input is a requested month and day range.
  * From the input, generate the explicit set of day/hour partitions to process.
  * For each partition, run a **separate** query transaction against the server that assigns the documents to the collections.

The input can be embedded within the pipeline to make it easier to run.  We'll also pass in all the server information as parameters.  The pipeline starts as follows:

```

<p:declare-step
   xmlns:p="http://www.w3.org/ns/xproc"
   xmlns:c="http://www.w3.org/ns/xproc-step"
   xmlns:ml="http://xmlcalabash.com/ns/extensions/marklogic"
   xmlns:cx="http://xmlcalabash.com/ns/extensions"    
   version="1.0">
   <p:option name='xdb.user'/>
   <p:option name='xdb.password'/>
   <p:option name='xdb.host'/>
   <p:option name='xdb.port'/>
   <p:input port="source">
      <p:inline>
         <request month="2013-01" start="1" end="31"/>
      </p:inline>
   </p:input>
   <p:output port="result"/>
   <p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
  ...

```
Note how we are importing the Calabash extension steps and using declaring the namespace for the MarkLogic steps.  We'll use that later.

Next, we use the local XQuery processor to generate each day as a separate `group` element:

```

   <p:xquery>
      <p:input port="parameters"><p:inline><c:param-set/></p:inline></p:input>
      <p:input port="query">
         <p:inline>
            <c:query>
               element groups {
                  let $month := xs:string(/request/@month)
                     for $day in (xs:int(/request/@start) to xs:int(/request/@end))
                        let $date := concat($month,"-",if ($day &lt; 10) then concat("0",$day) else $day),
                            $start := xs:dateTime(concat($date,"T00:00:00Z"))
                           for $h in (0 to 23)
                              let $hstart := $start + xs:dayTimeDuration(concat("PT",$h,"H")),
                                  $hend := $hstart + xs:dayTimeDuration("PT1H")
                                  return element group {
                                     attribute date { $date },
                                     attribute start { $hstart },
                                     attribute end { $hend }
                                  }
               }
         </c:query>
         </p:inline>
      </p:input>
   </p:xquery>

```
Now we just use the viewporting mechanism of XProc to handle each group separately:

```

   <p:viewport match="/groups/group">
      <!-- output a message to the console -->
      <cx:message>
         <p:with-option name="message"
                        select="concat('Processing ',/group/@date,' from ',/group/@start,' to ',/group/@end)"/>
      </cx:message>
      <!-- generate the query to send -->
      <p:template>
         <p:input port="parameters"><p:inline><c:param-set/></p:inline></p:input>
         <p:input port="template">
            <p:inline>
               <c:query>
                  declare namespace s="http://weather.milowski.com/V/APRS/";
                  element collection-set {{
                     attribute date {{ "{string(/group/@date)}" }},
                     let $dtstart := xs:dateTime("{string(/group/@start)}"),
                         $dtend := xs:dateTime("{string(/group/@end)}"),
                         $count := xdmp:estimate(
                             collection("http://weather.milowski.com/weather/")
                                /s:report[@received >= $dtstart and @received &lt;$dtend]),
                         $set := collection("http://weather.milowski.com/weather/")
                                    /s:report[@received >= $dtstart and @received &lt;$dtend]
                         return (
                           attribute start {{ "{string(/group/@start)}" }},
                           attribute end {{ "{string(/group/@end)}" }},
                           attribute count {{ $count }},
                           for $d in $set
                              return
                                 xdmp:document-add-collections(
                                    base-uri($d),
                                    ("http://weather.milowski.com/weather/{string(/group/@month)}",
                                     "http://weather.milowski.com/weather/{string(/group/@date)}"))
                        )
                  }}
               </c:query>
            </p:inline>
         </p:input>
      </p:template>
      <!-- send the query to the server -->
      <ml:adhoc-query>
         <p:with-option name='user' select='$xdb.user'/>
         <p:with-option name='password' select='$xdb.password'/>
         <p:with-option name='host' select='$xdb.host'/>
         <p:with-option name='port' select='$xdb.port'/>
         <p:input port="parameters"><p:inline><c:param-set/></p:inline></p:input>
      </ml:adhoc-query>
   </p:viewport>

```
If you've stuck with me this far, you've just seen a whole lot of XProc but understanding the steps isn't that bad once you get used to it:

  * The `p:viewport` matches each `group` element and makes it a separate document that is processed by the steps it contains.
  * The very first `cx:message` step just outputs a console message so we can see the progress.
  * The `p:template` step generates a query based on the group element.  The syntax replaces constructs within curly braces with the expression results.  You can see that the mixing of `p:template` and XQuery is a bit confusing as they both use curly brackets in their syntax.
  * Finally, the `ml:adhoc-query` step receives the results from the `p:template` step and sends it to the server to be executed.  If all goes well, a single `collection-set` element is returned by the query with data about how many documents were processed.

The output of the pipeline is just a `groups` element with a set of `collection-set` element children detailing what hours and counts of documents that were processed.

### Back to Deleting Those Documents!

The delete of data by month is accomplished via XProc in a similar way.  The full pipeline is listed below:

```

<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
   xmlns:p="http://www.w3.org/ns/xproc"
   xmlns:c="http://www.w3.org/ns/xproc-step"
   xmlns:ml="http://xmlcalabash.com/ns/extensions/marklogic"
   version="1.0">
   <p:option name='xdb.user'/>
   <p:option name='xdb.password'/>
   <p:option name='xdb.host'/>
   <p:option name='xdb.port'/>
   <p:input port="source">
      <p:inline>
         <request month="2013-01" start="1" end="31"/>
      </p:inline>
   </p:input>
   <p:output port="result"/>
   <p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>

   <p:xquery>
      <p:input port="parameters"><p:inline><c:param-set/></p:inline></p:input>
      <p:input port="query">
         <p:inline>
            <c:query>
               element days {
                  let $month := xs:string(/request/@month)
                     for $n in reverse(xs:int(/request/@start) to xs:int(/request/@end))
                        return element day {
                           attribute month { $month },
                           attribute day { if ($n &lt; 10) then concat("0",$n) else $n }
                        }
               }
         </c:query>
         </p:inline>
      </p:input>
   </p:xquery>
   <p:viewport match="/days/day">
      <p:template>
         <p:input port="parameters"><p:inline><c:param-set/></p:inline></p:input>
         <p:input port="template">
            <p:inline>
            <c:query>
               declare namespace s="http://weather.milowski.com/V/APRS/";
               let $date :=  "{string(/day/@month)}-{string(/day/@day)}",
                   $collection := concat("http://weather.milowski.com/weather/",$date)
                  return
                     element deleted {{
                        attribute date {{ $date }},
                        attribute count {{ xdmp:estimate(collection($collection)/s:report) }},
                        xdmp:collection-delete($collection)
                     }}
            </c:query>
            </p:inline>
         </p:input>
      </p:template>
      <ml:adhoc-query>
         <p:with-option name='user' select='$xdb.user'/>
         <p:with-option name='password' select='$xdb.password'/>
         <p:with-option name='host' select='$xdb.host'/>
         <p:with-option name='port' select='$xdb.port'/>
         <p:input port="parameters"><p:inline><c:param-set/></p:inline></p:input>
      </ml:adhoc-query>
   </p:viewport>

</p:declare-step>
```
Enough XProc for you?  I've got more...

