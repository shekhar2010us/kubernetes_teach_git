# OpenShift CLI - Deploy application using Templates


## Steps in the exercise

```
- Create a new project
- Add a template
- Use the template to create app
```


### Steps

#### <b>Create a new project and add a template</b><br>

```
oc new-project <yourname>-parksapp --display-name="Baseball Parks Application Stack"

# Download the file
https://github.com/shekhar2010us/kubernetes_teach_git/blob/master/openshift/mlbparks-template.json
to local with name: mlbparks-template.json

oc create -f mlbparks-template.json
oc get templates
oc describe template mlbparks-wildfly
oc new-app --file mlbparks-template.json -p APPLICATION_NAME=mlbparks

```

-------
