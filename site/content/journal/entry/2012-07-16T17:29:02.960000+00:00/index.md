---
title: "Experiments with Big Weather Data in MarkLogic - Right-sizing and Indexing"
date: "2012-07-16T17:29:02.960000Z"
url: "/journal/entry/2012-07-16T17:29:02.960000+00:00/"
params:
  author: Alex Miłowski
keywords:
  - MarkLogic
  - big data
  - weather
---


# Experiments with Big Weather Data in MarkLogic - Right-sizing and Indexing

A lot has happened since my last update on my  “big data” weather experiment with [MarkLogic](http://www.marklogic.com/) .  I've been through a server crash, low memory trouble, reloaded my database, calculated the actual server requirements, and migrated to a new server.   In summary:  “Whew!  That was a lot of work and hair pulling.”

Most of my troubles started with allowing my import process to just run its course.  I knew I'd eventually outgrow my server size and it happened a bit before I thought it would.  While the server OS crash was rather unexpected, the recovery was certainly a task.  Once you have too much content in your database for the server you have, doing anything takes a long time.

I decided that I really didn't need a geospatial index on all of the weather reports given that I had another that could give me the location of each station.  The idea was to reduce the storage costs.  That required all the content in the database to be reindexed--which at about 190GB+ was going to take a long time given the constrained server.

That assumption was just all wrong.  First, the re-indexing was taking a very long time.  After several days of waiting I just gave up and cleared the forest.  Importing a smaller amount of data and testing the indices (sage advice from Norm Walsh) was the better path.  It also allowed me to calculate the amount of memory required for a month's worth of data according to [Michael Blakeyley's method](http://stackoverflow.com/questions/11196119/memory-usage-planning-recommendations) .

As I said, I cleared the forest and started up a new EC2 instance with a higher CPU allocation ([c1.medium](http://aws.amazon.com/ec2/instance-types/) ) and ran three separate import processes to re-load the data.  At the the point where I had about 3 weeks worth of data, I merged all the stands and calculated the memory requirements at: `3968MB * 8/3 * 4/3 = 14.1GB` .

I was able to get similar performance to what I had been getting before the server was overloaded with 3 weeks of data except that one of my reports was very slow.  I had dropped the geospatial index over all of the weather reports and that report now had to perform a for loop with a index-based query to retrieve the number of reports per quadrangle.  The result was a much slower response when you need to do that for all the quadrangles.  This query change is show below:

```

sum(
   for $s in cts:search(
        collection("http://.../stations/"),
        cts:element-attribute-pair-geospatial-query(
            xs:QName("s:station"), QName("","latitude"), QName("","longitude"),
            $quad) )
       return xdmp:estimate(
            collection(concat("http://.../weather/",$s/s:station/@id))
            /s:report[@received>=$dtstart and @received<=$dtend]))

```
As an experiment, I added back the geospatial index on all the weather reports and waited for the re-index to complete.  This time the re-index completed in a rational amount of time.  The result was what I expected (i.e. faster, same as before) and the query is listed below.

```

xdmp:estimate(
   cts:search(
       collection("http://.../weather/")/s:report,
           cts:and-query(
               (cts:element-attribute-range-query(
                    xs:QName("s:report"), QName("","received"),">=",$dtstart),
                cts:element-attribute-range-query(
                    xs:QName("s:report"), QName("","received"),"<=",$dtend),
                cts:element-attribute-pair-geospatial-query(
                    xs:QName("s:report"), QName("","latitude"), QName("","longitude"),
                    $quad) ) )))

```
Adding the index increased the in-memory stand cost and so the new memory requirements are at: `4457MB * 8/3 * 4/3 = 15.8GB` .   Given the disk space usage increase was minimal, the increased cost seemed nominal in comparison to the massive increase in performance for the above query.  As such, the additional memory is worth every byte.

Originally, the server also ran out of disk space.  To address this problem and to sort out disk performance, I moved to a RAID10 device over eight 200GB EBS volumes.  From everything I've read, this should provide better performance than a single 800GB EBS volume.  I haven't actually tested that theory but that change certainly hasn't made the server response for adding content or queries slower.

Finally, I moved the whole thing over to a new EC2 instance ([m2.xlarge](http://aws.amazon.com/ec2/instance-types/) ) that has 17.1GB of memory and more EC2 Compute Units (more CPU).  That change was the real test of all of these configuration changes.  The whole in-stand memory cost should be able to be satisfied by the new server instance.

The result was fantastic.  The cost of the most expensive reports all the way through to page generation has dropped to less than two seconds.  That includes the latency from my browser, on my desktop, through my OK network connection to Amazon AWS's us-east-1c availability zone.

The result is that I know that I can store at least one month of data without penalty on this system.  I'm going to be tracking the cost increases and any change in performance over the next few weeks.  Ultimately, I want a cluster plan for how big each forest is allowed to get and how many EC2 instances, EBS volumes, etc. I'll need to support that.

Right now, I'm just a happy MarkLogic camper.

