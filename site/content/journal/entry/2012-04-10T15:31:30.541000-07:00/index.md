---
title: "Experiments with Big Weather Data in MarkLogic - Introduction"
date: "2012-04-10T15:31:30.541000-07:00"
url: "/journal/entry/2012-04-10T15:31:30.541000-07:00/"
params:
  author: Alex Miłowski
keywords:
  - MarkLogic
  - big data
  - weather
  - APRS
---


# Experiments with Big Weather Data in MarkLogic - Introduction

Over the past couple months, I've been experimenting with  “big data” on the web for scientific purposes. The goal is to take my research on geospatial scientific data on the web and use [MarkLogic](http://www.marklogic.com/) to create a repository for large sensor data. My current scientific area of focus is weather data (sensor data in general) that I'm collecting through the [Citizen Weather Observation Program (CWOP)](http://www.wxqa.com/) .

The data comes to me over the Internet via [APRS-IS](http://www.aprs-is.net/) , which is a home-grown peer-to-peer message relaying system.  The messages originate from both Internet and radio-based systems. Typically, the sending systems are weather stations or location trackers, but they could be just about anything. The messages are cryptic character-based packets encoding data.

All you really want to know is that:

```
DW7508>APRS,TCPXX*,qAX,CWOP-2:@140818z5303.00N/00414.20W_290/011g018t040r000P000h77b09878eCumulusDsVP
DW4331>APRS,TCPXX*,qAX,CWOP-2:@140818z3244.80N/11708.33W_137/000g...t046r...p...P000h96b10083.DsVP
DW4314>APRS,TCPXX*,qAX,CWOP-2:@140818z3835.73N/12057.58W_072/000g001t040r000p000P000h71b10214.DsVP
KF9X>APRS,TCPXX*,qAX,CWOP-2:@140819z4420.99N/08952.58W_080/001g004t034r001P001p001h91b10208v6
```
gets turned into XML:

```
<report from="dw3512" type="weather" latitude="44.903" longitude="-85.06833"
        received="2012-04-10T08:00:00Z" at="2012-04-10T08:00:00 Z" wind-dir="303" wind-speed="6" wind-gust="13"
        temperature="33" rain-hour="0" rain-midnight="0" humidity="81" pressure="10098" />
<report from="DW6820" type="weather" latitude="54.37533" longitude="2.89533"
        received="2012-04-10T08:00:00Z" at="2012-04-10T08:00:00 Z" wind-dir="272" wind-speed="9" wind-gust="19"
        temperature="43" rain-hour="1" rain-24hours="56" rain-midnight="17" humidity="78" pr essure="9662" />
<report from="DW2039" type="weather" latitude="51.24533" longitude="-2.94883"
        received="2012-04-10T08:00:00Z" at="2012-04-10T07:59:0 0Z" wind-dir="237" wind-speed="6" wind-gust="12"
        temperature="44" rain-hour="0" rain-24hours="43" rain-midnight="1" humidity="88" pr essure="9898" />
```
Note: there is no correspondence for the above examples, so don't try to parse the APRS messages to produce my XML.

Through the CWOP APRS-IS servers, somewhere around 55,000+ weather reports per hour are aggregated and available to be received.  I setup a process to receive these messages, turn them into XML, and dump them onto disk as XML documents in 5 minute segments.  I have that running now and I expect it to generate about 8-12 GB of raw XML data a month.


The goal is to load this data into MarkLogic, understand how to store such data, and expose the data on the web as a useful archive of sensor data.

