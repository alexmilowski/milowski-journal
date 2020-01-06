title: Changing Technology for the Web and Open Government?
author: Alex Miłowski
published: 2016-05-06T15:00:00-08:00
updated: 2016-05-06T15:00:00-08:00
keywords:
- Code for America
- Web
- data science
- API
- Friday Hacking
- Python
- open data
artifacts:
- kind: text/html
  location: activity.html
- kind: image/png
  location: languages-2010.png
- kind: image/png
  location: languages-2011.png
- kind: image/png
  location: languages-2012.png
- kind: image/png
  location: languages-2013.png
- kind: image/png
  location: languages-2014.png
- kind: image/png
  location: languages-2015.png
- kind: image/png
  location: languages-2016.png
- kind: image/png
  location: languages-new-2010.png
- kind: image/png
  location: languages-new-2011.png
- kind: image/png
  location: languages-new-2012.png
- kind: image/png
  location: languages-new-2013.png
- kind: image/png
  location: languages-new-2014.png
- kind: image/png
  location: languages-new-2015.png
- kind: image/png
  location: languages-new-2016.png
- kind: image/png
  location: participation-last-13weeks-top-half.png
- kind: image/png
  location: participation-last-52weeks-top-half.png
content: |
   [Code for America](https://www.codeforamerica.org) is a great organization that is helping city, county, and state governments deliver technology that serves their communities.  I was researching projects and whether there was some place I could lend my expertise when I happened to discover that [they have at API](http://codeforamerica.org/api/)!  Being a data geek, I thought it would be easier to crunch the data than navigate the website.

   Being a bit of a data science geek, I crunched the projects by organization and produced a little slide deck of the activities and technologies used by each project and by year.  For simplicity, I used word clouds rather than graphing the raw data.

   <div class='embed'><iframe src='activity.html' frameborder="0" scrolling="no"></iframe></div>

   What is interesting is to look at the technologies used by project over the years.  Back in 2010, it seems as if the focus was more on getting things onto the Web and you see various technologies circa that time period (or much before).  As time progresses, the technologies used cluster differently until you get to 2016 where there is an myriad of various things in play.

   Now, for a disclaimer, because the information isn't necessary tracking everything that has happened, the importance of one technology over another, nor whether a particular project had a successful outcome with a technology, it is not clear from the data whether there are specific trends.  What is clear is that the technologies in use have greatly expanded.  That shouldn't be a big surprise but a picture always helps confirm our suspicions.

   I am curious about the the data format and technologies that make civic projects successful.  I think the only real way to understand the technology factors in this area is to refined the data about these kinds of projects.  That probably requires a more detail survey of project owners, data collection mechanisms, and project metadata.

   The Python code, such as it is, is available in my ["goodies" project](https://github.com/alexmilowski/goodies/tree/master/data-science/cfa) on github.
