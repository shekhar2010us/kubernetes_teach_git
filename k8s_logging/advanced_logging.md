# K8s Advanced Logging

### 
```
# This step has already been done
$ git clone https://github.com/shekhar2010us/kubernetes_teach_git.git
# go to k8s_logging
$ cd k8s_logging
```

### Installation
```
docker pull docker.elastic.co/elasticsearch/elasticsearch:6.5.4

# install elasticsearch
kubectl create -f elastic.yaml
# verify
kubectl get all -o wide
curl <public-ip>:<nodeport>

# install kibana
kubectl create -f kibana.yaml
# verify
kubectl get all -o wide
curl <public-ip>:<nodeport>

# sample app
docker build -t fluentd-node-sample:latest -f sample-app/Dockerfile sample-app
kubectl create -f node-deployment.yaml
```

### Destroy all resources
```
kubectl delete -f elastic.yaml
kubectl delete -f kibana.yaml
kubectl delete -f node-deployment.yaml
```

