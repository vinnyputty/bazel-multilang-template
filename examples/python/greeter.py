def hello(name: str = "world") -> str:
    """Return a stable greeting suitable for a command or service."""
    return f"Hello, {name or 'world'}!"
