# Домашнее задание к занятию «3.3. Операционный системы, лекция 1»
1. Системный вызов команды cd.
```shell
vagrant@vagrant:~$ strace /bin/bash -c 'cd /tmp' 2>&1  
...  
chdir("/tmp")  
...
```
2. /usr/share/misc/magic.mgc
```shell
vagrant@vagrant:~$ strace -e trace=openat file /dev/tty 2>&1
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libbz2.so.1.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
/dev/tty: character special (5/0)
+++ exited with 0 +++
```
3. 
  - Определить id процесса
  - lsof -p <id>  (определить файловый дескриптор)
  - \>/proc/<id>/fd/<fd>  (обнулить размер файла)
4. Зомби-процессы не занимают ресурсы системы
5. При запуске opensnoop-bpfcc в первую секунду открываются файлы python, а следом библиотеки gcc.
```shell
...
openat(AT_FDCWD, "/usr/bin/pyvenv.cfg", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/pyvenv.cfg", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/localtime", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/python3.8", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
openat(AT_FDCWD, "/usr/lib/python3.8/encodings/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/codecs.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
...
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libgcc_s.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/../lib/gcc/x86_64-linux-gnu", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
openat(AT_FDCWD, "/../lib/gcc/x86_64-linux-gnu", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
openat(AT_FDCWD, "/usr/lib/gcc/x86_64-linux-gnu", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
openat(AT_FDCWD, "/usr/lib/gcc/x86_64-linux-gnu", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
...
```
6. uname
```shell
uname({sysname="Linux", nodename="vagrant", ...}) = 0
```
Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.

7. При использовании ; все команды цепочки выполнятся не зависимо от результата выполнения предыдущей команды. При использовании && выполнение команды зависит от результата выполнения предыдущей.
При установке set -e оболочка закроется при получении ненулевого результата выполнения команды, следовательно есть смымсл использовать &&, если необходимо продолжение работы в текущей оболочке. 
8. set -euxo pipefail  
-e - Завершает оболочку при ошибке выполнения команды  
-u - Выдаёт ошибку при раскрытии неустановленной переменной  
-x - Выводит комадды при их выполнении  
-o pipefail  - статус завершения конвеера нулевой, если все команды выполнились с нулевым статусом, или ненулевой статус последней команды выполненой с ошибкой.  

Включение данных опций позволяет отследить команды, выполненные с ошибками.

9. Наиболее частый статус процессов "S", что означает спящие процессы процессы.  
Дополнительные символы означают расширенный статус такой как:  
< - процесс с высоким приоритетом  
N - процесс с низким приоритетом
L - имеет блокированные страницы памяти 
l - многопоточный процесс   
s - лидер сессии  
"+" - фоновый процесс
