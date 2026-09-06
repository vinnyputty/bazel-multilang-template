# Bazel multi-language template

An intentionally small starter repository for building and testing Rust, Go,
and Python with Bazel and Bzlmod.

## Prerequisites

- Bazelisk (recommended) or Bazel. The repository pins Bazel `8.4.2` in
  [`.bazelversion`](.bazelversion).
- A working network connection on the first build so Bazel can download the
  pinned language rules and toolchains.
- For local development, install Buildifier and the Rust, Go, and Python
  toolchains listed in [`tools/check.sh`](tools/check.sh).

### Rust with Homebrew

Recent Homebrew `rustup` packages no longer include `rustup-init`. Add the
Homebrew keg's proxy directory to your shell and select a default toolchain:

```sh
echo 'export PATH="$(brew --prefix rustup)/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
rustup default stable
```

After that, `rustc`, `cargo`, and `rustfmt` should resolve normally. The
Homebrew formula is keg-only, so adding this directory is required.

The rules configure hermetic Go, Python 3.11, and Rust 1.82 toolchains. If you
want to use different versions, update `MODULE.bazel` and run `bazel mod tidy`.

## Build and test

```sh
bazel test //...
bazel build //examples/...
```

Run the repository's formatting and lint checks with:

```sh
bazel run //:format.check
bazel test //:lint
```

`rules_lint` provides the Buildifier, Ruff, and ShellCheck integrations. Rust
formatting is checked with the `rules_rust` rustfmt aspect in CI:

```sh
bazel build \
  --aspects=@rules_rust//rust:defs.bzl%rustfmt_aspect \
  --output_groups=rustfmt_checks \
  //examples/rust:greeter
```

The examples are deliberately independent so each language can be adopted or
removed without changing the others:

- `examples/python`: a library and `py_test`
- `examples/go`: a library and `go_test`
- `examples/rust`: a library and `rust_test`
- `examples/go/cmd/greeter`: Linux and macOS Go binaries for amd64 and arm64
- `examples/oci`: Go binaries packaged as a multi-architecture OCI image with
  `rules_oci` for Linux `amd64`, `arm64`, and `arm/v7`

Build the macOS binaries with:

```sh
bazel build //examples/go/cmd/greeter:greeter_macos_arm64
bazel build //examples/go/cmd/greeter:greeter_macos_amd64
```

Build the example image and inspect its digest with:

```sh
bazel build //examples/oci:greeter_image
cat bazel-bin/examples/oci/greeter_image.json.sha256
```

The image build does not require Docker. `bazel run` requires Docker, Podman,
or nerdctl:

```sh
bazel run //examples/oci:greeter_load
docker run --rm bazel-multilang-template:latest
```

The `greeter_load` target loads the native arm64 image for local Docker
execution. To produce or load the complete multi-architecture OCI index
instead, use `//examples/oci:greeter_load_index`; OCI-index loading depends on
the runtime's image-store support.

The container structure test uses the image tarball and does not require a
container runtime:

```sh
bazel test //examples/oci:greeter_structure_test
```

Run the local prerequisite check with:

```sh
./tools/check.sh
```

To format BUILD/Starlark files after installing Buildifier:

```sh
buildifier -r .
```

## Adding code

Keep each package focused and add a test beside the implementation. Then run
`bazel test //...` before committing. For third-party dependencies, prefer
declaring a Bazel module in `MODULE.bazel` and keeping application code free of
machine-specific paths.
