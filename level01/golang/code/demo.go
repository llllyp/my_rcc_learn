package main

import (
	"fmt"
	"time"
)

func goFunc(i int) {
	fmt.Println("goroutine ", i, " ...")
}

func main() {
	for i := 0; i < 10000; i++ {
		go goFunc(i) //开启一个并发协程
	}

	// 主协程（main 函数所在的协程）暂停 1 秒
	// 作用：防止主程序过早退出（主协程结束会终止所有未完成的子协程）
	time.Sleep(time.Second)
}
