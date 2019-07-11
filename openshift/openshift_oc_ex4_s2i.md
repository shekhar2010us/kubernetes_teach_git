# OpenShift CLI - Deploy application using S2I


### Deploy application using Source to Image

Goal for this exercise is to use `OC CLI` to deploy a simple application and understand how `OC CLI` relates to `kubectl`. 
<p><b> Steps needed to perform are mentioned below </b>

```
- use the existing project <your-name>-secondproject
- Create app for deploying with s2i using git – "https://github.com/shekhar2010us/openshift-helloworld.git"
- Scale up pod; Check logs; Check events
- Check Image Stream
- Create route to expose external service
```

#### CODE BLOCK

#### <b>Fork and clone a git repo</b>
1. Fork the git project into your local - https://github.com/shekhar2010us/openshift-helloworld.git
2. `git clone <your repository>`


- <b>Create a new app:</b>

```
## Command
oc new-app openshift/wildfly-100-centos7:latest~<your git repo>
```

- <b>Check and describe resources</b>

```
## Command
oc get all -o wide

## you will see the list of deploymentconfig, service, rc, pod, imagestream belonging to the current project

## Other Commands
oc get pod
oc get dc
oc describe service/openshift-helloworld
oc get event
oc edit service/openshift-helloworld
oc logs pod/<pod_name>
oc logs dc/openshift-helloworld
oc get bc -o wide
oc get is

oc get pod --all-namespaces -o wide
# The above command need sufficient access to see all pods in all namespaces. In our current setting, this access is not provided to a free user.

oc exec -it <openshift-helloworld-pod_name> /bin/bash
# if you run {exec}, this takes you to the command prompt of the container, you will need to {exit} to come back to local terminal
```

- <b>Scale the application</b>

```
## Command
oc describe dc openshift-helloworld

## Output expected


## Command
oc scale --replicas=2 dc openshift-helloworld

## Output expected


# Command
oc describe dc openshift-helloworld
# Upon describing again, you can see that the new replica is now 2.
```

- <b>Expose the service outside openshift cluster</b>

```
## Command
oc describe service/openshift-helloworld


## Command
oc expose service openshift-helloworld --name=openshift-helloworld --port=8080

## Output expected
route.route.openshift.io/openshift-helloworld exposed
-- This creates a new route


## Command
oc get routes -o wide

## Output expected

-- Open a browser and check if HOST/PORT opens up a map visualizer
-- Note:- The service remains {ClusterIP}
-- You can describe the route to see its details

## Command
oc describe route/openshift-helloworld
```

----------

## <b>Re-build the app</b><br>

1. Make changes in the index.html file
2. Push the change to git
3. In the web-browser, Go to "builds", and click on "start-build"
4. You should see the change that you made in "index.html" in the web browser for the app

