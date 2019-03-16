# CICD(Jenkins) Integration with Kubernetes

## Creating a Jenkins Docker Container

You will be able to execute the below commands from any machine with docker, kubernetes and mvn installed. And for deploying to a Kubernetes cluster on AWS, that machine's kubeconfig should point to the correct cluster and the server urls.

```
apt-get install -y maven
# Go to the correct directory on your terminal window.
cd /Users/sree/docker/jenkins

# Create the Jenkins container
docker run -itd -e JENKINS_USER=$(id -u) --rm -p 8124:8080 -p 50000:50000 \
-v /Users/sree/vms/docker/jenkins/jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-v ~/.kube:/root/.kube \
-v ~/.docker-pass:/var/jenkins_home/.docker_pass \
-v /Users/sree/.minikube:/Users/sree/.minikube \
--name my-jenkins schogini/my-jenkins-img
```
Here, the ~/.docker-pass specifies the file where your DockerHub password is stored. Otherwise specify the correct file with the password.

## Jenkins pipeline

Step 1: Create a new pipeline job in Jenkins

Step 2: Get the pipeline script from the url: https://github.com/schogini/java-war-junit-add/blob/master/Jenkinsfile
Note:
1. In the pipeline script, adapt the parameters with values for the "JENKINSDIR" for Jenkins home directory path on your local machine, "MVNCACHE" for Maven Cache location on your local machine (first time this will download the Maven cache but from next time onwards, the build should happen faster) and "DOCKER_U" for your DockerHub username.
2. This pipeline script will be cloning the repo: https://github.com/schogini/java-war-junit-add.git. This repo contains the ansible directory, which has the Ansible playbooks used by the pipeline. Also it has the kubernetes directory, which has the yaml file used for creating service by the pipeline script.

Step 3: Execute the Jenkins job.

Step 4: This will clone the source code, test and build it and will deploy it as a service to AWS with service type as LoadBalancer.

## To test the system.

```
[BROWSE ON A BROWSER]
# Browse using the Load balancer url and the LoadBalancer Endpoint port 8283.
<your_load_balancer_url>:8283/webapp/
```

## Cleanup

Delete the AWS resources and then terminate the Jenkins server container.

