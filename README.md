# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## Задача 1

Replication - такой режим работы, при котором запускается заданное число экземпляров сервиса, распределённых по нодам.

Global - такой режим работы, при котором на каждой ноде запускается по одному экземпляру сервиса.

Для вабора лидера используется алгоритм голосования RAFT.

Overlay Network - это внутренняя сеть, которая охватывает все узлы Docker swarm, что облегчает обмен данными между контейнерами.

## Задача 2

```shell
vagrant@server1:~/terraform1$ ssh centos@51.250.90.71
[centos@node01 ~]$ docker node ls
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/nodes": dial unix /var/run/docker.sock: connect: permission denied
[centos@node01 ~]$ sudo -i
[root@node01 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
vwhv8r5bpab982mcwe58eb3ic *   node01.netology.yc   Ready     Active         Leader           20.10.17
m527qdwzo3brx26f4siiaqjjg     node02.netology.yc   Ready     Active         Reachable        20.10.17
dn5a07zo2fveiyfr3a5jqz6c8     node03.netology.yc   Ready     Active         Reachable        20.10.17
jfpqat7b6csqg5abhcj8m6jvx     node04.netology.yc   Ready     Active                          20.10.17
ocwvl46kk8jewpvgtd14ahxao     node05.netology.yc   Ready     Active                          20.10.17
l7ddckxpw6p45n1en3q05afdz     node06.netology.yc   Ready     Active                          20.10.17
[root@node01 ~]# 
```

## Задача 3

```shell
[root@node01 ~]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
e2tdudy88r32   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0    
tv75kmuwwvbv   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
vh4ho1eef0pe   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest                         
jei2t3cqh3bj   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest                      
whqvs9c0wkjg   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4           
yca2cg6vdfe3   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0   
57fpl3ht5r92   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0       
wp3m0gxtcp4v   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0                        
[root@node01 ~]# 

```

## Задача 4  

```shell
[root@node01 ~]# docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-61OheW7JC0UdCQvTEP7JWH6KnGIqoWnULjEt0CJsigc

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.
[root@node01 ~]# 
```
Данной командой мы защищаем ключ TLS и ключ шифрования журналов Raft. После данной команды, при перезапуске менеджера, необходимо разблокировать путём ввода сгенерированного ключа.