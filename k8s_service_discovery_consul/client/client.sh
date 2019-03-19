#!/bin/bash

echo $PATH

# Let us indictate the node this way
echo "<h1>$(hostname)<h1>" > /usr/share/nginx/html/index.html



# It takes around 2-3 seconds for the server agent to be ready
echo 'Start 15 sec sleep'
sleep 15
echo 'Done with sleep...lets proceed'

echo 'Consul agent started on screen'
screen -S "start-consul" -dm consul agent -data-dir /var/lib/consul -config-dir /etc/consul.d

masterIP=$(getent hosts consul-master | awk '{ print $1 }')
echo "Consul Master IP: ${masterIP}"

echo 'Try to add agent to cluster'
checkStatus=$(curl -s http://127.0.0.1:8500/v1/status/leader | tr -d '"')
consul join consul-master
tries=0;
while [ "$checkStatus" != "${masterIP}:8300" ]
do
    tries=$((tries + 1))
    if [ $tries -gt 10 ]
    then
        break
    fi
    echo "Tries: ${tries}"
    echo "Status Message: ${checkStatus}"

    echo 'Server not ready...wait for 5 secs and try again...'
    sleep 5
    consul join consul-master
    checkStatus=$(curl http://127.0.0.1:8500/v1/status/leader | tr -d '"')

done

if [ $tries -lt 10 ]
then
    echo 'Add agent to cluster - Successful!'
else
    echo 'Add agent to cluster - Failed!'
fi


echo 'Start nginx'
nginx -g "daemon off;"

echo 'All done'
exec "$@"
