# Consul Service Discovery Demonstration

Here is a demonstration of Consul Service Discovery using Docker Containers.
We will use three containers, one as the master and the other two as client nodes. We will register a webserver service for this demo.

```
# This is already done, do not do it again
git clone https://github.com/shekhar2010us/kubernetes_teach_git.git
cd plain_service_discovery_consul

# install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

docker-compose up -d --force-recreate --build
```
To see the progress of the three containers

```
docker-compose logs -f consul-master
docker-compose logs -f consul-client1
docker-compose logs -f consul-client2
```
Let us get inside the master to try the service resolution using the dig command.

```
docker-compose exec consul-master bash
```

## Service Discovery

Client details

```
root@consul-master:/etc/consul.d# dig @127.0.0.1 -p 8600 consul-client1.node.consul

; <<>> DiG 9.9.5-3ubuntu0.19-Ubuntu <<>> @127.0.0.1 -p 8600 consul-client1.node.consul
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 51667
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 2
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;consul-client1.node.consul.	IN	A

;; ANSWER SECTION:
consul-client1.node.consul. 0	IN	A	172.30.0.3

;; ADDITIONAL SECTION:
consul-client1.node.consul. 0	IN	TXT	"consul-network-segment="

;; Query time: 12 msec
;; SERVER: 127.0.0.1#8600(127.0.0.1)
;; WHEN: Tue Mar 19 05:11:40 UTC 2019
;; MSG SIZE  rcvd: 107
```

Service details. We can see it returing IP addresses of both the client nodes.

```
root@consul-master:/etc/consul.d# dig @127.0.0.1 -p 8600 webserver.service.consul

; <<>> DiG 9.9.5-3ubuntu0.19-Ubuntu <<>> @127.0.0.1 -p 8600 webserver.service.consul
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 33382
;; flags: qr aa rd; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 3
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;webserver.service.consul.	IN	A

;; ANSWER SECTION:
webserver.service.consul. 0	IN	A	172.30.0.4
webserver.service.consul. 0	IN	A	172.30.0.3

;; ADDITIONAL SECTION:
webserver.service.consul. 0	IN	TXT	"consul-network-segment="
webserver.service.consul. 0	IN	TXT	"consul-network-segment="

;; Query time: 3 msec
;; SERVER: 127.0.0.1#8600(127.0.0.1)
;; WHEN: Tue Mar 19 05:10:50 UTC 2019
;; MSG SIZE  rcvd: 157


dig @127.0.0.1 -p 8600 webserver.service.consul SRV
root@consul-master:/etc/consul.d# dig @127.0.0.1 -p 8600 webserver.service.consul SRV

; <<>> DiG 9.9.5-3ubuntu0.19-Ubuntu <<>> @127.0.0.1 -p 8600 webserver.service.consul SRV
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 40212
;; flags: qr aa rd; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 5
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;webserver.service.consul.	IN	SRV

;; ANSWER SECTION:
webserver.service.consul. 0	IN	SRV	1 1 80 consul-client2.node.dc1.consul.
webserver.service.consul. 0	IN	SRV	1 1 80 consul-client1.node.dc1.consul.

;; ADDITIONAL SECTION:
consul-client2.node.dc1.consul.	0 IN	A	172.30.0.4
consul-client2.node.dc1.consul.	0 IN	TXT	"consul-network-segment="
consul-client1.node.dc1.consul.	0 IN	A	172.30.0.3
consul-client1.node.dc1.consul.	0 IN	TXT	"consul-network-segment="

;; Query time: 17 msec
;; SERVER: 127.0.0.1#8600(127.0.0.1)
;; WHEN: Tue Mar 19 05:10:13 UTC 2019
;; MSG SIZE  rcvd: 257

```

Get Service Details via Consul API

```
root@consul-master:/etc/consul.d# curl http://localhost:8500/v1/catalog/services?pretty
{
    "consul": [],
    "webserver": [
        "colourserver"
    ]
}
```

```
curl http://localhost:8500/v1/catalog/service/webserver?pretty

root@consul-master:/etc/consul.d# curl http://localhost:8500/v1/catalog/service/webserver?pretty
[
    {
        "ID": "7a7fadd8-4dbc-8a40-d35e-7868e9c4f1e6",
        "Node": "consul-client1",
        "Address": "172.30.0.3",
        "Datacenter": "dc1",
        "TaggedAddresses": {
            "lan": "172.30.0.3",
            "wan": "172.30.0.3"
        },
        "NodeMeta": {
            "consul-network-segment": ""
        },
        "ServiceKind": "",
        "ServiceID": "webserver",
        "ServiceName": "webserver",
        "ServiceTags": [
            "colourserver"
        ],
        "ServiceAddress": "",
        "ServiceWeights": {
            "Passing": 1,
            "Warning": 1
        },
        "ServiceMeta": {},
        "ServicePort": 80,
        "ServiceEnableTagOverride": false,
        "ServiceProxyDestination": "",
        "ServiceProxy": {},
        "ServiceConnect": {},
        "CreateIndex": 11,
        "ModifyIndex": 11
    },
    {
        "ID": "e9943d41-c036-b598-8b89-dd6882bac392",
        "Node": "consul-client2",
        "Address": "172.30.0.4",
        "Datacenter": "dc1",
        "TaggedAddresses": {
            "lan": "172.30.0.4",
            "wan": "172.30.0.4"
        },
        "NodeMeta": {
            "consul-network-segment": ""
        },
        "ServiceKind": "",
        "ServiceID": "webserver",
        "ServiceName": "webserver",
        "ServiceTags": [
            "colourserver"
        ],
        "ServiceAddress": "",
        "ServiceWeights": {
            "Passing": 1,
            "Warning": 1
        },
        "ServiceMeta": {},
        "ServicePort": 80,
        "ServiceEnableTagOverride": false,
        "ServiceProxyDestination": "",
        "ServiceProxy": {},
        "ServiceConnect": {},
        "CreateIndex": 10,
        "ModifyIndex": 10
    }
]
```

##Load balancing

```
root@consul-master:/etc/consul.d# curl localhost
<h1>consul-client1<h1>

root@consul-master:/etc/consul.d# curl localhost
<h1>consul-client2<h1>

root@consul-master:/etc/consul.d# curl localhost
<h1>consul-client1<h1>

root@consul-master:/etc/consul.d# curl localhost
<h1>consul-client1<h1>

root@consul-master:/etc/consul.d# curl localhost
<h1>consul-client2<h1>

root@consul-master:/etc/consul.d# curl localhost
<h1>consul-client1<h1>

root@consul-master:/etc/consul.d# curl localhost
<h1>consul-client1<h1>
```

Loadbalancing test from the host VM

```
$ curl localhost:9191
<h1>consul-client1<h1>

$ curl localhost:9191
<h1>consul-client1<h1>

$ curl localhost:9191
<h1>consul-client1<h1>

$ curl localhost:9191
<h1>consul-client2<h1>

```


