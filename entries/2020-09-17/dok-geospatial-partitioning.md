title: Data on Kubernetes meetup - Geospatial Sensor Networks and Partitioning Data
author: Alex Miłowski
published: 2020-09-17T14:00:00-08:00
updated: 2020-09-17T14:00:00-08:00
keywords:
- python
- redis
- air quality
- AQI
- Kubernetes
- data science
content: |
  # Data on Kubernetes meetup - Geospatial Sensor Networks and Partitioning Data

  I recently gave a talk at the
  [Data on Kubernetes meetup on September 15th, 2020](https://www.meetup.com/Data-on-Kubernetes-community/events/273254207/)
  where I presented my research and experience with publishing and using
  geospatial sensor data on the Web. I spoke a bit about the challenges of
  reliably collecting and processing geospatial sensor data (e.g., weather
  station or air quality sensor data). I also went through the
  evolution of some of my work towards Kubernetes-based deployments. Finally,
  I demonstrated a Redis-based application for air quality measurements.

  ## Abstract

  We use resources like weather reports or air quality measurements to navigate the world. These resources become especially important when faced by extreme events like the current wildfires in the Western USA. The data for the reports, predictions, and maps all start as realtime sensor networks.

  In this talk, Alex will present some of his research into scientific data representation on the Web and how the key mechanism is the partitioning, annotation, and naming of data representations. We’ll take a look at a few examples, including some recent work on air quality data relating to the current wildfires in the western USA. We’ll explore the central question of how geospatial sensor network data can be collected and consumed within K8s deployments.

  ## Video and Podcast

  <iframe width="560" height="315" src="https://www.youtube.com/embed/D5WsvsRvH5Q" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

  <iframe src="https://anchor.fm/dokcommunity/embed/episodes/Data-on-kubernetes-community-9-Geospatial-Sensor-Networks-and-Partitioning-Data-ejpi1r/a-a386ci2" height="102px" width="400px" frameborder="0" scrolling="no"></iframe>

  ## Code

  Github: [alexmilowski/redis-aqi](https://github.com/alexmilowski/redis-aqi)

  ## Presentation

  <iframe width="560" height="315" src="geospatial-sensor-networks-and-partitioning-data.pdf" frameborder="0" scrolling="no"></iframe>
