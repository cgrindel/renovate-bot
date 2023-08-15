# Based on Renovate image
FROM ghcr.io/renovatebot/renovate:36.24

# Install clang
USER 0
RUN install-apt clang
USER 1000

# Install Bazelisk
RUN npm install -g @bazel/bazelisk

COPY fake_entrypoint.sh /fake_entrypoint.sh

ENTRYPOINT ["/fake_entrypoint.sh"]
