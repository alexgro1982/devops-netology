# Домашнее задание к занятию «3.2. Работа в терминале, лекция 2»
1. Команда cd является встроенной в shell, т.к. она меняет текущую рабочую директорию самого процесса shell. Если бы команда cd имела исполняемый файл, то при выполнении запускался бы новый процесс, который имеет свою рабочую директорию.
2. grep -c <some_string> <some_file>
3. PID 1
```shell
root@vagrant:~# ps -q 1
    PID TTY          TIME CMD
      1 ?        00:00:02 systemd
```
4. 
```shell
root@vagrant:~# lsof -p $$ | grep pts
bash    1272 root    0u   CHR  136,0      0t0       3 /dev/pts/0
bash    1272 root    1u   CHR  136,0      0t0       3 /dev/pts/0
bash    1272 root    2u   CHR  136,0      0t0       3 /dev/pts/0
bash    1272 root  255u   CHR  136,0      0t0       3 /dev/pts/0
```
```shell
vagrant@vagrant:~$ ls /roott 2>/dev/pts/0
```
Получаем текст оошибки в первой сессии терминала
```shell
root@vagrant:~# ls: cannot access '/roott': No such file or directory
```
5. Да, получится.
```shell
root@vagrant:~# echo "Text Text Text" > file1
root@vagrant:~# ls -l
total 8
-rw-r--r-- 1 root root   15 Jan 20 18:51 file1
drwxr-xr-x 3 root root 4096 Dec 19 19:42 snap
root@vagrant:~# cat < file1 > file2
root@vagrant:~# ls -l
total 12
-rw-r--r-- 1 root root   15 Jan 20 18:51 file1
-rw-r--r-- 1 root root   15 Jan 20 18:52 file2
drwxr-xr-x 3 root root 4096 Dec 19 19:42 snap
root@vagrant:~# cat file2
Text Text Text
```
6. Вывести данные можно, перенаправлением вывода на /dev/ttyX. Но для просмотра этих данных придётся переключится на терминал нажатием ctrl+alt+F(X).

7. При выполнении комманды bash 5>&1 запустится дочерний процесс bash, в котором создастся файловый дескриптор 5, ссылающийся на stdout.

```shell
vagrant@vagrant:~$ bash 5>&1
vagrant@vagrant:~$ echo netology > /proc/$$/fd/5
netology
vagrant@vagrant:~$
```
Так как файловый дескриптор 5 ссылается на stdout, все данные отправленные в fd/5 будут выводится в консоль.

8. Получится.
```shell
vagrant@vagrant:~$ ls -l /home/vagrant
total 0
-rw-rw-r-- 1 vagrant vagrant 0 Jan 22 14:15 test
-rw-rw-r-- 1 vagrant vagrant 0 Jan 22 14:15 test1
vagrant@vagrant:~$ ls -l /home/vagrant | wc -l
3
vagrant@vagrant:~$ ls -l /home/vagranttt | wc -l
ls: cannot access '/home/vagranttt': No such file or directory
0
```
Видим, что в pipe передаётся stdout, а stderr выводится в консоль
```shell
vagrant@vagrant:~$ tty
/dev/pts/0
vagrant@vagrant:~$ ls -l /home/vagrant 2>&1 >`tty` | wc -l
total 0
-rw-rw-r-- 1 vagrant vagrant 0 Jan 22 14:15 test
-rw-rw-r-- 1 vagrant vagrant 0 Jan 22 14:15 test1
0
vagrant@vagrant:~$ ls -l /home/vagranttt 2>&1 >`tty` | wc -l
1
```
В данном случае в pipe передаются ошибки, а стандартный вывод идёт в консоль.

9. Файл /proc/$$/environ содержит переменные окружения, установленные при запуске процесса.
10. файл /proc/<PID>/cmdline содержит полную командную строку для процесса
    Файл /proc/<PID>/exe это символическая ссылка на исполняемый файл процесса.
11. SSE4_2
```shell
vagrant@vagrant:~$ grep -i SSE /proc/cpuinfo 
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni monitor ssse3 cx16 sse4_1 sse4_2 x2apic popcnt hypervisor lahf_lm pti
vagrant@vagrant:~$ 
```
12. Это особенность команды ssh. При запуске ssh c с параметром [command] по умолчанию не выделяется tty. Это можно исправить параметром -t.
```shell
vagrant@vagrant:~$ ssh -t localhost 'tty'
vagrant@localhost's password: 
/dev/pts/1
Connection to localhost closed.
```
14. Команда tee читает данные со стандартного ввода, выводит на стандартный вывод и в файл.
В первом случае shell, работающий от имени пользователя не может получить доступ к файлу в каталоге /root. Во втором случае tee запускается от пользователя root и имеет доступ к папке /root. 