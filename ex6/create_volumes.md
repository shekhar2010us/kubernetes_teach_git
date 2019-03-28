# Creating Volumes

### Create new pod with shared volume

Create a pod with multiple containers with shared volume
```
kubectl create -f pod.yaml
kubectl describe pod sharevol
# check the `Mounts` in each container. You will see something like `/var/run/secrets/kubernetes.io/serviceaccount`
# Go to a container and check the path, you will see `ca.cert`, `namespace` and `token`. The three files in both containers will be same, as this is the token being used to authenticate the shared volume across both containers
```

Exec into the containers c1 and save some data
```
kubectl exec sharevol -it -c c1 -- bash
echo 'some data' > /tmp/xchange/data
```

Exit the container and exec into the second container
```
kubectl exec sharevol -it -c c2 -- bash
cat /tmp/data/data
```

Exit the container

### Cleanup
Delete all pods and volumes
```
kubectl delete po sharevol
```

