# K8s Monitoring with Prometheus + cAdvisor DaemonSet

```
# This step has already been done
$ git clone https://github.com/shekhar2010us/kubernetes_teach_git.git
# go to k8s_monitor1
$ cd k8s_monitor1
```

### Run cAdvisor Daemonset which K8s deploys the cAdvisor on every node in cluster
```
kubectl create -f cadvisor.yaml
```

### Run Prometheus Configmap which provides config for prometheus server. If nessasary edit the config and run
```
kubectl create -f prom-cm.yaml
```

### Apply RBAC
```
kubectl apply -f prom-rbac.yaml
```

### Now create `Deployment` which K8s creates Prometheus POD, Service with a NodePort `3090*`
```
kubectl create -f prom-deploy-svc.yaml
```

### Check deployed resources
```
kubectl get all -o wide | grep prometheus
# You will see 'pod/prometheus-*', 'service/prometheus', 'deployment.apps/prometheus', 'replicaset.apps/prometheus*'
```
Get the nodeport of the service `service/prometheus`.
In the below example, the nodeport is `30900`, yours might be different.


* Open TCP port 30900 on any node in the cluster.
* Access the Prometheus UI `http://<NODE IP>:30900`
* try selecting some metrics, check the logs and create graphs

### PromQL
1. Return all time series with the metric http_requests_total:
`http_requests_total`

2. Return the per-second rate for all time series with the http_requests_total metric name, as measured over the last 5 minutes:
`rate(http_requests_total[5m])`

3. Assuming that the http_requests_total time series all have the labels job (fanout by job name) and instance (fanout by instance of the job), we might want to sum over the rate of all instances, so we get fewer output time series, but still preserve the job dimension:
`sum(rate(http_requests_total[5m]))`

4. Http request in the last hour
`increase(http_requests_total[1h])`


### Create more deployment and services
```
# deploy a deployment
kubectl create -f nginx.yaml
# expose as service
kubectl expose deployment my-nginx --type=LoadBalancer --name=nginx-service
# access the nginx service from a browser using the nodeport (you can get this by running describe) `kubectl describe service nginx-service`

# Check the Prometheus UI again
```

### Destroy all resources
```
kubectl delete -f cadvisor.yaml
kubectl delete -f prom-cm.yaml
kubectl delete -f prom-rbac.yaml
kubectl delete -f prom-deploy-svc.yaml
kubectl delete -f nginx.yaml
kubectl delete service/nginx-service
```


