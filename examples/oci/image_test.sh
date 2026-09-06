#!/usr/bin/env bash
set -euo pipefail

digest_file="${TEST_SRCDIR}/${TEST_WORKSPACE}/examples/oci/greeter_image.json.sha256"
test -s "$digest_file"
case "$(cat "$digest_file")" in
  sha256:*) ;;
  *) echo "unexpected OCI digest: $(cat "$digest_file")" >&2; exit 1 ;;
esac
