# docker-networking

## Connecting containers using 'link' option

Create a container to be linked with another with name as box2.

```
docker run -ti --rm --name box2 ubuntu:trusty
```

Create a new container linked to the first container in a different terminal window with name as box1.

```
docker run -ti --rm --name box1 --link box2 ubuntu:trusty
```

Testing the connection - using netcat package - via custom port 8111. Netcat utility is pre-installed on the ubuntu:trusty image. You can use the box name of the first container (box2) inside the second container (box1) since they are linked and they will be able to interact. But not viceversa.
```
[Step 1: Execute the below command inside box2 container. This will enable netcat to listen to TCP port 8111 for connections in box2.]
netcat -l 8111

[Step 2: Execute the below command inside box1 container. This will create a connection from box1 to box2 via TCP port 8111. Here you can use the box2 name directly because you have linked it at the time of container creation.]
netcat box2 8111

[Step 3: You can now type some message from the box1 container and press Enter key to send it via the network port.]
Hello message from box1 container

[Step 4: On your box2 container window, you will see the message from the box2 container. And you will be able to type a new message inside box2 and press Enter key to send it via the same network port.]
Hello message from box2 container

[Step 5: Go back to the box1 container terminal window and you will see the message from box2 there.

[Step 6: To terminate the already established netcat connection, press Ctrl+C on either box1 or box2 container terminal window. This will terminate the connection via port 8111.
```

## Cleanup
```
[Inside box1 container terminal window, execute the below command. This will terminate the container and remove it as we have used --rm option when we started the container.]
exit

[Inside box2 container terminal window, execute the below command. This will terminate the container and remove it as we have used --rm option when we started the container.]
exit
```


## Creating Custom Network

To get the list of current networks

```
docker network ls
```

Creating a new bridge network called net1

```
docker network create --driver bridge net1
```

Creating another custom bridge network called net2

```
docker network create --driver bridge net2
```

Create a new container with name nw-box1 which is attached to the custom network net1.

```
docker run -tid --rm --name nw-box1 --network net1 ubuntu:trusty
```

Create another container named nw-box2 attached to the custom network net2 in a different terminal window.

```
docker run -tid --rm --name nw-box2 --network net2 ubuntu:trusty
```

Execute the below commands to get the network details of the running containers. You will see the container nw-box1 connected to the net1 network and container nw-box2 connected to the net2 container.

```
docker inspect nw-box1 --format '{{.NetworkSettings.Networks}}'
docker inspect nw-box2 --format '{{.NetworkSettings.Networks}}'
```

Attaching a network to a running container. Execute the below command to attach the custom network net1 to the running container nw-box2.

```
docker network connect net1 nw-box2
```

Get the network details of running containers once again. You will see the container with name nw-box2 is now connected to two networks: net1 and net2, whereas the container with name nw-box1 is still connected to only one network, net1.

```
docker inspect nw-box1 --format '{{.NetworkSettings.Networks}}'
docker inspect nw-box2 --format '{{.NetworkSettings.Networks}}'
```

Detaching the custom network net1 from the running container with name nw-box2

```
docker network disconnect net1 nw-box2
```

Creating a new container connected to both the custom networks net1 and net2.

```
docker run -tid --rm --name nw12-box --network net1 ubuntu:trusty
docker network connect net2 nw12-box
```

Checking the connection between containers from each container. You will see that the container with name nw12-box is connected to both the nw-box1 and nw-box2 containers, as both has a common network with that container.  Also the nw-box1 and nw-box2 containers are not connected to each other as they don't share a common network.

```
[Execute the below command to enter the terminal of running container nw-box1]
docker exec -ti nw-box1 bin/bash

[Execute the below command inside the nw-box1 terminal session to try pinging nw-box2. You will see that this fails as these containers doesn't have any shared network.]
ping nw-box2

[Execute the below command inside the nw-box1 terminal session to try pinging nw12-box. You will see that this succeeds as these containers have a shared network, which is net1.]
ping nw12-box

[Press Ctrl+C to stop the ping execution.]
Ctrl+C

[Now execute the below command to exit from the terminal session of container nw-box1.]
exit
```

```
[Execute the below command to enter the terminal of running container nw-box2]
docker exec -ti nw-box2 bin/bash

[Execute the below command inside the nw-box2 terminal session to try pinging nw-box1. You will see that this fails as these containers doesn't have any shared network.]
ping nw-box1

[Execute the below command inside the nw-box1 terminal session to try pinging nw12-box. You will see that this succeeds as these containers have a shared network, which is net2.]
ping nw12-box

[Press Ctrl+C to stop the ping execution.]
Ctrl+C

[Now execute the below command to exit from the terminal session of container nw-box1.]
exit
```

```
[Execute the below command to enter the terminal of running container nw12-box]
docker exec -ti nw12-box bin/bash

[Execute the below command inside the nw12-box terminal session to try pinging nw-box1. You will see that this succeeds as these containers have a shared network, which is net1.]
ping nw-box1

[Press Ctrl+C to stop the ping execution.]
Ctrl+C

[Execute the below command inside the nw12-box terminal session to try pinging nw-box2. You will see that this succeeds as these containers have a shared network, which is net2.]
ping nw-box2

[Press Ctrl+C to stop the ping execution.]
Ctrl+C

[Now execute the below command to exit from the terminal session of container nw12-box.]
exit
```

## Cleanup

```
docker rm -f nw-box1
docker rm -f nw-box2
docker rm -f nw12-box
docker rm -f box1
docker rm -f box2
```

## Removing custom networks

```
docker network rm net1
docker network rm net2
```

