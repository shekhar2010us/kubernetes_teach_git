# OpenShift CLI - Deploy application using Templates


## Steps in the exercise

```
- Create a new project
- Add a template
```


### Steps

#### <b>Create a new project and add a template</b><br>

```
oc new-project <yourname>-parksapp --display-name="Baseball Parks Application Stack"

oc create -f https://github.com/openshift/origin/blob/master/examples/quickstarts/nodejs-mongodb.json
```


#### <b>Make changes that will trugger re-building the app</b><br>

1. Make changes in the index.html file
2. Push the change to git
3. In the web-browser, Go to "builds".. There should be a new build in progress
