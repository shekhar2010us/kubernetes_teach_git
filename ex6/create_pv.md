# Create-Persistent-Volume

We shall use the 'yaml' files from the current directory 

## Create your PersistentVolumes and PersistentVolumeClaims

To deploy the PVC, run:
```
kubectl apply -f mysql-pvc.yaml
kubectl apply -f wordpress-pvc.yaml
```

Check to see if your claims are bound:
```
kubectl get pvc

```

## Setup MySQL

Create a Kubernetes Secret to store the password for the database:

```
kubectl create secret generic mysql --from-literal=password=12345
```

The mysql.yaml manifest describes a Deployment with a single instance MySQL Pod which will have the MYSQL_ROOT_PASSWORD environment variable whose value is set from the secret created. The mysql container will use the PersistentVolumeClaim and mount the persistent disk at /var/lib/mysql inside the container.


Deploy manifest file `mysql.yaml`
```
kubectl create -f mysql.yaml
```

Check to see if the pod is running
```
kubectl get pod -l app=mysql
```

Deploy the manifest `mysql-service.yaml`
```
kubectl create -f mysql-service.yaml
```

Check to see if service was created
```
kubectl get service mysql
```

## Deploy Wordpress

Use the `wordpress.yaml` manifest
This manifest describes a Deployment with a single instance WordPress Pod. This container reads the WORDPRESS_DB_PASSWORD environment variable from the database password Secret you created earlier.

This manifest also configures the WordPress container to communicate MySQL with the host address mysql:3306. This value is set on the WORDPRESS_DB_HOST environment variable. We can refer to the database as mysql, because of Kubernetes DNS allows Pods to communicate a Service by its name.

Deploy the Manifest
```
kubectl create -f wordpress.yaml
```

Check to see if the pod is running
```
kubectl get pod -l app=wordpress
```

### Is there an Error or pending status?
hint:- Do we need to create an object to link it to the PVC (persistent Volume Claim).

### Solution

Delete the PV, PVC using the
```
kubectl delete pv --all
kubectl delete pvc --all
```

Create the 2 directories
```
mkdir -p /root/my_test_vol
mkdir -p /root/my_test_vol_wp
```

Then recreate the PV, and the PVC again
```
kubectl create -f mysql-pv.yaml -f wordpress-pv.yaml
kubectl create -f mysql-pvc.yaml -f wordpress-pvc.yaml
```
On Doing the get on PV, and PVC we should see the PVC binded to the PV's
```
kubectl get pv,pvc -o wide
```
### Expose the wordpress service

In the previous step, you have deployed a WordPress container which is not currently accessible from outside your cluster as it does not have an external IP address.

To expose your WordPress application to traffic from the internet using a load balancer (subject to billing), you need a Service with type:LoadBalancer.

Create the wordpress-service.yaml

```
apiVersion: v1
kind: Service
metadata:
  labels:
    app: wordpress
  name: wordpress
spec:
  type: LoadBalancer
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
  selector:
    app: wordpress

```


To deploy this manifest file, run:

```
kubectl create -f wordpress-service.yaml
```

Check to see if the pod is running

```
kubectl get svc -l app=wordpress

```

In the output above, the EXTERNAL-IP column will show the public IP address created for your blog. Save this IP address for the next step.

## Visit your wordpress blog

After finding out the IP address of your blog, point your browser to this IP address and you will see the WordPress 
installation screen as follows.  Go throught the basic setup to make sure that stateful data is saved to your database.

## Test data persistence on failure

With PersistentVolumes, your data lives outside the application container. When your container becomes unavailable and gets rescheduled onto another compute instance by Kubernetes, Kubernetes Engine will make the PersistentVolume available on the instance that started running the Pod.

Study your running pods and the node names

```
kubectl get pods -o=wide

```

Now delete the mysql pod:

```

kubectl delete pod -l app=mysql

```

Once the mysql pod is deleted, the deployement controller will notice the pod is now down and recreate a new Pod.  You can refresh your wordpress UI and see that the state of your wordpress application is saved!


View your pods again and see that a new version pod is up and running.

```
kubectl get pods -o=wide

```


## Cleaning up

Delete the wordpress service

```
kubectl delete service wordpress
```

Delete the PersistantVolumes

```
kubectl delete pvc wordpress-volumeclaim
kubectl delete pvc mysql-volumeclaim
```

