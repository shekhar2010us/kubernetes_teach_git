# K8s - Service Discovery Lab

## Creating Service and Replication Controller

```
[ON MASTER NODE]
# Creating Replication Controller
kubectl apply -f https://raw.githubusercontent.com/openshift-evangelists/kbe/master/specs/sd/rc.yaml

# Creating a Service named thesvc
kubectl apply -f https://raw.githubusercontent.com/openshift-evangelists/kbe/master/specs/sd/svc.yaml
```

## Connecting to the service from within cluster.

Now we want to connect to the thesvc service from within the cluster, say, from another service. To simulate this, we create a jump pod in the same namespace (default, since we didn’t specify anything else):
```
[ON MASTER NODE]
# Creating a jump pod
kubectl apply -f https://raw.githubusercontent.com/openshift-evangelists/kbe/master/specs/sd/jumpod.yaml

# The DNS add-on will make sure that our service thesvc is available via the FQDN thesvc.default.svc.cluster.local from other pods in the cluster. Let’s try it out:
kubectl exec -it jumpod -c shell -- ping thesvc.default.svc.cluster.local

# The answer to the ping tells us that the service is available via the cluster IP <your_cluster_ip>. We can directly connect to and consume the service (in the same namespace) like so:
kubectl exec -it jumpod -c shell -- curl http://thesvc/info
```
Note: The from IP address from the last command execution is the cluster-internal IP address of the jump pod.

## To access a service that is deployed in a different namespace than the one you’re accessing it from.

```
[ON MASTER NODE]
# Creating a namespace called other.
kubectl apply -f https://raw.githubusercontent.com/openshift-evangelists/kbe/master/specs/sd/other-ns.yaml

# Creating a Replication Controller in the namespace other.
kubectl apply -f https://raw.githubusercontent.com/openshift-evangelists/kbe/master/specs/sd/other-rc.yaml

# Creating a service thesvc in the namespace other.
kubectl apply -f https://raw.githubusercontent.com/openshift-evangelists/kbe/master/specs/sd/other-svc.yaml

# Now we can consume the service thesvc in namespace other from the default namespace (via the jump pod) using the FQDN in the form $SVC.$NAMESPACE.svc.cluster.local.
kubectl exec -it jumpod -c shell -- curl http://thesvc.other/info
```

## Cleanup
```
kubectl delete pods jumpod
kubectl delete svc thesvc
kubectl delete rc rcsise
kubectl delete ns other
```

