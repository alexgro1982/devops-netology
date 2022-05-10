# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Задача 1
Основные преимущества применения IaaC на практике:
- Автоматизация процесса разработки (развёртывание тестовых сред, развёртывание сред для разработки);
- Минимизация ошибок конфигурации инфраструктуры;
- Исключение дрейфа конфигурации;

Основополагающим принципом IaaC является идемпотентность, т.е. при повторном выполнении кода, получаем абсолютно идентичную инфраструктуру.

## Задача 2
Основные преимущества Ansible
- Исполизуется метод управления Push, что не требует установки дополнительных агентов.
- Ansible работает в существующей SSH инфраструктуре
- Имеет много модулей, охватывающих практически все возможности конфигурации.

По моему мнению, более надёжный метод Push, т.к. достаточно мониторить управляющий сервер для контроля процесса развёртывания. Так же инициализация процесса развёртывания и изменения конфигурации происходит с управляющего сервера.

## Задача 3

VirtualBox, Vagrant и Ansible установлены успешно.
```shell
alexgro@alex-book:~$ VirtualBox -h
Oracle VM VirtualBox VM Selector v6.1.30
(C) 2005-2021 Oracle Corporation
All rights reserved.
alexgro@alex-book:~$ vagrant -v
Vagrant 2.2.14
alexgro@alex-book:~$ ansible --version
ansible 2.10.8
  config file = None
  configured module search path = ['/home/alexgro/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.9.2 (default, Feb 28 2021, 17:03:44) [GCC 10.2.1 20210110]

```
## Задача 4  

```shell
alexgro@alex-book:~/netology/vagrant$ vagrant ssh
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Tue 10 May 2022 07:30:49 PM UTC

  System load:  0.0                Users logged in:          0
  Usage of /:   13.6% of 30.88GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 25%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.57.11
  Processes:    107


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Sun May  8 23:23:30 2022 from 10.0.2.2
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$ 

```