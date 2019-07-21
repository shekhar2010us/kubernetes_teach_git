
## Practise creating Pods, Deployments and Services

# Create a pod, deployment and service using the Imperative method
Create a deployment nginx

```
kubectl run nginx-deployment --image nginx --port 80
```

Check the currently running pods, deployments, services and replica sets

```
kubectl get po,deploy,svc,rs -o wide
```

Expose the Deployment as a Service of Loadbalancer 

```
kubectl expose deploy/nginx-deployment --type=LoadBalancer --name nginx-service 
```

Check the currently running pods, deployments, services and replica sets

```
kubectl get po,deploy,svc,rs -o wide
```

### Check for the nginx application from url , using the IP 
Do a describe on the nginx service , using the IP try doing a curl for that port

```
kubectl describe svc nginx-service
# verify by
curl <ip_address>:<port_number>

# Other ways to verify
kubectl proxy &
curl http://localhost:8001/api/v1/namespaces/default/services/nginx-service/proxy/
curl http://$(kubectl get svc nginx-service --template='{{.spec.clusterIP}}'):80
kubectl delete svc nginx-service
kubectl delete deploy nginx-deployment
```

# Create a Service from a Pod

```
kubectl create -f sample_pod.yaml
```

Use `exec` and `logs` commands

```
IP=`kubectl describe pod/nginx-apparmor | grep -i "IP:" | awk -F" " '{print $2}'`
curl $IP:80
curl $IP:80
curl $IP:80
kubectl logs pod/nginx-apparmor
# You will see the logs

kubectl exec -it pod/nginx-apparmor /bin/bash
# this will take you to the container
# if pod has multiple containers, use -c option for container name
exit -- to come out of the container
```

Check the currently running pods

```
kubectl get po -o wide
```

Expose the pod as a service

```
kubectl expose pod nginx-apparmor --type NodePort --name nginx-apparmor-service
```

check running services again

```
 kubectl get po,deploy,svc,rs -o wide
```

#### verify

```
kubectl describe svc nginx-apparmor-service
# verify by
curl <ip_address>:<port_number>
```

### Clean up

```
kubectl delete svc nginx-service
kubectl delete deploy nginx-deployment
kubectl delete svc nginx-apparmor-service
kubectl delete pod nginx-apparmor
```
