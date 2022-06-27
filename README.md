# Домашнее задание к занятию "6.2. SQL"

## Задача 1

```yaml
vagrant@server1:~/postgre$ cat docker-compose.yaml 
version: '3.1'

services:

    db:
        image: postgres:12
        restart: always
        environment:
            POSTGRES_PASSWORD: 123
        ports:
         - "5432:5432"
        volumes:
         - ./db:/var/lib/postgresql/data
         - ./backup:/var/lib/postgresql/backup
```

## Задача 2

```sql
postgres=# \l
                                    List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |      Access privileges       
-----------+----------+----------+------------+------------+------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                 +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                 +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                +
           |          |          |            |            | postgres=CTc/postgres       +
           |          |          |            |            | test_admin_user=CTc/postgres
(4 rows)
```
```sql
test_db=# \d orders;
                                   Table "public.orders"
 Column |         Type          | Collation | Nullable |              Default               
--------+-----------------------+-----------+----------+------------------------------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass)
 name   | character varying(50) |           |          | 
 price  | integer               |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_orderid_fkey" FOREIGN KEY (orderid) REFERENCES orders(id)

test_db=# \d clients;
                                    Table "public.clients"
 Column  |         Type          | Collation | Nullable |               Default               
---------+-----------------------+-----------+----------+-------------------------------------
 id      | integer               |           | not null | nextval('clients_id_seq'::regclass)
 surname | character varying(50) |           |          | 
 country | character varying(50) |           |          | 
 orderid | integer               |           |          | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "indcountry" btree (country)
Foreign-key constraints:
    "clients_orderid_fkey" FOREIGN KEY (orderid) REFERENCES orders(id)
```

## Задача 3
```sql
test_db=# select count (*) from orders;
 count 
-------
     5
(1 row)

test_db=# select count (*) from clients;
 count 
-------
     5
(1 row)
```

## Задача 4  
```sql
test_db=# select * from orders;
 id |  name   | price 
----+---------+-------
  1 | Шоколад |    10
  2 | Принтер |  3000
  3 | Книга   |   500
  4 | Монитор |  7000
  5 | Гитара  |  4000
(5 rows)

test_db=# update clients set orderid=3 where surname='Иванов Иван Иванович';
UPDATE 1
test_db=# update clients set orderid=4 where surname='Петров Петр Петрович';
UPDATE 1
test_db=# update clients set orderid=5 where surname='Иоганн Себастьян Бах';
UPDATE 1
test_db=# select surname from clients where orderid is not null;
       surname        
----------------------
 Иванов Иван Иванович
 Петров Петр Петрович
 Иоганн Себастьян Бах
(3 rows)
```
## Задача 5
```sql
test_db=# explain select surname from clients where orderid is not null;
                         QUERY PLAN                         
------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..13.00 rows=298 width=118)
   Filter: (orderid IS NOT NULL)
(2 rows)
```
Из вывода видно, что происходит сканирование таблицы (перебор всех строк) с применением фильтра на непустое значение поля orderid.

## ЗАдача 6

```shell
vagrant@server1:~/postgre$ docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED       STATUS       PORTS                                       NAMES
0e6f839fdc33   postgres:12   "docker-entrypoint.s…"   2 hours ago   Up 2 hours   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgre_db_1
vagrant@server1:~/postgre$ docker exec -ti postgre_db_1 /bin/bash -c "pg_dump -U postgres test_db > /var/lib/postgresql/backup/dump.sql"
```
```shell
vagrant@server1:~/postgre$ docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                                       NAMES
b02bedcefc1b   postgres:12   "docker-entrypoint.s…"   33 seconds ago   Up 15 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgre_newdb_1
vagrant@server1:~$ docker exec -ti postgre_newdb_1 /bin/bash -c "echo 'create database test_db' | psql -U postgres"
CREATE DATABASE
vagrant@server1:~/postgre$ docker exec -ti postgre_newdb_1 /bin/bash -c "psql -U postgres -d test_db < /var/lib/postgresql/backup/dump.sql"
```