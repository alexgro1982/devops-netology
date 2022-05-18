# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Задача 1

Образ nginx успешно создан.

alexgrolysva/nginx


## Задача 2



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

