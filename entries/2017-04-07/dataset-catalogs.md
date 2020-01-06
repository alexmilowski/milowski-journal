title: Open Data in a Private Context
author: Alex Miłowski
published: 2017-04-07T15:00:00-07:00
updated: 2017-04-07T15:00:00-07:00
keywords:
- Data sets
- open data
- schema.org
- JSON-LD
- semantics
- Semantic Data Lakes
- analytics
- data science
- data engineering
content: |
   > The open data premise is a grand idea which I fully support and need to replicate into other contexts.

   There have been a variety of approaches for describing open data via "semantic vocabularies" over the last few years of which a few notable "standards" are:

    * [Data Catalog Vocabulary](http://www.w3.org/TR/vocab-dcat/)
    * [Asset Description Metadata Schema](http://www.w3.org/TR/vocab-adms/)
    * [Vocabulary of Interlinked Datasets](http://www.w3.org/TR/void/)
    * [RDF Data Cube Vocabulary](http://www.w3.org/TR/vocab-data-cube/)

   Many of these are predicated on the idea of sharing open data sets.  The primary consumers are government or public agencies who need (want or are required) to disseminate data.  The central premise is that using a Web-friendly syntax like
   [JSON-LD](https://www.w3.org/TR/json-ld/) or [RDFa](https://www.w3.org/TR/rdfa-lite/)
   enables information to be disseminated via the regular mechanisms of the Web (i.e., a web page or service).

   The open data premise is a grand idea which I fully support and need to replicated into other contexts. In a data science / analytics context, there are similar needs and concerns.  For an analytics backbone to operate, we need more data accessible and discoverable by interested consumers.  

   ## Producers, Consumers, and Implicit Transfer

   > An organization needs to be able to track and audit the use of data to ensure policies are being enforced.

   We also need to understand the relationships between data artifacts.  As processes produce new data artifacts by consuming existing ones, a web of relationships is produced.  Over time, the variety of replicated data can become overwhelming.

   The use of data is not explicitly traceable within the context of open data.  Once data is downloaded, whether new data artifacts are produced from a data source is not necessary known.  The quality of that metadata and whether it lists its sources is wholly dependent on the producer.

   In an enterprise context, we can and need to control the provenance of data and record sources within its metadata.  Data may have important properties like governance or privacy concerns.  These various properties of the data may be implicitly transferred to the new data artifacts.  An organization needs to be able to track and audit the use of data to ensure policies are being enforced.

   While not necessarily specific to the enterprise, the need to track the use of data is essential in the modern world of analytics and data pipelines.

   ## Going Private

   > ...need to understand ... the graph of producers and consumers of data within context the provenance and governance of the data that flows within.

   Within a large enterprise, the same issues of discoverability of data assets exist. Over time, data silos compartmentalize data and gatekeepers within the organization make traversing those silos difficult. Issues of security, provenance, governance, and ownership prevail over sharing; the cross-silo analysis for agile business practices fall to the politics of data fiefdoms.

   From an analytics perspective, any particular data science pipeline may require inputs from a number of data silos.  The speed and success of any such analytics endeavour is dependent upon access to the required data.  Even further, data scientists and engineers need to understand the data to be able to use it effectively.  

   Understanding data pipelines and the dependencies that ensue requires goes beyond the basics of a simple schema definition. We need to understand the operational semantics of the graph of producers and consumers of data within the context of the provenance and governance of the data that flows within. In today's world, privacy is fleeting and we need to be careful not to run afoul of regulation and promises to our customers.  

   We need to understand:

    * the data assets we have
    * what processes consume those assets
    * what artifacts are produced
    * how data is used
    * what governance is transferred to new data

   In the end, we want an inventory of everything in one place so we can understand all the relationships within our enterprise; **analytics on analytics**.

   ## A Centralized Approach

   > Every analytics data pipeline ... must maintain all the essential metadata ...

   An approach I am exploring is the idea of a centralized semantic repository of data asset annotations. I imagine this repository as an inventory of various aspects of the data:

   Essential core:

    * organizational hierarchy containing
    * every data asset
    * with the location of data within data silos, infrastructure, etc.
    * annotated with essential metadata (e.g., created, updated, titles, etc.)
    * identifying provenance, ownership, and governance
    * with necessary descriptions of the data for the consumers

   Operational core (programmatic access):

    * to navigate/query the repository
    * to the data definitions
    * to how to access the actual data
    * to the format descriptions
    * to update/create all of the above

   Every analytics data pipeline in our enterprise must keep this information up-to-date.  It must maintain all the essential metadata about the inputs, outputs, and how to access the results.

   ## Tyranny of Choice - Vocabularies

   > not a fan of proliferation of prefixes, namespaces, etc. just for the purpose of identification

   The essential stumbling block is what vocabulary should be used to describe various data assets:

    * As mentioned previously, there are number of competing, overlapping, and complimentary vocabularies for open data.  
    * No one vocabulary will suffice in the enterprise context as I have described it above.
    * We need to describe process, data set relations via those processes, and the relation of the data to various governance and compliance issues.
    * Consumers are fickle; too complex and they won't use it.

   There are some choices, cross roads, that may determine success:

    1. A single vocabulary with extension mechanisms.
    2. A mixture of existing and new vocabularies.

   I am not a fan of proliferation of prefixes, namespaces, etc. just for the purpose of identification.  We can use technology to map things internally for those that need it.  As such, (2) is not my personal choice.

   Fortunately, [schema.org](http://schema.org) has incorporated (see W3C [WebSchemas/Datasets](https://www.w3.org/wiki/WebSchemas/Datasets)) aspects of [DCAT](http://www.w3.org/TR/vocab-dcat/), [ADMS](http://www.w3.org/TR/vocab-adms/), and [VoID](http://www.w3.org/TR/void/).  I believe this is a good starting point as we can reuse other types and properties to describe other aspects (i.e., organization structure, essential metadata, etc.).

   ## The Experiment

   I can take a few steps down this road by:

    1. Examining the assets I have stored in Hadoop/HDFS that are products of various processes.
    * Gathering the history of these assets and produce a semantic description in JSON-LD for each asset.
    * Dump all the data into a semantic graph database like [AllegroGraph](http://allegrograph.com/allegrograph/).

   Then I can query the result with SPARQL to see what I know and don't know.  That will help identify new information I need to gather.  Afterwards, it is a process of "rinse and repeat" until I feel like I have a good basis.

   I believe there will be some new types and properties needed.  Hopefully that will be interesting to the schema.org community.
