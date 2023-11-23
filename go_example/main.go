package main

import (
	"fmt"
	"time"
)

func main() {
	for {
		fmt.Print("hello world")
		time.Sleep(5 + time.Second)
	}
}
