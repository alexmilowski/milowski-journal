title: New Research Agenda
author: Alex Miłowski
published: 2017-03-31T15:00:00-08:00
updated: 2017-03-31T15:00:00-08:00
keywords:
- Web
- JSON-LD
- Microservices
- semantics
- Semantic Data Lakes
- duckpond
- analytics
- data flow languages
- Pipelines
- data science
- data engineering
content: |
   I have been rather silent for awhile and environment has everything to do with that.  Many startups work under the guise of secrecy and my day-to-day work kept me quite busy without much opportunity to communicate.  In my new endeavours at [Orange Silicon Valley](http://www.orangesv.com) (really, San Francisco) my role is a communicator of new and interesting things.  As such, keeping this blog up-to-date with what is rolling around in my mind is one aspect of that.

   In this post, I am going to try to output my current research focus, various ideas I want to work on, and projects of my own that I am currently working on.  At some point, you may hear about the projects I'm working on at Orange as well.  As always, feedback, comments, suggestions, or just a simple 👍 is very welcome.

   ## Research focus

   ### Microservices, JSON-LD, and Semantic Data services

   > There is a synergy between semantics and microservices that is captivating.

   There is a particularly useful nexus between Microservices, JSON-LD, and Semantic Data Services:

    * **[Microservices](https://en.wikipedia.org/wiki/Microservices)** provide a useful alternative to monolithic application architectures
    * Microservices often talk JSON so why not **[JSON-LD](http://json-ld.org)**? Let's give things a bit more context for the consuming application
    * JSON-LD enables semantics to be applied to the data provided by the Microservices; there is another architectural pattern to be extracted for **Semantic Data Services**

   #### Microservices

   > Old, meet new: we've all been doing it … sort of … but without the important twist.

   As it turns out, I have been using [Microservices](https://en.wikipedia.org/wiki/Microservices) as a design pattern for many, many years. The architectural pattern of creating a myriad of orthogonal services that an application (typically on the Web) can compose to implement behavior is exceedingly useful. In the end, instead of a monolithic Web application, we have a much thinner application that "talks" to services, typically over HTTP, to accomplish the tasks necessary to exhibit the desired behaviour.

   The twist that the new "Microservices mantra" provides is that implementation is encapsulated.  Whatever choices that are made when the service is developed is hidden from the consuming service.  While particular choices of technology (e.g., your preferred database) might be common amongst your deployed Microservices, the infrastructure that supports the deployment of the service isolates each backing component.  Thus, infrastructure is not shared and can be maintained or upgraded on its own schedule.

   I have been creating scaffolding for Microservices in various languages and I would like to merge that with the various things needed for Semantic Data Services.

   #### JSON-LD for response data

   > If you are using JSON, you might as well be using JSON-LD.

   If your microservice emits JSON, make it emit JSON-LD.  There is a minimal story of what that exactly means but it isn't too much of a burden. I'm going to spend some time over the next few weeks (or months) detailing the easy ways to do that so it won't be so painful for the unconvinced.

   When the Microservices design pattern is applied to an application architecture, the decomposition into services will demand a variety of data to be transported back and forth.  The popular choice is to use some sort of JSON, often a custom "home brew" vocabulary, that is specific to a service.  Over time, the myriad of vocabularies will be diverse and their intersection of terms will be not be empty.

   The common technique from the database world to solve this problem is to create a data dictionary, possibly giving things common but "clunky" names, so that any application (developer) has an reference for the data semantics.  Objects are then composed from elements in the data dictionary; aggregates use common composition relations in a similar fashion.  The result is often a strictly controlled vocabulary that serves its design purpose but is unlikely to please most (or possibly no one).

   At a purely syntactic level, JSON-LD provides many mechanism for naming and typing things that accomplishes:

    * disambiguation - your use of "name" (e.g., `"name" : "fluffy"`) and my use of "name" (e.g., `"name" : { "first" : "fluffy", "last" : "bunny"}`) are different
    * composition - reuse vocabularies without ambiguity and with less painful conflict resolution
    * typing - what exactly is this object or value anyway?
    * syntax - a common syntax that tools understand for accomplishing the above

   #### Semantic Data Services

   > Data silos aren't going away any time soon and the genesis of microservices within an enterprise might even make that worse.

   A common addition to the microservices design pattern is the introduction of service brokers and/or registries:

    * brokers - instead of talking to each service directly, an application talks to a broker that knows how to invoke the service
    * registries - instead of knowing where each service is located, an application interacts with a registry to find the services it needs

   Brokers are useful for maintaining information about services and implementing various SLA policies over them.  It is a useful architectural pattern for scaling services, providing high availability, and dealing gracefully with failures.  From a semantics perspective, the broker doesn't really play much of a role.

   On the other hand, for bridging silos, the registry is an essential component.  Having a registry of microservices within an organization provides several essential high-level goals for an application developer:

    * allows an application (or broker) to locate the running instance of a particular microservice
    * defines the owner, business unit, and implementation as metadata
    * provides an opportunity to centralize role-based access to services

   There are plenty of other things that could be added to that list from a DevOps perspective. From a semantics perspective, the registry can provide metadata about:

    * what kind of data does the service consume and produce
    * where are the definitions of the vocabularies
    * what kind of service provides what kind of data
    * how do services and vocabularies relate to the structure of the business.

   I will be exploring how this kind of registry can help bridge data silos and reduce "time to market" for applications.

   ### Analytics for Analytics

   > Who ran what where to produce what when?

   There are so many tools, techniques, and manual processes involved in data analytics pipelines. It seems to be rare that anyone has a complete view within an organization of how data is actually produced. Tracing back from data stored in a repository (e.g., Hadoop HDFS) often requires talking to the individual that produced the data.

   While good documentation of processes can help, we all know that documentation often fails to include sufficient detail and also doesn't get updated when things change.  What we need is something more automated that keeps track of:

    * when something is run to produce data
    * by whom
    * via what process
    * via what version(s) of that code, program, etc.
    * where was it running
    * at what time
    * what artifacts did it consume
    * what artifacts did it produce

   We want an audit trail that can be used to track the provenance of data and to understand what needs to be done when things change.

   There is a vocabulary and "meta-analytics" hidden in here that I would like to explore.

   ### Data Flows Languages and Containers

   > Data flow is an essential part of data science and engineering; a dedicated language would help.

   I am particular interested in data flow languages.  I would like to generalize my past experiences with XProc and XML pipelining technologies.

   A data flow language could:

    * allow a data science / analytics pipeline to be expressed as a single data flow
    * annotated to describe how portions cross infrastructure boundaries
    * enable coordination of microservice to accomplish tasks
    * enable authoring tools for data scientists or domain experts
    * enable encapsulation for data engineers

   But the fundamental question at what level the language operates.  [XProc (XML Pipelines)](https://en.wikipedia.org/wiki/XProc) was certainly a tool of the data engineer and [Taverna (e-science)](https://en.wikipedia.org/wiki/Apache_Taverna) was that of the domain expert.  Neither of these can directly decompose their data flows into something that can be distributed across physically or virtually separated infrastructure.

   The reality for data flows in an enterprise context is that certain portions must run within walled gardens.  How does a data flow enter and exit that garden except through the garden gate (and not under and lose its shirt)?

   ## Projects

   ### duckpond

   > A simple project for streams of content partitioned by semantics

   Duckpond run this website but it can run a lot more.  I have to prove that to you all.  

   Watch this space …

   ### PAN, pantabular, mesonet.info, version 2

   > My [PhD research](https://www.era.lib.ed.ac.uk/handle/1842/9957) and a [CWOP weather data](http://wxqa.com) archive and tools

   My [PhD research](https://www.era.lib.ed.ac.uk/handle/1842/9957) produced mesonet.info as a example application for citizen weather data.  One very smart and talented person (Jeni Tennison) suggested that I really ought to do this via CSV on the Web; while RDFa/HTML was fine, CSV would be more useful.  I have plenty more ideas on related to that also including providing JSON-LD.

   Subsequently, I worked on a project with OpenNEX climate data that used the same methodology.  Pulling all this forward to my current thinking would be very interesting.

   I need to rework the infrastructure.  I shutdown the website recently because the infrastructure broke but I am still collecting data.

   I also think my duckpond project has a role to play.

   Watch this space …

   ### Open / Dark Data

   > The consequence of open data is "dark data" - that which gets deleted when it is inconvenient.

   I am concerned about the recent spate of disappearing data.  I think an interesting project related to microservices and JSON-LD is registries of where data exists that is also distributed, redundant, and hard to delete or spoof (think DNS).  That would enable monitoring and archiving of public data sets that administrations like to delete with they contain facts that counter alternative facts.

   ### Backlog

   > I need a clone that is also willing to do my bidding.

   I have a backlog of various things on github that need my attention:

    * [mark5](http://github.com/alexmilowski/mark5) - a CommonMark (Markdown) to HTML5 conversion tool … needs documentation, packaging, and examples.
    * [mesonet](http://github.com/alexmilowski/mesonet) - was to the be source from my PhD research … needs to be checked in!!!
    * [green-turtle](http://github.com/alexmilowski/green-turtle) - y RDFa/JSON-LD/Microdata processor … needs attention (tender loving care)
    * [data-science](http://github.com/alexmilowski/data-science) - various simple examples … could use more navigational text
    * [goodies](http://github.com/alexmilowski/goodies) - random bits … needs documentation and there are other things to check in
    * [opennex](http://github.com/alexmilowski/opennex) - a NASA related project on climate models … probably needs some love
    * [schema.js](http://github.com/alexmilowski/schema.js) - a neat tool I wrote for RDfa/JSON-LD schemata … needs documentation and examples
