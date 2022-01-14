# Домашнее задание к занятию «3.1. Работа в терминале, лекция 1»

1. Установка VirtualBox и Vagrant установлены и виртуальная машина Ubuntu 20.04 запущена.
```
alexgro@alex-book:~/netology/vagrant$ vagrant ssh
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri 14 Jan 2022 08:22:43 PM UTC

  System load:  0.08               Processes:             118
  Usage of /:   12.0% of 30.88GB   Users logged in:       0
  Memory usage: 21%                IPv4 address for eth0: 10.0.2.15
  Swap usage:   0%


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Wed Jan 12 18:53:41 2022 from 10.0.2.2
vagrant@vagrant:~$ 
```
5. Аппаратные ресурсы виртуальной машины по умолчанию
- Оперативная память - 1024 МБ
- Процессор - 2
- Видеопамять - 4 МБ
- Сеть - Intel PRO/1000 MT Desktop (NAT)

6. Содержимое файла Vagrantfile для запуска машины с 2048 МИ оперативы и 1 процессором:
```
Vagrant.configure("2") do |config|
    config.vm.box = "bento/ubuntu-20.04"
    config.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus = 1
    end
end
```
8. Длина журнала задаётся переменной HISTSIZE, описание переменной находится в 628 строке справки. 
```
vagrant@vagrant:~$ echo $HISTSIZE
1000
vagrant@vagrant:~$ HISTSIZE=5000
vagrant@vagrant:~$ echo $HISTSIZE
5000
```
ignoreboth является одним из значений переменной HISTCONTROL, которое говорит о том, что в истории не будут сохраняться строки начинающиеся с пробелов, и дубликаты уже имеющихся в истории строк.

9. Фигурные скобки {} применяются для сокращения количесва комманд, в которых имеется общий префикс. Описание данной функции находится в строке 791.

10. СОздание 100000 файлов однократным вызовом:
```
vagrant@vagrant:~/test$ touch file{1..100000}
vagrant@vagrant:~/test$ ls -l | wc -l
100001
vagrant@vagrant:~/test$ ls -l | head -n 10
total 0
-rw-rw-r-- 1 vagrant vagrant 0 Jan 14 21:11 file1
-rw-rw-r-- 1 vagrant vagrant 0 Jan 14 21:11 file10
-rw-rw-r-- 1 vagrant vagrant 0 Jan 14 21:11 file100
-rw-rw-r-- 1 vagrant vagrant 0 Jan 14 21:11 file1000
-rw-rw-r-- 1 vagrant vagrant 0 Jan 14 21:11 file10000
-rw-rw-r-- 1 vagrant vagrant 0 Jan 14 21:11 file100000
-rw-rw-r-- 1 vagrant vagrant 0 Jan 14 21:11 file10001
-rw-rw-r-- 1 vagrant vagrant 0 Jan 14 21:11 file10002
-rw-rw-r-- 1 vagrant vagrant 0 Jan 14 21:11 file10003
vagrant@vagrant:~/test$ 
```
Создать 300000 файлов подобным образом не получится, т.к. в данном случае размер аргументов комадды touch выходят за ограничения ядра в 2 МБ.

11. Конструкция [[ -d /tmp ]] возвращает статус 0 если файл /tmp существует, и является каталогом.
```
vagrant@vagrant:~/test1$ [[ -d /tmp ]]
vagrant@vagrant:~/test1$ echo $?
0
vagrant@vagrant:~/test1$ [[ -d /tmppp ]]
vagrant@vagrant:~/test1$ echo $?
1
```

12. Работа с PATH
```
vagrant@vagrant:~$ type -a bash
bash is /usr/bin/bash
bash is /bin/bash
vagrant@vagrant:~$ ln -s /usr/bin /tmp/new_path_directory
vagrant@vagrant:~$ PATH=/tmp/new_path_directory:$PATH
vagrant@vagrant:~$ type -a bash
bash is /tmp/new_path_directory/bash
bash is /usr/bin/bash
bash is /bin/bash
vagrant@vagrant:~$ 
```

13. Команда at выполняет разовое задание в определённое время. Команда batch выполняет разовое задание, когда загрузка системы станет меньше 0.8.
