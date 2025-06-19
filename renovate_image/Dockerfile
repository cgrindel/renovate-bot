# Based on Renovate image
FROM ghcr.io/renovatebot/renovate:41

# Become root
USER 0

# Install apt deps
RUN install-apt clang
RUN install-apt default-jdk

# BEGIN: Install Recent Go

ARG GO_VERSION=1.21.0

ENV GO_VERSION=$GO_VERSION

RUN set -e; \
    ARCH_NAME="$(dpkg --print-architecture)"; \
    url=; \
    case "${ARCH_NAME##*-}" in \
        'amd64') \
            OS_ARCH_SUFFIX=''; \
            ;; \
        'arm64') \
            OS_ARCH_SUFFIX='-aarch64'; \
            ;; \
        *) echo >&2 "error: unsupported architecture: '$ARCH_NAME'"; exit 1 ;; \
    esac; \
    GO_BIN_URL="https://go.dev/dl/go${GO_VERSION}.linux-${ARCH_NAME}.tar.gz" \
    && export GO_DOWNLOAD="$(mktemp -d)" \
    && cd "${GO_DOWNLOAD}" \
    && curl -fsSL "$GO_BIN_URL" -o go.tar.gz \
    && tar -xzf go.tar.gz --directory /usr/local \
    && rm -rf "${GO_DOWNLOAD}"

ENV PATH="${PATH}:/usr/local/go/bin"

# END: Install Recent Go

# BEGIN: Install Swift

# Prerequisites
RUN install-apt libicu-dev 
RUN install-apt build-essential 
RUN install-apt pkg-config

# Inspired by https://github.com/swiftlang/swift-docker/blob/main/6.1/ubuntu/20.04/Dockerfile
# NOTE: When copying over the latest code, do not install/uninstall curl. It is
# already part of the base image. Also, it is used later in the build.

# pub   rsa4096 2024-09-16 [SC] [expires: 2026-09-16]
#      52BB7E3DE28A71BE22EC05FFEF80A866B47A981F
# uid           [ unknown] Swift 6.x Release Signing Key <swift-infrastructure@forums.swift.org>
ARG SWIFT_SIGNING_KEY=52BB7E3DE28A71BE22EC05FFEF80A866B47A981F
ARG SWIFT_PLATFORM=ubuntu20.04
ARG SWIFT_BRANCH=swift-6.1-release
ARG SWIFT_VERSION=swift-6.1-RELEASE
ARG SWIFT_WEBROOT=https://download.swift.org

ENV SWIFT_SIGNING_KEY=$SWIFT_SIGNING_KEY \
    SWIFT_PLATFORM=$SWIFT_PLATFORM \
    SWIFT_BRANCH=$SWIFT_BRANCH \
    SWIFT_VERSION=$SWIFT_VERSION \
    SWIFT_WEBROOT=$SWIFT_WEBROOT

RUN set -e; \
    ARCH_NAME="$(dpkg --print-architecture)"; \
    case "${ARCH_NAME##*-}" in \
        'amd64') \
            OS_ARCH_SUFFIX=''; \
            ;; \
        'arm64') \
            OS_ARCH_SUFFIX='-aarch64'; \
            ;; \
        *) echo >&2 "error: unsupported architecture: '$ARCH_NAME'"; exit 1 ;; \
    esac; \
    SWIFT_WEBDIR="$SWIFT_WEBROOT/$SWIFT_BRANCH/$(echo $SWIFT_PLATFORM | tr -d .)$OS_ARCH_SUFFIX" \
    && SWIFT_BIN_URL="$SWIFT_WEBDIR/$SWIFT_VERSION/$SWIFT_VERSION-$SWIFT_PLATFORM$OS_ARCH_SUFFIX.tar.gz" \
    && SWIFT_SIG_URL="$SWIFT_BIN_URL.sig" \
    # - Download the GPG keys, Swift toolchain, and toolchain signature, and verify.
    && export GNUPGHOME="$(mktemp -d)" \
    && curl -fsSL "$SWIFT_BIN_URL" -o swift.tar.gz "$SWIFT_SIG_URL" -o swift.tar.gz.sig \
    && gpg --batch --quiet --keyserver keyserver.ubuntu.com --recv-keys "$SWIFT_SIGNING_KEY" \
    && gpg --batch --verify swift.tar.gz.sig swift.tar.gz \
    # - Unpack the toolchain, set libs permissions, and clean up.
    && tar -xzf swift.tar.gz --directory / --strip-components=1 \
    && chmod -R o+r /usr/lib/swift \
    && rm -rf "$GNUPGHOME" swift.tar.gz.sig swift.tar.gz

# END: Install Swift

# Back to less privileged user
# ubuntu user (12021) according to 
# https://github.com/renovatebot/renovate/blob/1ea20d5285511da18258177b893ac461df718f9f/tools/docker/Dockerfile#L121C6-L121C11
USER ubuntu

# BEGIN: Install Bazelisk

ARG BAZELISK_VERSION=v1.26.0

ENV BAZELISK_VERSION=$BAZELISK_VERSION

# RUN npm install -g @bazel/bazelisk
RUN set -e -x; \
    ARCH_NAME="$(dpkg --print-architecture)"; \
    case "${ARCH_NAME##*-}" in \
        'amd64') \
            OS_ARCH_SUFFIX='-amd64'; \
            ;; \
        'arm64') \
            OS_ARCH_SUFFIX='-arm64'; \
            ;; \
        *) echo >&2 "error: unsupported architecture: '$ARCH_NAME'"; exit 1 ;; \
    esac; \
    BAZELISK_BIN=/usr/local/bin/bazelisk \
    BAZELISK_URL="https://github.com/bazelbuild/bazelisk/releases/download/${BAZELISK_VERSION}/bazelisk-linux${OS_ARCH_SUFFIX}" \
    && pwd \
    && curl -fsSL "${BAZELISK_URL}" -o "${BAZELISK_BIN}" \
    && chmod +x "${BAZELISK_BIN}"

# END: Install Bazelisk

# Set required environment variables
ENV CC=clang

# Use the entrypoint from the Renovate image
