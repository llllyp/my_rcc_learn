# goroutine
goroutine是轻量线程, 创建一个 goroutine 所需的资源开销很小,所以可以创建非常多的 goroutine 来并发工作
它们是由 go 运行时调度的, 调度过程就是 go 运行时把 goroutine 任务分配给 CPU 执行的过程 但 goroutine 不是通常理解的线程, 线程是操作系统调度的

## 声明
```go
// 方式一
go <method_name>(<method_params>...)

// 方式二
go func(<method_params>...){
    <statement_or_expression>
    ...
}(<params>...)
```
## 示例
```go
package main

import (
    "fmt"
    "time"
)

func say(s string) {
    for i := 0; i < 5; i++ {
        time.Sleep(100 * time.Millisecond)
        fmt.Println(s)
    }
}

func main() {
    go func() {
        fmt.Println("run goroutine in closure")
    }()
    
    go func(string) {
    }("gorouine: closure params")

    go say("in goroutine: world")
    say("hello")
}
```
go 中并发同样存在线程安全问题,因为go 也是使用共享内存在多个 goroutine 之间通信

# channel
channel 是 go 中专门用来在多个 goroutine 之间通信的线程安全的数据结构
可以在一个 goroutine 中向一个 channel 中发送数据, 从另外一个 goroutine 中接收数据
channel 类似队列, 满足先进先出原则

## 定义方式
```go
// 仅声明
var <channel_name> chan <type_name>

// 初始化
<channel_name> := make(chan <type_name>)

// 初始化有缓冲的channel
<channel_name> := make(chan <type_name>, <buffer_size>)

// 有缓冲的通道: 当缓冲区未满时, 发送操作不会阻塞; 当缓冲区未空时, 接收操作不会阻塞
// 无缓冲的通道: 发送操作(<-)和接收操作会互相阻塞, 直到对方准备好
```
channel的三种操作: 发送数据, 接收数据, 关闭通道

```go
// 发送数据
<channel_name> <- <value>

// 接收数据
<value> := <- <channel_name>

// 关闭通道
close(<channel_name>)
```
channel 还有两个变种, 可以把 channel 作为参数传, 限制 channel 在函数或方法中能够执行的操作
```go
// 只读channel(只能接收数据)
func <method_name> (<channel_name> <- chan <type_name>) {
    ...
}

// 只写channel(只能发送数据)
func <method_name> (<channel_name> chan <- <type_name>) {
    ...
}
```
## 示例
```go
package main 

import(
    "fmt"
    "time"
)

// 只接收 channel 的函数
func receiveOnly(ch <-chan int>) {
    for v := range ch {
        fmt.Println("接收到: %d\n", v)
    }
}

// 只发送 channel 的函数
func sendOnly(ch chan<- int) {
    for i := 0; i < 5; i++ {
        ch <- i
        fmt.Println("发送: %d\n", i)
    }
    close(ch)
}

func main() {
    // 创建一个带缓冲的 channel
    ch := make(chan int, 2)

    // 启动发送 goroutine
    go sendOnly(ch)

    // 启动接收 goroutine
    go receiveOnly(ch)

    // 使用 select 进行多路复用
    timeout := time.After(2 * time.Second)
    for{
        select {
            case v, ok := <- ch:
                if !ok {
                    fmt.Printf("channel 已关闭")
                    return
                }
                fmt.Printf("主 goroutine 接收到: %d\n", v)
            case <- timeout:
                fmt.Printf("超时")
                return
            case v := <- ch:
                fmt.Printf("没有数据, 等待中")
                time.Sleep(500 * time.Millisecond)
        }
    }
}

```
# 锁与 channel
在 go 中, 当需要 goroutine 之间协作时, 更常见的方式是使用 channel, 而不是使用 Mutex 或 RWMutex 的互斥锁
- channel 擅长的是数据流动的场景
    - 传递数据的所有权, 即把某个数据发送给其他协程
    - 分发任务, 每个任务都是一个数据
    - 交流异步结果, 结果是一个数据
- 所使用场景更偏向同一时间只给一个协程访问谁的权限
    - 访问缓存
    - 管理状态

# select关键字
select 语义是和 channel 绑定在一起使用的, select 可以实现从多个 channel 收发数据, 可以使得一个 goroutine就可以处理
多个 channel 的通信

语法上和 switch类似, 有 case 分支和 default分支, 只不过 select 的每个 case 后面跟的是 channel 的收发操作
```go
select {
    case <-ch1:  // 接收ch1的数据
        // 处理逻辑
    case ch2 <- x:  // 向ch2发送数据
        // 处理逻辑
    case x, ok := <-ch3:  // 带状态的接收
        // 处理逻辑
    default:  // 所有case都未就绪时执行（非阻塞）
        // 处理逻辑
}
```

## 示例
```go
package main

import (
    "fmt"
    "time"
)

func mian() {
    ch1 := make(chan int, 10)
    ch2 := make(chan int, 10)
    ch3 := make(chan int, 10)

    go func() {
        for i := 0; i < 10; i++ {
            ch1 <- i
            ch2 <- i
            ch3 <- i
        }
    }()

    for i := 0; i < 10; i++ {
        select {
        case x := <- ch1:
            fmt.Println("ch1:", x)
        case y := <- ch2:
            fmt.Println("ch2:", y)
        case z := <- ch3:
            fmt.Println("ch3:", z)
        }
    }
}
```
在执行 select 语句的时候，如果当下那个时间点没有一个 case 满足条件，就会走 default 分支。

至多只能有一个 default 分支。

如果没有 default 分支，select 语句就会阻塞，直到某一个 case 满足条件。

如果 select 里任何 case 和 default 分支都没有，就会一直阻塞。

如果多个 case 同时满足，select 会随机选一个 case 执行。
