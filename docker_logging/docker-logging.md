# docker-logging

## copy the python code to your system
create a file "testlogging.py" and copy the content from the git

## Create a Python container executing the python log script with default 'json-file' driver

```
docker run --rm --name testlogging01 -t -d -v $(pwd):/tmp  -w /tmp python:2.7 python -u testlogging.py
```

Grab a stream of container

```
docker logs -f testlogging01
```

Get the json file used for logging
```
docker inspect testlogging01
```

Tail the json file specified under the LogPath section of container inspect output.

Create a container with log options for default json-file driver. Here the maximum number of log files is specified as 2 and the maximum size of each log file is specified as 1kB.
```
docker run --rm --log-opt max-file=2  --log-opt max-size=1k --name testlogging02 -t -d -v $(pwd):/tmp  -w /tmp python:2.7 python -u testlogging.py
```

If you check the `logpath` directory, you will see 2 log files.

## Cleanup

```
docker rm -f testlogging01
docker rm -f testlogging02
```


## For syslog log driver to work, the syslog service should be running on the host machine.

Creating a syslog service in the host machine via container and mapping a port.

```
docker run -d -v /tmp:/var/log/syslog -p 127.0.0.1:5514:514/udp  --name rsyslog voxxit/rsyslog
```


## Change the Log driver to syslog when creating container

```
docker run --log-driver=syslog --log-opt syslog-address=udp://127.0.0.1:5514 --log-opt syslog-facility=daemon --log-opt tag=testapp01 --name testlogging03 -ti -d -v $(pwd):/tmp  -w /tmp python:2.7 python -u testlogging.py
```

Test whether the log is accessible via docker log command. This will fail.

```
docker logs -f testlogging03
```

To get the log of the container.

```
docker exec rsyslog tail -f /var/log/messages
```

## Cleanup

```
docker rm -f testlogging03
```


## Change the tag while logging using syslog log driver

```
docker run --log-driver=syslog --log-opt syslog-address=udp://127.0.0.1:5514 --log-opt syslog-facility=daemon --log-opt tag=NEWtestapp02 --name testlogging04 -ti -d -v $(pwd):/tmp  -w /tmp python:2.7 python -u testlogging.py
```

Get the log of the container to see the usage of new tag.

```
docker exec rsyslog tail -f /var/log/messages
```

## Cleanup

```
docker rm -f testlogging03
```

