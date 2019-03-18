# K8s Monitoring with Prometheus + cAdvisor DaemonSet + Grafana

```
# This step has already been done
$ git clone https://github.com/shekhar2010us/kubernetes_teach_git.git
# go to k8s_monitor2
$ cd k8s_monitor2
```

### Run cAdvisor Daemonset, prometheus, grafana in monitoring namespace
```
kubectl create -f cadvisor-prom-grafana.yaml
```

### Check deployed resources
```
kubectl get all -o wide -n monitoring

```
Get the nodeport of the service `prometheus`, and `grafana`.
In the below example, the nodeport for grafana:31327, prometheus:31804 

### Dashboards
* Open TCP port 31327 and 31804 on any node in the cluster.
* Access the Prometheus UI `http://<NODE IP>:31804`
* Access the Grafana UI `http://<NODE IP>:31327`
* try selecting some metrics, check the logs and create graphs

### Destroy all resources
```
kubectl delete -f cadvisor-prom-grafana.yaml
```

