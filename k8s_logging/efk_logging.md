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
# verify
kubectl get all -o wide -n logging
curl <cluster-ip-es-service>:9200

# Kibana
helm install --name kibana stable/kibana --set env.ELASTICSEARCH_URL=http://elasticsearch:9200 --set image.tag=6.3.2 --namespace logging
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
kubectl edit service/kibana -n logging
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


