package greeter

import "fmt"

// Hello returns a stable greeting suitable for a command or service.
func Hello(name string) string {
	if name == "" {
		name = "world"
	}
	return fmt.Sprintf("Hello, %s!", name)
}
