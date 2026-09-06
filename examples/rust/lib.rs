/// Return a stable greeting suitable for a command or service.
pub fn hello(name: &str) -> String {
    let name = if name.is_empty() { "world" } else { name };
    format!("Hello, {name}!")
}

#[cfg(test)]
mod tests {
    use super::hello;

    #[test]
    fn greets_by_name() {
        assert_eq!(hello("Bazel"), "Hello, Bazel!");
    }

    #[test]
    fn uses_a_default_name() {
        assert_eq!(hello(""), "Hello, world!");
    }
}
