## Kubernetes UI dashboard setup

Assumption:- Kubernetes is installed and configured

## Install dashboard

### Create resources required for dashboard
```bash

# dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml

# create heapster: which is the only supported metrics provider currently
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml

# Influxdb backend for data collection
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml

# create the heapster cluster role binding for the dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml

## create a yaml file named "dash-admin-service-account.yaml" to add an admin role to access dashboard

vi dash-admin-service-account.yaml

# add the below content
apiVersion: v1
kind: ServiceAccount
metadata:
  name: dash-admin
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: dash-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: dash-admin
  namespace: kube-system
  
# create the resource
kubectl apply -f dash-admin-service-account.yaml


```

Now Kubernetes dashboard is deployed, and we have an administrator service account that can be used to view and control the cluster, now connect to the dashboard with that service account.

### Edit dashboard service to expose the service to view from outside
```bash
kubectl -n kube-system edit service kubernetes-dashboard

# change type of service from 'ClusterIP' to 'NodePort' and save
```

### Retrieve an authentication token for the dash-admin service account
```bash
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep dash-admin | awk '{print $1}')

# copy the token from above command
```


### URL to access dashboard:
```bash
https://<public-ip>:<nodeport>/#!/overview?namespace=default​

# public-ip: IP of your machine
# Nodeport: port (for service "kubernetes-dashboard") can be accessed by running the command [kubectl get services -o wide --all-namespaces]
```


## Test Dashboard
- Check 'cluster' - it shows namespaces, nodes, volumes, roles, storage classes

- Click on individual resources
- Check the 'overview', 'workloads' - for all namespaces
- Create nginx deployment using kubectl and check in dashboard
	```bash
	kubectl run nginx --image=nginx --replicas=3
	```
	```bash
	kubectl expose deployment nginx --port=80 --type=LoadBalancer
	```
- You will see 1 deployment, 3 pods, 1 replicaset, 1 service

- Click on a resource & you will show details (same as `describe`)
- Scale the deployment to 5
- Confirm scaling in dashboard and CLI
- View/edit yaml for nginx deployment
- It opens an editor, change replica to 7
- Confirm scaling in dashboard and CLI
- Delete the nginx deployment and nginx service from dashboard
- Create a file and add below content, upload and confirm in dashboard and CLI

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
```

- Expose as service in CLI:
```bash
kubectl expose deployment nginx-deployment --port=80 --type=LoadBalancer
```
- Confirm in cli, dashboard and a browser

<br>
*** What have we done so far. <br>
In this exercise, we setup a dashboard, viewed and created resources using dashboard
