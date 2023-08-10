#!/usr/bin/env bash

# DEBUG BEGIN
set -x

which bazelisk || echo "bazelisk not found"
which clang || echo "clang not found"
which renovate || echo "renovate not found"
# DEBUG END
