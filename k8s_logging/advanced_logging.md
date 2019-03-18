# K8s Advanced Logging (install using Helm)

### 
```
# This step has already been done
$ git clone https://github.com/shekhar2010us/kubernetes_teach_git.git
# go to k8s_logging
$ cd k8s_logging
```

### Create a namespace
```
kubectl create ns kube-logging
```

### Installation
```
# install elasticsearch
kubectl create -f elasticsearch_svc.yaml
kubectl create -f elasticsearch_statefulset.yaml

# verify
kubectl get services --namespace=kube-logging
kubectl get statefulset.apps -n kube-logging
```

### Destroy all resources
```
kubectl delete -f elasticsearch_svc.yaml
kubectl delete -f elasticsearch_statefulset.yaml
```


