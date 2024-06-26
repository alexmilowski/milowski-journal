---
title: "Restlet is Awesome!"
date: "2008-09-25T12:39:47-07:00"
url: "/journal/entry/2008-09-25T12:39:47-07:00/"
params:
  author: Alex Miłowski
keywords: []
---


# Restlet is Awesome!

[Restlet](http://www.restlet.org) is really an amazing project.  It is so easy to create a REST-oriented service.

For example, here's an example of a hello world service:

```
public class HelloWorld extends Application {
   public HelloWorld(Context context) {
      super(context);
   }

   public Restlet createRoot() {
       Router router = new Router(getContext());

       router.attach("/hello",new Restlet(getContext()) {
           public void handle(Request request, Response response) {
                response.setStatus(Status.SUCCESS_OK);
                response.setEntity(new StringRepresentation("Hello World!",MediaType.TEXT_PLAIN);
           }
       });

       router.attach("/goodbye",new Restlet(getContext()) {
           public void handle(Request request, Response response) {
                response.setStatus(Status.SUCCESS_OK);
                response.setEntity(new StringRepresentation("Goodbye Cruel World!",MediaType.TEXT_PLAIN);
           }
       });       return router;
   }
}
```
Here we have an application that responds to two resource paths: "/hello" and "/goodbye".  Each is is associated by attaching a "restlet" to a router.

Now, we could get more complicated and handle the requests more elegantly, but the above demonstrates how easy it is to route requests to instances that can handle them.

