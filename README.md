# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Задача 1

Образ nginx успешно создан.

docker.io/alexgrolysva/nginx


## Задача 2
- __Высоконагруженное монолитное java веб-приложение;__
Для монолитного приложения более подойдёт запуск на виртуальной или физической машине, т.к. Docker подразумевает деление приложения на микросервисы. В монолитном приложении нет деления на микросервисы.
- __Nodejs веб-приложение;__
В данном случае подойдёт инфраструктура в виде Docker конткйнеров, т.к. возможно использование микросервисов.
- __Мобильное приложение c версиями для Android и iOS;__
Можно использовать микросервисы - Docker.
- __Шина данных на базе Apache Kafka;__
Виртуальные машины или физические сервера.
- __Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;__
Виртуальные машины.
- __Мониторинг-стек на базе Prometheus и Grafana;__
Можно использовать микросервисы - Docker.
- __MongoDB, как основное хранилище данных для java-приложения;__
Docker, в составе микросервисной архитекруры приложения.
- __Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.__
Можно использовать микросервисы - Docker.

## Задача 3
```shell
vagrant@server1:~$ docker run -it -d -v $(pwd)/data:/data debian
8e8cf32564c73c251adeb37af478edad90b6d8c93a8242757c4b38e18ac5e775
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED         STATUS         PORTS     NAMES
8e8cf32564c7   debian    "bash"    5 seconds ago   Up 4 seconds             happy_raman
vagrant@server1:~$ docker run -it -d -v $(pwd)/data:/data centos
015e2a0ad66eb08e9df908b80d64685a7a0af347ea7ff1958d61aef090ed9698
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
015e2a0ad66e   centos    "/bin/bash"   4 seconds ago    Up 2 seconds              funny_engelbart
8e8cf32564c7   debian    "bash"        24 seconds ago   Up 22 seconds             happy_raman
vagrant@server1:~$ docker exec -it funny_engelbart bash
[root@015e2a0ad66e /]# echo "file from centos" > /data/file_from_centos.txt
[root@015e2a0ad66e /]# exit
exit
vagrant@server1:~$ echo "from host" > ./data/file_from_host.txt
vagrant@server1:~$ docker exec -it happy_raman bash
root@8e8cf32564c7:/# ls -l /data 
total 8
-rw-r--r-- 1 root root 17 May 18 20:57 file_from_centos.txt
-rw-rw-r-- 1 1000 1000 10 May 18 20:58 file_from_host.txt
root@8e8cf32564c7:/# 
```



## Задача 4  

docker.io/alexgrolysva/ansible

```shell
vagrant@server1:~/ansible$ docker run -it alexgrolysva/ansible
ansible-playbook 2.10.17
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.9/site-packages/ansible
  executable location = /usr/bin/ansible-playbook
  python version = 3.9.5 (default, Nov 24 2021, 21:19:13) [GCC 10.3.1 20210424]
vagrant@server1:~/ansible$ 
```
