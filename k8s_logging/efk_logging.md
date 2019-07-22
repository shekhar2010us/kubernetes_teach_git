# Logging using EFK

### 
```
# This step has already been done
$ git clone https://github.com/shekhar2010us/kubernetes_teach_git.git
# go to k8s_logging
$ cd k8s_logging
```

### Deploy ES, Kibana and fluentd bit roles
```
kubectl create ns logging

# Elasticsearch
kubectl run elasticsearch --image=docker.elastic.co/elasticsearch/elasticsearch:6.3.2 -n logging
kubectl expose deploy elasticsearch --port 9200 -n logging

## check if your ES pod is getting killed, check the logs. One of the reasons may be max_map_memory. If that's the case.
### delete the namespace
### sudo sysctl -w vm.max_map_count=262144
### repeat creating namespace and creating ES resources

# verify
kubectl get all -o wide -n logging
curl <cluster-ip-es-service>:9200

# Check if you have previous version of helm kibana installed
helm list
# if you see kibana, delete it
helm del --purge kibana

# Kibana
export ELASTICSEARCH_URL=http://elasticsearch:9200

helm install stable/kibana --name kibana-v1 --set env.ELASTICSEARCH_URL=${ELASTICSEARCH_URL} --set files.kibana.yml.elasticsearch.url=${ELASTICSEARCH_URL} --set service.externalPort=5601 --namespace logging


# verify
curl -D - <cluster-ip>:5601

# Archive(do not use)- helm install --name kibana stable/kibana --set env.ELASTICSEARCH_URL=http://elasticsearch:9200 --set image.tag=6.3.2 --namespace logging

# verify
kubectl -n logging get pods -l "app=kibana"
kubectl get all -n logging

# Fluentd bit
kubectl apply -f fluent-bit-service-account.yaml
kubectl apply -f fluent-bit-role.yaml
kubectl apply -f fluent-bit-role-binding.yaml
```

### Config Map
This config map will be used as the base configuration of the Fluent Bit container. Keywords such as INPUT, OUTPUT, FILTER, and PARSER in this file are used.

```
# Fluentd configmap
kubectl apply -f fluent-bit-configmap.yaml

# Fluentd daemonset
kubectl apply -f fluent-bit-ds.yaml

# verify: you should see elasticsearch, fluent-bit and kibana pods
kubectl get pods -n logging
```

### Populate logs

```
kubectl run nginx --image=nginx -n logging
kubectl port-forward <nginx-pod-name> 8081:80 -n logging &

# curl few times
curl localhost:8081

# check logs in ES
curl <cluster-ip-es-service>:9200/_cat/indices?v
# copy the log-stash-index name
http://<cluster-ip-es-service>:9200/<logstash-index-name>/_search?pretty=true&q={'matchAll':{''}}

# change the ES type of service (change ClusterIP to NodePort)
kubectl edit service/elasticsearch -n logging

# change the kibana type of service (change ClusterIP to NodePort)
kubectl edit service/kibana-v1 -n logging
```

### Check in browser
1. `http://<public-ip>:<kibana-nodeport>`
2. Go to `Management` -> `Index Patterns`
3. Search `logstash*` -> next step -> select `@timestamp` in configure settings -> `create index patterns`
4. Go to `discover` and discover logs


### Cleanup

```
kubectl delete ns logging

helm ls --all
# if you find kibana in helm, delete and purge it
helm del --purge kibana
```


<br><br><br>
#### Alternative to not changing the kibana service type
```
kubectl port-forward kibana-7f555f4dc5-wdvxs 5601 -n logging
export POD_NAME=$(kubectl get pods --namespace logging -l "app=kibana,release=kibana" -o jsonpath="{.items[0].metadata.name}")
echo "Visit http://127.0.0.1:5601 to use Kibana"
kubectl port-forward --namespace logging $POD_NAME 5601:5601
```


