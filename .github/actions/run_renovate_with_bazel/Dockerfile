# Based on Renovate image
FROM ghcr.io/renovatebot/renovate:36.24

# Install Bazelisk
RUN npm install -g @bazel/bazelisk

# Install latest stable clang
# https://apt.llvm.org/
# bash -c "$(curl -fsSL https://apt.llvm.org/llvm.sh)"
# install-tool llvm-toolchain 16.0.0
# install-tool clang-16 16.0.0
# install-tool lldb-16 16.0.0
# install-tool lld-16 16.0.0
RUN install-tool clang 16.0.0
RUN install-tool lldb 16.0.0
RUN install-tool lld 16.0.0

COPY fake_entrypoint.sh /fake_entrypoint.sh

ENTRYPOINT ["/fake_entrypoint.sh"]
