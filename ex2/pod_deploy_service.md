
## Practise creating Pods, Deployments and Services

# Create a pod, deployment and service using the Imperative method
Create a deployment nginx
```
$ kubectl run nginx-deployment --image nginx --port 80
```
Check the currently running pods, deployments, services and replica sets
```
$ kubectl get po,deploy,svc,rs -o wide
```
Expose the Deployment as a Service of Loadbalancer 
```
$ kubectl expose deploy/nginx-deployment --type=LoadBalancer --name nginx-service 
```
Check the currently running pods, deployments, services and replica sets
```
$ kubectl get po,deploy,svc,rs -o wide
```
### Check for the nginx application from url , using the IP 
Do a describe on the nginx service , using the IP try doing a curl for that port
```
$ kubectl describe svc nginx-service
```
do a 
```
$ curl <ip_address>:<port_number>

```

# Create a deployment with the name blue  (Imperative management using config files)
```
$ kubectl create -f blue.yaml
```
Check the currently running pods, deployments, services and replica sets
```
 kubectl get po,deploy,svc,rs -o wide
```

Edit the Deployment and change the replicas from 1 to 2

```
# kubectl edit deploy blue
```
Check the currently running pods, deployments, services and replica sets ( we should now see 2 pods running)
*** Note - editing a running resource will change in the resource, but that will not change your Config file. It's a good practise to make changes in the Config file for maintainability. EDIT options are mostly used for quick debugging.


```
 kubectl get po,deploy,svc,rs -o wide
```
# Use the pod.yaml file and deploy.yaml files (Examples of Imperative commands)

Create a pod using the blue.yaml file
```
$ kubectl create -f sample_pod.yaml
```
Check for the running pods, deploy, svc, rs
```
$ kubectl get po,deploy,svc,rs -o wide
```

Create a Deployment using the blue.yaml file
```
$ kubectl create -f blue.yaml
```
Try again creating the same blue deployment and see what happens (this should give an error)
```
$ kubectl create -f blue.yaml
```
Check for the running pods, deploy, svc, rs
```
$ kubectl get po,deploy,svc,rs -o wide
```

Now delete the blue, deployment and the pod that was created
```
$ kubectl delete pod pod_name

$ kubectl delete deploy blue
```
Check for the running pods, deploy, svc, rs
```
$ kubectl get po,deploy,svc,rs -o wide
```

# One example of Declarative command (use of kubectl apply)

Create a Deployment using the red.yaml file, but now using apply
```
$ kubectl apply -f red.yaml
```
Now go and edit the file and change the replicas from 1 to 3, using vi
```
$ vi red.yaml

# change the replicas to 3, save and come out
```
Check for the running pods, deploy, svc, rs
```
$ kubectl get po,deploy,svc,rs -o wide
```
Now apply these changes using the apply command
```
$ kubectl apply -f red.yaml
```
Check for the running pods, deploy, svc, rs
```
$ kubectl get po,deploy,svc,rs -o wide
```

Now delete the red,blue deployment and see the pods, and deployment going down
```
$ kubectl delete deploy blue

$ kubectl delete deploy red
```
Check for the running pods, deploy, svc, rs
```
$ kubectl get po,deploy,rs -o wide -w  # -w is like watch option to see see the changes happening
```


Ref:- https://kubernetes.io/docs/concepts/overview/object-management-kubectl/overview/,
Ref:- https://www.linkedin.com/learning/learning-kubernetes/next-steps


