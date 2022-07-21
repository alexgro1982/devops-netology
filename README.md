# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

```dockerfile
FROM centos:7
RUN useradd -ms /bin/bash elastic
WORKDIR /opt
RUN curl -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.3.2-linux-x86_64.tar.gz && \
    tar -xzf elasticsearch-8.3.2-linux-x86_64.tar.gz && \
    rm -f elasticsearch-8.3.2-linux-x86_64.tar.gz && \
    chown -R elastic:elastic /opt/elasticsearch-8.3.2
RUN mkdir /var/log/elasticsearch && chown elastic:elastic /var/log/elasticsearch && \
    mkdir /var/lib/elasticsearch && chown elastic:elastic /var/lib/elasticsearch
COPY --chown=elastic:elastic ./config/elasticsearch.yml ./elasticsearch-8.3.2/config/elasticsearch.yml
ENV ES_HOME=/opt/elasticsearch-8.3.2
EXPOSE 9200 9300
USER elastic
ENTRYPOINT ["/opt/elasticsearch-8.3.2/bin/elasticsearch"]
```
Ссылка на docker-образ: https://hub.docker.com/r/alexgrolysva/elastic/tags

```shell
vagrant@server1:~$ curl --user elastic:_1XWkyK3mlENl++3HyYq -k https://localhost:9200
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "6y7XE0KMT3uWQhn7D-tm6A",
  "version" : {
    "number" : "8.3.2",
    "build_type" : "tar",
    "build_hash" : "8b0b1f23fbebecc3c88e4464319dea8989f374fd",
    "build_date" : "2022-07-06T15:15:15.901688194Z",
    "build_snapshot" : false,
    "lucene_version" : "9.2.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

## Задача 2

```shell
vagrant@server1:~$ curl --user elastic:_1XWkyK3mlENl++3HyYq -k https://localhost:9200/_cat/indices
yellow open ind-2 ikuiwLXpQjCK3rvTYo_DtQ 2 1 0 0 450b 450b
yellow open ind-3 QfpFouebSuq8nIbYaKOx6Q 4 2 0 0 900b 900b
green  open ind-1 kJooB4v7TlqOz6grALzq3A 1 0 0 0 225b 225b

```

```shell
curl --user elastic:_1XWkyK3mlENl++3HyYq -k https://localhost:9200/_cluster/health | jq
{
  "cluster_name": "elasticsearch",
  "status": "yellow",
  "timed_out": false,
  "number_of_nodes": 1,
  "number_of_data_nodes": 1,
  "active_primary_shards": 9,
  "active_shards": 9,
  "relocating_shards": 0,
  "initializing_shards": 0,
  "unassigned_shards": 10,
  "delayed_unassigned_shards": 0,
  "number_of_pending_tasks": 0,
  "number_of_in_flight_fetch": 0,
  "task_max_waiting_in_queue_millis": 0,
  "active_shards_percent_as_number": 47.368421052631575
}
```
Индексы ind-2 и ind-3 находятся в состоянии "yellow", т.к. у них количество реплик в настройках не соответствует фактическому. У нас одна нода и реплики копировать некуда. 

## Задача 3

Создание репозитория:
```shell
vagrant@server1:~$ curl --user elastic:_1XWkyK3mlENl++3HyYq -k -XPUT "https://localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'{ "type": "fs","settings": {"location": "netology_backup"}}'
{
  "acknowledged" : true
}
```
Список индексов до снапшота:
```shell
vagrant@server1:~$ curl --user elastic:_1XWkyK3mlENl++3HyYq -k https://localhost:9200/_cat/indices
green open test 3EhIs6gMQnmP1DpgYEiytQ 1 0 0 0 225b 225b
```
Список файлов в директории со снапшотом:
```shell
[elastic@acaf49997ab8 opt]$ ls -l /opt/elasticsearch-8.3.2/snapshots/netology_backup/
total 36
-rw-r--r-- 1 elastic elastic  1099 Jul 21 20:37 index-0
-rw-r--r-- 1 elastic elastic     8 Jul 21 20:37 index.latest
drwxr-xr-x 5 elastic elastic  4096 Jul 21 20:37 indices
-rw-r--r-- 1 elastic elastic 18543 Jul 21 20:37 meta-Q6Md46ocQVWTDCwQ87lMhQ.dat
-rw-r--r-- 1 elastic elastic   390 Jul 21 20:37 snap-Q6Md46ocQVWTDCwQ87lMhQ.dat
```
Удяляем индекс test и создаём test-2. Ниже итоговый список индексов:
```shell
vagrant@server1:~$ curl --user elastic:_1XWkyK3mlENl++3HyYq -k https://localhost:9200/_cat/indices
green open test-2 qT_M4xt4TQO1DqufL7zMvA 1 0 0 0 225b 225b
```
Восстановление из снапшота и итоговый список индексов:
```shell
vagrant@server1:~$ curl --user elastic:_1XWkyK3mlENl++3HyYq -k -X POST "https://localhost:9200/_snapshot/netology_backup/new_shapshot_1/_restore?pretty"
{
  "accepted" : true
}
vagrant@server1:~$ curl --user elastic:_1XWkyK3mlENl++3HyYq -k https://localhost:9200/_cat/indices
green open test   JxXZw2wTRLKgoolwOut4_w 1 0 0 0 225b 225b
green open test-2 qT_M4xt4TQO1DqufL7zMvA 1 0 0 0 225b 225b
```

