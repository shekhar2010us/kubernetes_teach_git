## Labels Usage

Create a bunch of pods with various labels, so we can operate on these pods 
(https://github.com/abhikbanerjee/Kubernetes_Exercise_Files/blob/master/helper_yaml_files/Ex_labels/sample-infrastructure-with-labels.yml)

Let’s take a look at what we have created:

```
# kubectl get po
```
You can get more details by showing and displaying the labels:

```
# kubectl get po --show-labels
```
## Create a list of Pods with labels

Use Sample Infrastructure to create a bunch of Pods (even though in real life we don't create pods)

```
kubectl create -f sample-infrastructure-with-labels.yml (creates a bunch of pods with labels)
```

## Use various Selectors for pods

Now we use various selectors to search in labels to pull out pods, and delete them

```
kubectl get pods --selector env=production --show-labels
or
kubectl get pods -l env=production --show-labels
```

We can use and search multiple labels , this represents and
```
kubectl get pods -l env=production,dev-lead=amy --show-labels
```
We can also have the not equal to operator
```
kubectl get pods -l env=production,dev-lead!=amy --show-labels 
```
Get the pods, which are in a list of versions - we use the in operator
```
kubectl get pods -l 'release-version in (1.0,2.0)' --show-labels
```
Get the pods, which are in a list of versions - we use the notin operator
```
kubectl get pods -l 'release-version notin (1.0,2.0)' --show-labels
```
## add a label on an existing pod and delete the label 

add a label to an existing pod
```
kubectl label po/helloworld app=helloworldapp --overwrite
```
delete a label to an existing pod
```
kubectl label po/helloworld app-  (remove the label)
```

# Delete pods, which match some of the given pods [delete, get with a specific label, works for deployment, replication set too]
```
kubectl delete pods -l dev-lead=karthik 
```
delete all pods which belong to the environment production
```
kubectl delete pods -l env=production 
```

Ref:- https://www.linkedin.com/learning/learning-kubernetes/next-steps


