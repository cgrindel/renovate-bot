# Based on Renovate image
FROM ghcr.io/renovatebot/renovate:36.49

# Install clang and Go
USER 0
RUN install-apt clang
RUN install-apt golang-go
USER 1000

# Install Bazelisk
RUN npm install -g @bazel/bazelisk

# Use the entrypoint from the Renovate image
