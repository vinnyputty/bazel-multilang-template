package main

import (
	"fmt"

	greeter "example.com/bazel-multilang-template/examples/go"
)

func main() {
	fmt.Println(greeter.Hello("Bazel"))
}
