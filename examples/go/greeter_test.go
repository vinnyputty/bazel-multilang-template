package greeter

import "testing"

func TestHello(t *testing.T) {
	if got, want := Hello("Bazel"), "Hello, Bazel!"; got != want {
		t.Fatalf("Hello(\"Bazel\") = %q, want %q", got, want)
	}
}

func TestHelloDefault(t *testing.T) {
	if got, want := Hello(""), "Hello, world!"; got != want {
		t.Fatalf("Hello(\"\") = %q, want %q", got, want)
	}
}
