import unittest

from examples.python.greeter import hello


class GreeterTest(unittest.TestCase):
    def test_hello(self) -> None:
        self.assertEqual(hello("Bazel"), "Hello, Bazel!")

    def test_hello_default(self) -> None:
        self.assertEqual(hello(""), "Hello, world!")


if __name__ == "__main__":
    unittest.main()
