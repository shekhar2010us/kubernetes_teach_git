## OC CLI

#### Download OpenShift CLI 
OC CLI is available for almost all operating systems (Windows, MacOs, Linux). <br><br>
<b>Download links - </b> `https://mirror.openshift.com/pub/openshift-v4/clients/oc/4.1/`

For OC installation in <b>Windows</b>, please follow `https://docs.openshift.com/container-platform/3.6/cli_reference/get_started_cli.html#cli-windows`

For OC installation in <b>Mac OSx</b>, please follow `https://docs.openshift.com/container-platform/3.6/cli_reference/get_started_cli.html#cli-mac`

For OC installation in <b>Linux</b>, please follow `https://docs.openshift.com/container-platform/3.6/cli_reference/get_started_cli.html#cli-linux`

The basic idea for all OS installation is:

- download the tar/zip file
- unzip/untar
- add `oc` from the downloaded directory to system `PATH`
- check if `oc` works by running `oc --help` command

### For MacOs/Linux

```
wget https://mirror.openshift.com/pub/openshift-v4/clients/oc/4.1/macosx/oc.tar.gz
tar -xvf oc.tar.gz
cp oc /usr/local/bin/
## check $PATH, if it doesnt have /usr/local/bin, add
export PATH=$PATH:/usr/local/bin
## check $PATH again
# verify installation
oc --help
```

### For Windows

```
# Download https://mirror.openshift.com/pub/openshift-v4/clients/oc/4.1/windows/oc.zip
# unzip
# Go to command line, check directories on your "path" environment
# Copy "oc.exe" to one of these directories. E.g. "C:\Windows\system32"
# verify installation
help oc
```
