---
title: "GeoJSON to the Rescue (or not)!"
date: "2014-06-03T00:31:15.606000Z"
url: "/journal/entry/2014-06-03T00:31:15.606000+00:00/"
params:
  author: Alex Miłowski
keywords:
  - phd
  - science
  - web
  - opendata
  - Edinburgh
  - GeoJSON
  - JSON-LD
---

# GeoJSON to the Rescue (or not)!

This is the fourth entry in my series on my PhD dissertation titled <cite>Enabling Scientific Data on the Web</cite>.  In this entry, we will explore GeoJSON as an alternate approach to geospatial scientific data.

### What is GeoJSON?

[GeoJSON](http://geojson.org/geojson-spec.html) is a format developed for   “encoding a variety of geographic data structures” . It is feature-oriented, just like KML, and can replace the use of KML in many, but not all, Web applications. The encoding conforms to  “standard” JSON syntax, with an expected structure and set of property names.

<figure><figcaption>A GeoJSON Object Containing Two San Francisco Landmarks</figcaption><pre>{ &quot;type&quot;: &quot;FeatureCollection&quot;,
  &quot;features&quot;: [
      {&quot;type&quot;: &quot;Feature&quot;,
       &quot;properties&quot;: {
          &quot;name&quot;: &quot;AT&amp;T Park&quot;,
          &quot;amenity&quot;: &quot;Baseball Stadium&quot;,
          &quot;description&quot;: &quot;This is where the SF Giants play!&quot;
       },
       &quot;geometry&quot;: {
          &quot;type&quot;: &quot;Point&quot;,
          &quot;coordinates&quot;: [-122.389283, 37.778788 ]
       }
      },
      {&quot;type&quot;: &quot;Feature&quot;,
       &quot;properties&quot;: {
          &quot;name&quot;: &quot;Coit Tower&quot;
       },
       &quot;geometry&quot;: {
          &quot;type&quot;: &quot;Point&quot;,
          &quot;coordinates&quot;: [ -122.405896, 37.802266 ]
       }
    }
  ]
}</pre></figure>

A GeoJSON object starts with a feature collection and each feature is a tuple of a geometric object, an optional identifier, and a property object. The geometry object describes a point, line, polygon, arrays of such objects, or collections of mixed geometry objects.

The  “`properties` ” property of the feature is any JSON object value. In the example shown above, it defines a set of metadata for each point that describes a location in San Francisco. If the property names match the expectations of the consuming application, it may affect the rendering (e.g. a map marker might be labeled with the feature name). There is no standardization of what the  “`properties` ”  property may contain other than it must be a legal JSON object value.



### GeoJSON at the USGS

The US Geological Survey (USGS) provides many different feeds of various earthquakes around the world as [GeoJSON feeds ](http://earthquake.usgs.gov/earthquakes/feed/v1.0/geojson.php) . Each feature is a single point (the epicenter) and an extensive set of properties is provided that describe the earthquake.  The property definitions is defined on the USGS website but their use is not standardized.

<figure><figcaption>An Earthquake Feed Example</figcaption><pre>
{&quot;type&quot;:&quot;FeatureCollection&quot;,
 &quot;metadata&quot;:{
     &quot;generated&quot;:1401748792000,
     &quot;url&quot;:&quot;http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_day.geojson&quot;,
     &quot;title&quot;:&quot;USGS Significant Earthquakes, Past Day&quot;,
     &quot;status&quot;:200,
     &quot;api&quot;:&quot;1.0.13&quot;,
     &quot;count&quot;:1
  },
  &quot;features&quot;:[
     {&quot;type&quot;:&quot;Feature&quot;,
      &quot;properties&quot;:{
         &quot;mag&quot;:4.16,
         &quot;place&quot;:&quot;7km NW of Westwood, California&quot;,
         &quot;time&quot;:1401676603930,
         &quot;updated&quot;:1401748647446,
         &quot;tz&quot;:-420,
         &quot;url&quot;:&quot;http://earthquake.usgs.gov/earthquakes/eventpage/ci15507801&quot;,
         &quot;detail&quot;:&quot;http://earthquake.usgs.gov/earthquakes/feed/v1.0/detail/ci15507801.geojson&quot;,
         &quot;felt&quot;:3290,
         &quot;cdi&quot;:5.4,
         &quot;mmi&quot;:5.36,
         &quot;alert&quot;:&quot;green&quot;,
         &quot;status&quot;:&quot;reviewed&quot;,
         &quot;tsunami&quot;:null,
         &quot;sig&quot;:806,
         &quot;net&quot;:&quot;ci&quot;,
         &quot;code&quot;:&quot;15507801&quot;,
         &quot;ids&quot;:&quot;,ci15507801,&quot;,
         &quot;sources&quot;:&quot;,ci,&quot;,
         &quot;types&quot;:&quot;,cap,dyfi,focal-mechanism,general-link,geoserve,losspager,moment-tensor,nearby-cities,origin,phase-data,scitech-link,shakemap,&quot;,
         &quot;nst&quot;:100,
         &quot;dmin&quot;:0.0317,
         &quot;rms&quot;:0.22,
         &quot;gap&quot;:43,
         &quot;magType&quot;:&quot;mw&quot;,
         &quot;type&quot;:&quot;earthquake&quot;,
         &quot;title&quot;:&quot;M 4.2 - 7km NW of Westwood, California&quot;
      },
      &quot;geometry&quot;:{
         &quot;type&quot;:&quot;Point&quot;,
         &quot;coordinates&quot;:[-118.4911667,34.0958333,4.36]
      },
      &quot;id&quot;:&quot;ci15507801&quot;
    }
  ]
}</pre></figure>

It is quite easy to see that when this data is encountered outside of the context of the USGS, the property names have little meaning and no syntax that identifies them as belonging the USGS.



### Out with the Old, in with the New

Just replacing KML's XML syntax and legacy structures from Keyhole with a JSON syntax doesn't address much other than making it easier for JavaScript developers to access the data. There are plenty of mapping tool kits, written in JavaScript, that can readily  “do things ” with GeoJSON data with minimal effort and that is generally a good thing. Many can also consume KML as well and so we haven't necessarily improved access.

The format is still oriented towards map features. If you look at the example above, you'll see that the non-geometry information overwhelms the feature information. If you want to process just the properties, you need to enumerate all the features and then extract (access) the data. Because JSON results in a data structure, GeoJSON makes this a bit easier than KML and is an obvious win for this format.

Remember that we are still looking at scientific data sets and scientists love to make tables of data.  The USGS earthquake feed is a table of data that happens to have two columns of geospatial information (the epicenter) and 26 other columns of data.   Yet, we are forced to a map-feature view of this data set by the choice of GeoJSON.

Keep in mind that the OGC says this about KML:

We could say almost the same thing about GeoJSON except that it doesn't say what to do with the properties.  There is only an implied aspect of GeoJSON that the features are rendered into map features and then the properties are displayed somehow.  That somehow is left up to the Website developer to code in JavaScript.



### Does JSON-LD Help?

GeoJSON is fine for what it does and doesn't do, but it probably shouldn't be used to exchange scientific data.  It lacks any ability to standardized what to expect for as data for each feature and such standardization isn't the purview of the good folks that developed it.  We might be able to place something in the value of the   “`properties` ” property to facilitate syntactic recognition of specific kinds of data.

One new thing that I am considering exploring is a mixed model where the   “`properties` ” object value is assumed to be a [JSON-LD](http://www.w3.org/TR/json-ld/) object.  This allows the data to have a much more rich annotation and opens the door to standardization.  Unfortunately, this is still on my  “TODO list” .



### What is next?



I'm just about done with formats for scientific data. There are many, many more formats out there and they suffer from many of the same pitfalls. Up next, I want to address what it means to be on the Web, address some architecture principles, and describe some qualities we want for Web-oriented scientific data.

