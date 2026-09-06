#!/usr/bin/env bash
set -u

missing=0
for tool in bazelisk bazel buildifier go python3; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf 'found   %-10s %s\n' "$tool" "$(command -v "$tool")"
  else
    printf 'missing %-10s\n' "$tool"
    missing=1
  fi
done

if command -v rustc >/dev/null 2>&1 && command -v cargo >/dev/null 2>&1; then
  printf 'found   %-10s %s\n' rustc "$(command -v rustc)"
  printf 'found   %-10s %s\n' cargo "$(command -v cargo)"
elif command -v rustup >/dev/null 2>&1; then
  printf 'setup   %-10s rustup is installed, but its Rust proxy directory is not on PATH\n' rust
  rustup_path="$(brew --prefix rustup 2>/dev/null || printf '%s' /opt/homebrew/opt/rustup)"
  # shellcheck disable=SC2016 # Print the literal $PATH for the user to source.
  printf '         export PATH="%s/bin:$PATH"\n' "$rustup_path"
  printf '         rustup default stable\n'
  missing=1
else
  printf 'missing %-10s (install rustup; it provides rustc and cargo)\n' rustup
  missing=1
fi

if command -v pyenv >/dev/null 2>&1; then
  printf 'found   %-10s %s\n' pyenv "$(command -v pyenv)"
else
  printf 'optional %-8s (recommended for managing local Python versions)\n' pyenv
fi

if (( missing )); then
  printf '\nInstall the missing required tools, then run: bazel test //...\n' >&2
  exit 1
fi
