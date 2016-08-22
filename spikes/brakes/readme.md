To get this application running you will need to build each docker instance.  Navigate into each of the service folders and then type the following command.  Your username can be what ever.  Technically the service name can also be what ever but you are better off if the docker image you create is named with a corresponding service name.  You can find the service name in each service folder.  The name is at the top of the package.json file.

```
$ docker build -t {your username}/{service name}
```

Once you have all of the images built you can then run each of them.

Type ```docker images``` to see a list of images.  Once you see your images in the list you can run one.

```
$ docker run -p 49160:8080 -d {your username}/{service name}
```

Now you can type ```docker ps``` to see a list of running images.

You can print the output of a running instance by typing the following.

```
$ docker logs {container id}
```

Now you need to be able to test your instance.  Again type ```docker ps```.  You will notice that there is a section called ports.  You will see a long port nuber pointing at a short port number.  The long number is the port you can access the container at.  The short number is the internal  port number.  This way you can have a bunch of services running on port 8080 - but since your local environment can only have one app responding to port 8080 you need a mechanism to host all your services on unique ports.

Once we know the port the service is listening on you can use ```curl``` like this to get some output from your service.

```
$ curl -i localhost:{external port}

HTTP/1.1 200 OK
X-Powered-By: Express
Content-Type: text/html; charset=utf-8
Content-Length: 12
Date: Sun, 02 Jun 2013 03:53:22 GMT
Connection: keep-alive

Hello world
```

