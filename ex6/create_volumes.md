# Creating Volumes


### Create new pod with shared volume



Use a repo to create a new pod with shared colume

```

        kubectl create -f pod.yaml
	kubectl describe pod sharevol
```

Exec into one of the containers c1
```
	kubectl exec sharevol -it -c c1 -- bash
```
Use these bash commands to mount the shared volume
```
	mount | grep xchange
```
Save some data to volume
```
	echo 'some data' > /tmp/xchange/data
```
Exit the container and exec into the second container
```
	kubectl exec sharevol -it -c c2 -- bash
```
Mount the Volume and see if you can read from the shared volume
```
	mount | grep /tmp/data

	cat /tmp/data/data
```

### Cleanup

```

Delete all pods and volumes

	kubectl delete po,svc --all

```

