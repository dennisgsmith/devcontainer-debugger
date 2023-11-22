package main

import (
	"fmt"
	"time"
)

func main() {
	for true {
		fmt.Print("hello world")
		time.Sleep(5 + time.Second)
	}
}
