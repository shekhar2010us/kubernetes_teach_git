#!/bin/bash

echo $PATH
nginx 
consul agent -server -bootstrap-expect 1 -data-dir /var/lib/consul -config-dir /etc/consul.d
exec "$@"
