# Домашнее задание к занятию «3.7. Компьютерные сети, лекция 2»

1. Для вывода сетевых интерфейсов в linux - "ip link", windows - "ipconfig".
```shell
root@alex-book:/home/alexgro# ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp7s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN mode DEFAULT group default qlen 1000
    link/ether 1c:75:08:61:ab:3b brd ff:ff:ff:ff:ff:ff
3: wlp6s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DORMANT group default qlen 1000
    link/ether 1c:65:9d:df:4a:08 brd ff:ff:ff:ff:ff:ff
4: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
    link/ether 52:54:00:4f:b9:d7 brd ff:ff:ff:ff:ff:ff
```

2. Для определения соседнего устройства по сети используется протокол LLDP. В linux существует пакет lldpd.
```shell
root@alex-book:/home/alexgro# apt-cache show lldpd
Package: lldpd
Version: 1.0.11-1+deb11u1
Installed-Size: 593
Maintainer: Vincent Bernat <bernat@debian.org>
Architecture: amd64
Depends: libbsd0 (>= 0.6.0), libc6 (>= 2.14), libcap2 (>= 1:2.10), libevent-2.1-7 (>= 2.1.8-stable), libreadline8 (>= 6.0), libsnmp40 (>= 5.9+dfsg), libxml2 (>= 2.7.4), adduser, lsb-base
Pre-Depends: init-system-helpers (>= 1.54~)
Suggests: snmpd
Description-en: implementation of IEEE 802.1ab (LLDP)
 LLDP is an industry standard protocol designed to supplant
 proprietary Link-Layer protocols such as Extreme's EDP (Extreme
 Discovery Protocol) and CDP (Cisco Discovery Protocol). The goal of
 LLDP is to provide an inter-vendor compatible mechanism to deliver
 Link-Layer notifications to adjacent network devices.
```

3. Для разделения физической сети на несколько виртуальных используется технология vlan.
Для использования vlan в linux необходим модуль 8021q. Настроить можно с помощью файлов ifcfg.
Ниже приведён пример файла конфигурации в работающей системе.
```shell
[groshev@VPN-DHCP network-scripts]$ cat /etc/sysconfig/network-scripts/ifcfg-bond0.33
VLAN=yes
TYPE=Vlan
PHYSDEV=bond0
VLAN_ID=33
REORDER_HDR=yes
GVRP=no
MVRP=no
HWADDR=
PROXY_METHOD=none
BROWSER_ONLY=no
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
NAME=bond0.33
UUID=2f5e217c-3a60-4872-b45f-d0f023677d83
DEVICE=bond0.33
ONBOOT=yes
BRIDGE=vlan33
```
В данной системе два интерфейса объединены в bond, и поделены на несколько виртуальных сетей.

4. Объединение интерфейсов в linux называется bonding.  
Типы объединения:
- Mode-0(balance-rr) - отправляет пакеты последовательно через каждый интерфейс
- Mode-1(active-backup) - активный и резервный интерфейсы
- Mode-2(balance-xor) - интерфейс отправки выбирается исходя из MAC получателя по правилу XOR
- Mode-3(broadcast) - передача идёт на все интерфейсы
- Mode-4(802.3ad) - Агрегация каналов по стандарту IEEE 802.3ad
- Mode-5(balance-tlb) - Исходящий трафик распределяется на основе загрузки интерфейсов
- Mode-6(balance-alb) - Влючает Mode-5 и балансировку входящего трафика.
Пример рабочего конфига:
```shell
[groshev@VPN-DHCP network-scripts]$ cat /etc/sysconfig/network-scripts/ifcfg-bond0
DEVICE=bond0
NAME=bond0
TYPE=Bond
BONDING_MASTER=yes
IPV6INIT=no
MTU=1500
ONBOOT=yes
USERCTL=no
BOOTPROTO=none
BONDING_OPTS="mode=4 xmit_hash_policy=2 lacp_rate=1 miimon=100"
```
5. В сети с маской /29 можно использовать 6 IP адресов. 
10.10.10.0/29: 
   10.10.10.1-10.10.10.6
   10.10.10.7/29 - Broadcast
10.10.10.32/29: 
   10.10.10.33-10.10.10.38
   10.10.10.39/29 - Broadcast
Из сети с маской /24 можно получить 32 сети с маской /29.
6. Для организации маршрутизации можно использовть адреса из диапазона 100.64.0.0/10  
Для 40-50 хостов можно использовать сеть с маской /26. Например 100.64.100.0/26.
7. Работа с ARP в Linux.
```shell
root@alex-book:/etc# ip neigh
192.168.100.32 dev virbr0  FAILED
192.168.88.1 dev wlp6s0 lladdr cc:2d:e0:94:83:4b REACHABLE
192.168.100.100 dev virbr0  FAILED
192.168.100.18 dev virbr0  FAILED
192.168.100.88 dev virbr0  FAILED
192.168.100.9 dev virbr0  FAILED
192.168.100.10 dev virbr0  FAILED
192.168.100.12 dev virbr0  FAILED
192.168.100.2 dev virbr0  FAILED
192.168.100.4 dev virbr0  FAILED
192.168.100.3 dev virbr0  FAILED
192.168.100.51 dev virbr0  FAILED
192.168.100.6 dev virbr0  FAILED

root@alex-book:/etc# ip neigh del 192.168.100.32 dev virbr0
root@alex-book:/etc# ip neigh show
192.168.88.1 dev wlp6s0 lladdr cc:2d:e0:94:83:4b REACHABLE
192.168.100.100 dev virbr0  FAILED
192.168.100.18 dev virbr0  FAILED
192.168.100.88 dev virbr0  FAILED
192.168.100.9 dev virbr0  FAILED
192.168.100.10 dev virbr0  FAILED
192.168.100.12 dev virbr0  FAILED
192.168.100.2 dev virbr0  FAILED
192.168.100.4 dev virbr0  FAILED
192.168.100.3 dev virbr0  FAILED
192.168.100.51 dev virbr0  FAILED
192.168.100.6 dev virbr0  FAILED

root@alex-book:/etc# ip neigh flush dev virbr0
root@alex-book:/etc# ip neigh show
192.168.88.1 dev wlp6s0 lladdr cc:2d:e0:94:83:4b REACHABLE
```
