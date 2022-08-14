# Домашнее задание к занятию "7.5. Основы golang"

## Задача 1

Go успешно установлен.

```shell
root@server1:~/go# go version
go version go1.19 linux/amd64
```
## Задача 3

1. Программа переводит метры в футы

```go
package main

import "fmt"

func main() {
    fmt.Print("Enter length in meters: ")
    var input float64
    fmt.Scanf("%f", &input)

    output := input / 0.3048

    fmt.Println(output, " foots")    
}
```

2. Программа ищет наименьший элемент в массиве

```go
package main
  
import "fmt"

func main() {
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    var minval int = x[0]
    var index int = 0
    for i, value := range x {
    	fmt.Print(value, " ")
	    if value < minval {
		    index = i
		    minval = value
	    }
    }
    fmt.Println("\nMin value: ", minval, " index: ", index)    
}
```
3. Выводит числа от 1 до 100, которые делятся на 3 без остатка.

```go
package main

import "fmt"

func main() {
    for i:=1;;i++ {
	    if i*3 > 100 {
		    fmt.Print("\n")
		    break
	    }
	    fmt.Print(i*3, ", ")
    }
}
```


