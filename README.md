# Microservice Example
This repository contains an example of a microservice hosted in AWS using Elastic Container Services (ECS) and node primiarly.  The focus of this repository is to answer some common questions around designing, building, deploying, and managing a microservice.

The example application we are going to build will illustrate how to manage an external service dependancy and how to manage when that dependancy fails now and then by defining a fallback strategy that uses a different external service.  We will build a small application that shows the weather for a given zip code.  In this code base we will see a single page application that communicates with an API that is a proxy to some external weather services.

## Questions

Below are a list of common questions and their answers as illustrated in this codebase.

### How do I manage a fallback strategy for downstream or external microservices that might be failing or non-performant? 

The circuit breaker pattern is best for managing this type of problem.  When you have a service (A) that is dependant on another service (B) - which can be an internal or external service - you need a way to ensure that the downstream service responds in an acceptable amount of time, doesn't continually throw errors, or isn't totally non-responsive.  Any of these types of activities can cause a ripple effect of degraded services if you don't manage your dependancies appropriately.  This activity shouldn't be performed as a concern within the bounds of a single request - but rather should be monitored over the life of the runtime that is performing the requests to the down stream service.  This way if you notice that the SLA (speed at which the service responds to you) is not being met once now and then vs. every time you make a request - you can take an appropriate action so that your application isn't affected by this slowing service.  Fallback strategies can be written many ways: you call another service when your primary service fails, you can log a message to be processed once the failing service comes back up, you can alert an administrator, etc.  The compensating action take will be dependent upon the operation you are trying to perform.

In this example application we will use "brakes" as our implementation of the circuit breaker pattern for node.  https://www.npmjs.com/package/brakes

### How do I monitor service health in my application when I have 100 services to watch?

Hystrix is a dashboard that provides a view into all of your services and the health of each service.

![hystrix dashboard](https://i.ytimg.com/vi/zWM7oAbVL4g/maxresdefault.jpg "hystrix dashboard")

Each of the widgets in the dashboard shows a dense view of information surrounding the service.

![service information](http://3.bp.blogspot.com/-SC4iuKO8l4o/UMOTss3b4TI/AAAAAAAAAdY/w2-_vX0Vqwg/s1600/dashboard-annoted-circuit-640.png "service information")

For each service you can quickly identify the health of a service (up or down) and the traffic volume going through a given service.  You can also visualize traffic spikes, whether a circuit is closed or open average response times, errors being experienced, etc.  This dashboard is fed its information by the circuit breaker implementation (not all circuit breakers work with Hystrix - Brakes does though).

