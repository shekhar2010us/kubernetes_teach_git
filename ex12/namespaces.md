## Namespaces Usage

Create namespaces and run pods

```
# create two namespaces
kubectl create -f dev-ns.yaml
kubectl create -f prod-ns.yaml

# create two pods with 2 namespaces
kubectl create -f dev-pod.yaml -n dev
kubectl create -f prod-pod.yaml -n prod

# Search for pods
kubectl get pods
kubectl get pods -n dev
kubectl get pods -n prod

```


## Restrict accessing prod pod from other namespace

```
kubectl create -f deny-from-other-ns.yaml
# this blocks accessing `prod` pod from any other namespace

## verify
kubectl get pods -o wide -A | grep nginx
# copy the IP of the two pods (nginx-dev and nginx-prod)

# go to prod-pod
kubectl exec -it nginx-prod -n prod /bin/bash
apt-get update
apt-get install -y iputils-ping
ping <nginx-dev-ip>
ping <nginx-prod-ip>
# both should work

# go to dev-pod
kubectl exec -it nginx-dev -n dev /bin/bash
apt-get update
apt-get install -y iputils-ping
ping <nginx-dev-ip>
ping <nginx-prod-ip>
# ping to prod should not work
```

## cleanup

```
kubectl delete ns dev
kubectl delete ns prod
```


