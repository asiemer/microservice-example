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

### Monitoring

### Logging

### Alerting

### On Call

### Versioning

#### Describe difference between major, minor, and build numbers in version number

Contract break

Logic change

Additivie functionality / bug fixes

#### No breaking changes in minor builds

### Traffic drain over to new service

### Data dog for lambda visualizations

### Branching strategy to support many active versions

### Excute Lambda from node using AWS sdk

### How to deploy with infrastructure as code?  TerraForm

### How to implement a continuous deployment pipeline across multiple AWS accounts

# Prerequisites

## Docker

Depending on if you are on a mac, linux, or windows machine this step will be slightly different.  Start here https://docs.docker.com/engine/installation/

Once you have docker installed you should be able to go to a terminal window (I am using iTerm2 on mac) and type the following command:

```
docker --version
```

You should see a version listed if all went well.

## Node

New to node?  First - install node on your machine.  [Start here](https://nodejs.org/en/download/).  

Then you need to head over to [nodeschool.io](http://www.nodeschool.io) (which is free).  It will tell you all there is to know about node. But it does it through interactive training session via the command line using the node package manager (NPM).

You will need a great text editor like [Visual Studio Code](https://code.visualstudio.com/download),  [Atom](http://www.atom.io/), [Sublime Text](http://www.sublimetext.com/3), [Textmate](http://macromates.com/download), or [Brackets](http://brackets.io/).

## Amazon Web Services (AWS)

We will be hosting all of our examples in AWS so you will need to create a [free account(https://aws.amazon.com/free/) over there.  Preferably use a gmail account when signing up as you will need a few accounts in this demonstration. 

> In our example we will show you how to use multiple accounts to isolate your development, integration/staging, and production environments.  This type of isolation is great from a security perspective but also cuts down on the noise in your CI/CD scripts as well as noise in each of the accounts.  In order to keep all of these accounts on the free tier you might use gmail and their [+tag-name hack](https://support.google.com/mail/answer/12096?hl=en) to differentiate the same email when signing up for multiple accounts.

When signing up you will be prompted to add a credit card.  And Amazon will call you to verify that you are a real person (automated call).  

### AWS CLI, python, pip

Once you have an AWS account configured you will want to go grab the [AWS CLI](https://github.com/awslabs/aws-shell).  AWS CLI is a shell written in Python that gives you hints as you navigate through all the AWS services and functions.  This makes working with AWS on the command line pleasant. You will need [Python](https://www.python.org/downloads/) and an [upgraded PIP](https://pip.pypa.io/en/latest/installing/#upgrading-pip) installed to get this running.

*MAC users* I found that the docs above didn't work.  SO suggested this instead which worked for me:

```
sudo easy_install pip
```
