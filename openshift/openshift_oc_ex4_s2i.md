# OpenShift CLI - Deploy application using S2I


### Deploy application using Source to Image

Goal for this exercise is to use `OC CLI` to deploy a simple application and understand how `OC CLI` relates to `kubectl`. 
<p><b> Steps needed to perform are mentioned below </b>

```
- use the existing project <your-name>-firstproject
- Create app for deploying with s2i using git – "https://github.com/openshift-roadshow/nationalparks-katacoda"
- Scale up pod; Check logs; Check events
- Check Image Stream
- Create route to expose external service
```

#### CODE BLOCK


- <b>Create a new app:</b>

```
## Command

```

- <b>Check and describe resources</b>

```
## Command
oc get all -o wide

## you will see the list of deploymentconfig, service, rc, pod, imagestream belonging to the current project

## Other Commands
oc get pod
oc get dc
oc describe service/nationalparks-katacoda
oc get event
oc edit service/nationalparks-katacoda
oc logs pod/<pod_name>
oc logs dc/nationalparks-katacoda
oc get bc -o wide
oc get is

oc get pod --all-namespaces -o wide
# The above command need sufficient access to see all pods in all namespaces. In our current setting, this access is not provided to a free user.

oc exec -it <nationalparks-katacoda-pod_name> /bin/bash
# if you run {exec}, this takes you to the command prompt of the container, you will need to {exit} to come back to local terminal
```

- <b>Scale the application</b>

```
## Command
oc describe dc nationalparks-katacoda

## Output expected


## Command
oc scale --replicas=2 dc nationalparks-katacoda

## Output expected


# Command
oc describe dc nationalparks-katacoda
# Upon describing again, you can see that the new replica is now 2.
```

- <b>Expose the service outside openshift cluster</b>

```
## Command
oc describe service/nationalparks-katacoda


## Command
oc expose service nationalparks-katacoda --name=nationalparksmap --port=8080

## Output expected
route.route.openshift.io/nationalparksmap exposed
-- This creates a new route


## Command
oc get routes -o wide

## Output expected

-- Open a browser and check if HOST/PORT opens up a map visualizer
-- Note:- The service remains {ClusterIP}
-- You can describe the route to see its details

## Command
oc describe route/nationalparksmap
```


- <b>Clean up the project</b><br>
The limitation of using OpenShift Online is that you do not have sufficient permission to delete the project using CLI which are created in web-console. But if you created a project in CLI, you should be able to delete it.

```
## Command
oc delete project <your project name>

## Output expected
project.project.openshift.io "<project name>" deleted

## Command
oc projects

## Output expected
You are not a member of any projects. You can request a project to be created with the 'new-project' command.
```

