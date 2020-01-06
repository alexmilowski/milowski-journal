title: SF Microservices Meetup - Going Serverless with Flask
author: Alex Miłowski
published: 2017-07-12T10:35:00-07:00
updated: 2017-07-12T10:35:00-07:00
keywords:
- python
- Flask
- Serverless
- FaaS
- AWS Lambda
- OpenWhisk
- IBM Bluemix
content: |
   I gave a talk last night (July 11th, 2017) about deploying [python Flask-based](http://flask.pocoo.org) on
   Serverless infrastructure.  You can view the slides [here](https://alexmilowski.github.io/flask-serverless/going-serverless.html) and I will publish more notes on the github repository [https://github.com/alexmilowski/flask-serverless](https://github.com/alexmilowski/flask-serverless) as necessary.

   I built a python package (see: [https://github.com/alexmilowski/flask-openwhisk](https://github.com/alexmilowski/flask-openwhisk)) for bridging between WSGI (Flask) and [OpenWhisk](http://openwhisk.incubator.apache.org). I have only tested it with Flask but it should work with
   other WSGI frameworks.

   The key takeaway is that you can deploy Flask applications with minimal changes on Serverless. Any
   changes that are necessary have to do with architectural changes for Serverless infrastructure. That
   typically comes from the fact that there is no local environment so configuration or
   local resources (e.g., files) need to be handled differently.

   Also, the [SF Microservices meetup](https://www.meetup.com/SF-Microservices/) is a great group of people. I enjoyed the talks and certainly will attend again - you should too!

   Cheers!
