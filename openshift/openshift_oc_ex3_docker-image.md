# OpenShift CLI - Deploy application using Docker image


### Login to OpenShift CLI
Navigate to top right corner in OpenShift Online and click on `Copy Login Command`. This should take you to a page and provide full command with OpenShift cluster host, port and user token. 

A sample format is shown below, please note the values of host and port might be `different for different users`.

<b>`oc login --token=Y2khRGyMYgFpC4Juev8VHUbiroc7qauEl48098s1td8 --server=https://api.us-west-2.online-starter.openshift.com:6443`</b>

Use your terminal to login to oc, you should expect a success message like shown below

```
Logged into "https://api.us-west-2.online-starter.openshift.com:6443" as "shekhar2010us@gmail.com" using the token provided.

You don't have any projects. You can try to create a new project, by running

    oc new-project <projectname>
```


### Deploy application using Docker image

Goal for this exercise is to use `OC CLI` to deploy a simple application and understand how `OC CLI` relates to `kubectl`. 
<p><b> Steps needed to perform are mentioned below </b>

```
- Create a new project <your-name>-secondproject
- Create app for deploying with image – "openshiftroadshow/parksmap-katacoda:1.2.0"
- Scale up pod; Check logs; Check events
- Check Image Stream
- Create route to expose external service
```

#### CODE BLOCK

- <b>Create a new project:</b>
<br><u>Note:</u> If using OpenShift online version, only one project per user is allowed, as it belongs to the experimental plan. </i>


```
## Command
oc new-project <yourname>-secondproject --display-name="<provide display name>" --description="<provide description>"

## Logs expected
Now using project "shekhar-secondproject" on server "https://api.us-west-2.online-starter.openshift.com:6443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app django-psql-example

to build a new example application in Python. Or use kubectl to deploy a simple Kubernetes application:

    kubectl create deployment hello-node --image=gcr.io/hello-minikube-zero-install/hello-node

```

- <b>Create a new app:</b>

```
## Command
oc new-app openshiftroadshow/parksmap-katacoda:1.2.0  --name="parksmap-katacoda"

## Logs expected
--> Found Docker image 10df9e8 (2 weeks old) from Docker Hub for "openshiftroadshow/parksmap-katacoda:1.2.0"

    Python 3.5 
    ---------- 
    Python 3.5 available as container is a base platform for building and running various Python 3.5 applications and frameworks. Python is an easy to learn, powerful programming language. It has efficient high-level data structures and a simple but effective approach to object-oriented programming. Python's elegant syntax and dynamic typing, together with its interpreted nature, make it an ideal language for scripting and rapid application development in many areas on most platforms.

    Tags: builder, python, python35, python-35, rh-python35

    * An image stream tag will be created as "parksmap-katacoda:1.2.0" that will track this image
    * This image will be deployed in deployment config "parksmap-katacoda"
    * Port 8080/tcp will be load balanced by service "parksmap-katacoda"
      * Other containers can access this service through the hostname "parksmap-katacoda"

--> Creating resources ...
    imagestream.image.openshift.io "parksmap-katacoda" created
    deploymentconfig.apps.openshift.io "parksmap-katacoda" created
    service "parksmap-katacoda" created
--> Success
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose svc/parksmap-katacoda' 
    Run 'oc status' to view your app.
```

- <b>Check and describe resources</b>

```
## Command
oc get all -o wide

## you will see the list of deploymentconfig, service, rc, pod, imagestream belonging to the current project

## Other Commands
oc get pod
oc get dc
oc describe service/parksmap-katacoda
oc get event
oc edit service/parksmap-katacoda
oc logs pod/<pod_name>
oc logs dc/parksmap-katacoda
oc get is

oc get pod --all-namespaces -o wide
# The above command need sufficient access to see all pods in all namespaces. In our current setting, this access is not provided to a free user.

oc exec -it <pod_name> /bin/bash
# if you run {exec}, this takes you to the command prompt of the container, you will need to {exit} to come back to local terminal
```

- <b>Scale the application</b>

```
## Command
oc describe dc parksmap-katacoda

## Output expected
Name:		parksmap-katacoda
Namespace:	shekhar-secondproject
Created:	4 minutes ago
Labels:		app=parksmap-katacoda
Annotations:	openshift.io/generated-by=OpenShiftNewApp
Latest Version:	1
Selector:	app=parksmap-katacoda,deploymentconfig=parksmap-katacoda
Replicas:	1
Triggers:	Config, Image(parksmap-katacoda@1.2.0, auto=true)
Strategy:	Rolling
Template:
..................
You see that the replica is 1. Let's make it 2.

## Command
oc scale --replicas=2 dc parksmap-katacoda

## Output expected
deploymentconfig.apps.openshift.io/parksmap-katacoda scaled


# Command
oc describe dc parksmap-katacoda
# Upon describing again, you can see that the new replica is now 2.
```

- <b>Expose the service outside openshift cluster</b>

```
## Command
oc describe service/parksmap-katacoda

## output expected
Name:              parksmap-katacoda
Namespace:         shekhar-secondproject
Labels:            app=parksmap-katacoda
Annotations:       openshift.io/generated-by: OpenShiftNewApp
Selector:          app=parksmap-katacoda,deploymentconfig=parksmap-katacoda
Type:              ClusterIP
IP:                172.30.143.124
Port:              8080-tcp  8080/TCP
TargetPort:        8080/TCP
Endpoints:         10.129.22.42:8080,10.131.14.61:8080
Session Affinity:  None
Events:            <none>
-- you can see that the service type is {ClusterIP} - so this service is not exposed outside openshift cluster

## Command
oc expose service parksmap-katacoda --name=parksmap --port=8080

## Output expected
route.route.openshift.io/parksmap exposed
-- This creates a new route


## Command
oc get routes -o wide

## Output expected
NAME       HOST/PORT                                                                    PATH   SERVICES            PORT   TERMINATION   WILDCARD
parksmap   parksmap-shekhar-secondproject.apps.us-west-2.online-starter.openshift.com          parksmap-katacoda   8080                 None

-- Open a browser and check if HOST/PORT opens up a map visualizer
-- Note:- The service remains {ClusterIP}
-- You can describe the route to see its details

## Command
oc describe route/parksmap
```
