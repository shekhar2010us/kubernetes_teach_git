# Service Discovery: Lab
Let us create a service names `thesvc` and a Replication Controller supervisng some pods.

```
$ kubectl apply rc.yaml
$ kubectl apply svc.yaml
```

Now we want to connect to the `thesvc` service from within the cluster, say, from another service. To simulate this, we create a jump pod in the same namespace (default, since we didn’t specify anything else).

```
kubectl apply -f jumpod.yaml
```
The **DNS add-on** will make sure that our service thesvc is available via the FQDN `thesvc.default.svc.cluster.local` from other pods in the cluster. Let’s try it out:

```
$ kubectl exec -it jumpod -c shell -- ping thesvc.default.svc.cluster.local
PING thesvc.default.svc.cluster.local (172.30.251.137) 56(84) bytes of data.
```
The answer to the ping tells us that the service is available via the cluster IP 172.30.251.137. We can directly connect to and consume the service (in the same namespace) like so:
```
$ kubectl exec -it jumpod -c shell -- curl http://thesvc/info
{"host": "thesvc", "version": "0.5.0", "from": "172.17.0.5"}
```
Note that the IP address 172.17.0.5 above is the cluster-internal IP address of the jump pod.

To access a service that is deployed in a different namespace than the one you’re accessing it from, use a FQDN in the form $SVC.$NAMESPACE.svc.cluster.local.

Let’s see how that works by creating:

* a namespace `other`
* a service thesvc in namespace other
* an RC supervising the pods, also in namespace other

```
$ kubectl apply -f other-ns.yaml
$ kubectl apply -f other-rc.yaml
$ kubectl apply -f other-svc.yaml
```
We're now in the position to consume the service `thesvc` in namespace `other` from the `default` namespace (again via the jump pod):

```
$ kubectl exec -it jumpod -c shell -- curl http://thesvc.other/info
{"host": "thesvc.other", "version": "0.5.0", "from": "172.17.0.5"}
```
Summing up, DNS-based service discovery provides a flexible and generic way to connect to services across the cluster.

You can destroy all the resources created with:

```
$ kubectl delete -f rc.yaml
$ kubectl delete -f svc.yaml
$ kubectl delete -f other-svc.yaml
$ kubectl delete -f other-rc.yaml
$ kubectl delete -f other-ns.yaml
$ kubectl delete -f jumpod.yaml
```

