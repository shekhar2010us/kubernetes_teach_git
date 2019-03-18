# K8s install helm

Helm is a package manager for Kubernetes that allows developers and operators to more easily configure and deploy applications on Kubernetes clusters.

### Step 1: Helm
First we'll install the helm command-line utility on our local machine.
```
cd ~
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > install-helm.sh
chmod u+x install-helm.sh
./install-helm.sh
```

### Step 2: Tiller
Tiller is a companion to the helm command that runs on your cluster, receiving commands from helm and communicating directly with the Kubernetes API to do the actual work of creating and deleting resources. To give Tiller the permissions it needs to run on the cluster, we are going to make a Kubernetes serviceaccount resource.

```
# create tiller serviceaccount
kubectl -n kube-system create serviceaccount tiller

# bind the tiller serviceaccount to the cluster-admin role
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller

# Now we can run helm init, which installs Tiller on our cluster, along with some local housekeeping tasks such as downloading the stable repo details:
helm init --service-account tiller

# verify
kubectl get pods --namespace kube-system
```

### Verify
```
helm repo update
helm list
```

