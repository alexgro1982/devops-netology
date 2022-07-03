# Домашнее задание к занятию "6.3. MySQL"

## Задача 1

```sql
mysql> status
--------------
mysql  Ver 8.0.29 for Linux on x86_64 (MySQL Community Server - GPL)
```
```sql
mysql> select count(*) from orders where price>300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```
В базе test_db одна запись, в которой поле price больше 300.

## Задача 2

```sql
mysql> select * from information_schema.user_attributes where USER='test';
+------+------+---------------------------------------+
| USER | HOST | ATTRIBUTE                             |
+------+------+---------------------------------------+
| test | %    | {"fname": "Pretty", "lname": "James"} |
+------+------+---------------------------------------+
1 row in set (0.00 sec)
```

## Задача 3

```sql
mysql> show table status;
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time         | Check_time | Collation          | Checksum | Create_options | Comment |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| orders | InnoDB |      10 | Dynamic    |    5 |           3276 |       16384 |               0 |            0 |         0 |              6 | 2022-07-02 20:58:53 | 2022-07-02 20:58:54 | NULL       | utf8mb4_0900_ai_ci |     NULL |                |         |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
1 row in set (0.00 sec)
```
Табилица 'orders' использует InnoDB;

```sql
mysql> show profiles;
+----------+------------+----------------------------------+
| Query_ID | Duration   | Query                            |
+----------+------------+----------------------------------+
..................
|        9 | 0.17779075 | alter table orders engine=MyISAM |
|       10 | 0.13591900 | alter table orders engine=InnoDB |
+----------+------------+----------------------------------+
10 rows in set, 1 warning (0.00 sec)
```

## Задача 4  

```
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

innodb_log_buffer_size		= 1M
innodb_flush_method		= O_DSYNC
innodb_flush_log_at_trx_commit	= 2
innodb_log_file_size		= 100M
innodb_buffer_pool_size		= 300M
innodb_file_per_table		=1
innodb_file_format		=Barracuda

```
