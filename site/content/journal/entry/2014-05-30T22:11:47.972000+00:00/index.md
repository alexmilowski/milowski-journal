---
title: "Geospatial Data and KML"
date: "2014-05-30T22:11:47.972000Z"
url: "/journal/entry/2014-05-30T22:11:47.972000+00:00/"
params:
  author: Alex Miłowski
keywords:
  - phd
  - science
  - PAN
  - web
  - opendata
  - Edinburgh
  - KML
  - OGC
---

# Geospatial Data and KML

This is the third entry in my series on my PhD dissertation titled <cite>Enabling Scientific Data on the Web</cite>.  In this entry, we will explore KML and how can (or can't) be used to disseminate geospatial scientific data.

### What is KML?

In their own words:

Keyhole Markup Language (KML) is the markup language read by the Google Earth browser and technology that they acquired from Keyhole, Inc. in 2004 (no surprise there). In 2008, Google submitted KML to the [Open Geospatial Consortium (OGC) ](http://www.opengeospatial.org) for standardization and it was [approved](http://www.opengeospatial.org/node/857) , largely unchanged.

Like many other formats that serve a similar role, KML is feature-oriented. It allows users to describe place markers, polygons, and other spatial features and then attach metadata to these features. It serves in an essential role in the ability to build maps out of layers of data.



### Using KML for Data

My primary criticism of KML (and other such formats) is that it is focused on the map feature and not on the data that might be associated with it. In KML, data representations via the `ExtendedData` element feel like an afterthought. Even the  `description` element is just a plain string and HTML is encoded as escaped markup; an architectural limitation and poor design decision.

For example, here is the first `Placemark` element for [snow readings from the NOAA](http://www.srh.noaa.gov/gis/kml/) :

```XML
<Placemark><description><![CDATA[<b><font size="+2">
41P07S: American Creek</font></b><hr></hr>
<table cellspacing="0" cellpadding="0" width="400">
<tr><td>Elev: 1050 feet</td></tr>
<tr><td>Snow Water Equivalent: 0 inches</td>
<td>Snow Water Equivalent: -99.9 pct norm</td></tr>
<tr><td>Water Year Precipitation: 4.2 inches</td>
<td>Water Year Precipitation: -99.9 pct norm</td></tr>
<tr><td>Snow Depth: 0 inches</td><td>Snow Density: -99.9 percent</td></tr>
<tr><td><a href="http://www.wcc.nrcs.usda.gov/cgibin/wygraph-multi.pl?state=AK&amp;wateryear=current&amp;stationidname=41P07S">Time Series Chart</a></td>
<td><a href="http://www.wcc.nrcs.usda.gov/nwcc/site?sitenum=1189">Site Info</a></td></tr></table>
<a href="http://www.wcc.nrcs.usda.gov/siteimages/1189.jpg"><img width="400" alt="img not available" src="http://www.wcc.nrcs.usda.gov/siteimages/1189.jpg"/></a><hr></hr>
Generated: 30 May 2014]]></description><Snippet></Snippet><name>American Creek</name><LookAt><longitude>
-141.225
</longitude><latitude>
  64.795
 </latitude><range>10000</range><tilt>35.0</tilt><heading>0.0</heading>
</LookAt><visibility>1</visibility>
<styleUrl>#blackdot</styleUrl>
<MultiGeometry><Point><coordinates>
-141.225,64.795,0</coordinates></Point><LineString><coordinates>
-141.23,64.8,0 -141.23,64.79,0 -141.22,64.79,0 -141.22,64.8,0 -141.23,64.8,0 </coordinates></LineString>
</MultiGeometry>
</Placemark>
```
Looks like markup you can parse, right? Look closer.  See that   “`<![CDATA[` ” inside the `description` element? Good luck!

Of many of the examples that I've surveyed, this is very common.  The data is stuffed inside escaped markup in the description so that it looks good in an Earth browser.  Little consideration is given to whether you can actually get the data (elevation, snow measurement, etc.).   Only the geospatial feature is easily discovered (i.e., a point at 64.795, -141.225).

For the NOAA, you can get this data through other means. This requires applying for an account to get access to their data in a non-Web format (NetCDF) and then pulling it using their APIs. In essence, unless you really want it, it isn't readily available and doesn't meet my criteria for open data (e.g. open Web formats and protocols).

The NOAA could have provided this via the ExtendedData element but to do so they would have to duplicate the information they provide in the description.  That is, in addition to having the description element show the values via escaped HTML, they would need to put it in `Data` elements as shown:

```

         <ExtendedData>
            <Data name="elevation">
               <value>1050</value>
            </Data>
            <Data name="snow">
               <value>0</value>
            </Data>
            ...
         </ExtendedData>

```
While some Earth browsers support rendering this information for the place marker, it is unclear whether all would do so.  Thus, information would likely need to be duplicated between the human readable description and the tool processable `ExtendedData`  element.  That is certainly not an optimal design.

Of course, given my preference for RDFa, I'd rather we:

  * Not have escaped markup in descriptions.
  * Use RDFa annotations to avoid duplications or verbose markup.

Such an approach might be:

```
<Placemark>
<description>
<div vocab="http://noaa.gov/" typeof="Observation">
<h1 property="title">41P07S: American Creek</h1>
<table>
<tr><td>Elev: <span property="elevation">1050</span> feet</td></tr>
<tr><td>Snow Water Equivalent: <span property="snow">0</span> inches</td>
...
</table>
</div>
</description>
...
</Placemark>
```
Of course, we could make the annotations more comprehensive (e.g. include units of measure) and then they would be more verbose too.  At least the data would be in one place and we wouldn't need to  “shoehorn” the data into minimal markup that may not capture all its nuances.

Yet, this approach is unusable because KML processors would throw errors when the description contains markup.  You aren't allowed to do that, by definition, so stop wishing for sanity!



### Features or Tables?

My other major criticism of using KML to distributed data is that it is designed to render features in a map viewer.  If your main task is to process the data and run some algorithm on it, this is not an optimal format.  You have to process each geometric object, understand whether it contains data, and the extract the bits you need when all you really wanted is a table of data.

Many data feeds, like those from the NOAA, are point or simple polygon oriented and contain a set of measurements of the same types, repeated over and over again.  In the example used, each set of measurements is taken at a single geospatial coordinate.  The set of measured quantities are all the same kind and the same is true about the metadata (e.g. the elevation is always the same for each point).

Frankly speaking, a table of data is easier to process.  Please, give me a table of data (I did say  “please” ).



### What is next?



I could bore you all with describing the issues with GML (a whole bunch of XML Schema and then you are still not done), but I won't.  I want to address GeoJSON and few other odd formats next before we start talking about solutions.

