---
title: "Scientific Measurements in Schema.org"
date: "2013-06-07T15:22:33.260000Z"
url: "/journal/entry/2013-06-07T15:22:33.260000+00:00/"
params:
  author: Alex Miłowski
keywords:
  - rdfa
  - schema.org
  - science
  - SI units
---

# Scientific Measurements in Schema.org

The physical sciences use the idea of a [quantity](http://en.wikipedia.org/wiki/Quantity#Quantity_in_physical_science) to measure the world around us.  While that might seem simple, basing a measurement on a system of units that can be quantified, measured accurately, verified isn't exactly simple.  Nevertheless, a great deal of time and effort has converged into the [International System of Units (SI)](http://en.wikipedia.org/wiki/International_System_of_Units) .

One of the good things about this system is that you can compose a base unit and a prefix to deal with scale.  That is, you can combine a base unit with a prefix to get a different scale of measurement (e.g. m (meter) versus km (1000 meters), cm (1/100 of a meter), etc.).  This allows a whole scheme of measurements where the scale is known along with a base unit without constructing separate names or symbols.

In an attempt to align my [weather data efforts](http://www.mesonet.info/) with [schema.org](http://www.schema.org/) 's types, I looked into what was available currently in either the [current types](http://www.schema.org/docs/full.html) or [proposals](http://www.w3.org/wiki/WebSchemas/SchemaDotOrgProposals) for representing quantities.  The most obvious candidate is [QuantitativeValue](http://www.schema.org/QuantitativeValue) that has a `value` and `unitCode` property.  The unfortunate part of this is that `unitCode` is a UN/CEFACT code and, if you look at the codes in [their XML Schemas](http://www.unece.org/cefact/xml_schemas/index.html) , you'll see all kinds of odd units and codes that aren't a good match for SI units nor their commonly used symbols.  Yet, this type came from valid uses in the [Good Relations vocabulary](http://www.heppnetz.de/projects/goodrelations/) and, in that context, the use of UN/CEFACT makes sense.

To further complicate this issue, there are generic properties in the schema.org types of `height` , `width` , `depth` , and `weight` and one would expect, going forward, to use these in non-UN/CEFACT contexts.  At this point, there are two choices: make a new class for quantities or modify QuantitativeValue.  If you ignore the odd name of  “QuantitativeValue” over  “Quantity” , I believe the right choices is to modify and add properties that can capture SI units and scientific quantities it a better way.

This is where the [QUDT (Quantities, Units, Dimensions, and Data Types in OWL and XML)](http://www.qudt.org/) comes into play.  While I highly recommend reading this specification, the results come down to some basic classes and properties that are very useful:

  * qudt:QuantityValue - the actual class for specifying a value that the numeric value, symbol, and unit defined.
  * qudt:symbol - the unit symbol property (a string).
  * qudt:unit - the unit defined as a qudt:Unit (essentially a URI).

QUDT has the interesting property that it defines a vocabulary of SI units as well as non-SI units that can be mapped.  Each instance of qudt:Unit has a name (a URI) and defines the necessary property values needed to map from that unit to some base SI unit.  For example, the Celsius temperature unit is defined against the Kelvin temperature SI base unit.

The result is simply that schema.org can use the names (the URIs) of the units defined by QUDT without necessarily incorporating the whole QUDT hierarchy.  If you want the full graph, you can incorporate the QUDT vocabulary and things should work out well.

My proposal to modify QuantitativeValue is simple:

  * Add a `unitSymbol` property as a string to capture the common string label of the unit.  This is distinct from unitCode that will remain a UN/CEFACT code.
  * Add a `unit` property that is a URI that names the unit.  This allows the QUDT vocabulary to be used directly.

Now the problem is getting this through whatever schema.org process exists.  A

