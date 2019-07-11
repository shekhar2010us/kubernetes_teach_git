# OpenShift CLI - Deploy application using Webhook

A `webhook` (also called a web callback or HTTP push API) is a way an application can provide other applications with real-time information or notifications. <br><br>
We can configure the GitHub code hosting service to trigger a webhook each time we push a set of changes to your project code repository. Using this tool, we can notify OpenShift when you have made code changes and thus initiate rebuild and redeploy‐ ment of our application.


Goal for this exercise is to use `OC CLI` to deploy a simple application using git <b>webhook</b>. 

## Steps in the exercise

```
- Use the existing project  <your-name>-secondproject
- Find the webhook URI for your particular application
- Add webhook in your git project
- Make changes, push to git, these changes will trigger a new build
```


### Steps

#### <b>Find Git Webhook for your application:</b><br>
Navigate to the `Builds` page for the `helloworld application` in the OpenShift `web console` and click the `Configuration` tab
<br>
There will be trigger section.
Copy `GitHub Webhook URL:`

For me, it's `https://api.pro-us-east-1.openshift.com/apis/build.openshift.io/v1/namespaces/shekhar-secondproject/buildconfigs/openshift-helloworld/webhooks/yTfhTdQP5j5kRKB9PYk5/github`


#### <b>Go to your Git project, settings, add webhook</b><br>
- Add `app git webhook url` to payload url
- Make sure to disable `SSL`



#### <b>Make changes that will trugger re-building the app</b><br>

1. Make changes in the index.html file
2. Push the change to git
3. In the web-browser, Go to "builds".. There should be a new build in progress
