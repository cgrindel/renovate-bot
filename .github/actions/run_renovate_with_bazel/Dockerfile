# Based on Renovate image
FROM ghcr.io/renovatebot/renovate:36.24

# Install Bazelisk
RUN npm install -g @bazel/bazelisk

# Install latest stable clang
# https://apt.llvm.org/
RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

COPY fake_entrypoint.sh /fake_entrypoint.sh

ENTRYPOINT ["/fake_entrypoint.sh"]
