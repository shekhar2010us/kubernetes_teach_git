# K8s Basic Logging

```
# This step has already been done
$ git clone https://github.com/shekhar2010us/kubernetes_teach_git.git
# go to k8s_logging
$ cd k8s_logging
```

### Run a pod and check logs
```
kubectl create -f basic-logging.yaml
```

### Check logs
```
kubectl logs pod/counter
```

### Destroy all resources
```
kubectl delete -f basic-logging.yaml
```

