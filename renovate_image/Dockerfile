# Based on Renovate image
FROM ghcr.io/renovatebot/renovate:39.203

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

# Inspired by https://github.com/apple/swift-docker/blob/main/5.8/ubuntu/20.04/Dockerfile
# pub   4096R/ED3D1561 2019-03-22 [SC] [expires: 2023-03-23]
#       Key fingerprint = A62A E125 BBBF BB96 A6E0  42EC 925C C1CC ED3D 1561
# uid                  Swift 5.x Release Signing Key <swift-infrastructure@swift.org
ARG SWIFT_SIGNING_KEY=A62AE125BBBFBB96A6E042EC925CC1CCED3D1561
ARG SWIFT_PLATFORM=ubuntu20.04
ARG SWIFT_BRANCH=swift-5.8.1-release
ARG SWIFT_VERSION=swift-5.8.1-RELEASE
ARG SWIFT_WEBROOT=https://download.swift.org

ENV SWIFT_SIGNING_KEY=$SWIFT_SIGNING_KEY \
    SWIFT_PLATFORM=$SWIFT_PLATFORM \
    SWIFT_BRANCH=$SWIFT_BRANCH \
    SWIFT_VERSION=$SWIFT_VERSION \
    SWIFT_WEBROOT=$SWIFT_WEBROOT

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
    SWIFT_WEBDIR="$SWIFT_WEBROOT/$SWIFT_BRANCH/$(echo $SWIFT_PLATFORM | tr -d .)$OS_ARCH_SUFFIX" \
    && SWIFT_BIN_URL="$SWIFT_WEBDIR/$SWIFT_VERSION/$SWIFT_VERSION-$SWIFT_PLATFORM$OS_ARCH_SUFFIX.tar.gz" \
    && SWIFT_SIG_URL="$SWIFT_BIN_URL.sig" \
    # - Download the GPG keys, Swift toolchain, and toolchain signature, and verify.
    && export GNUPGHOME="$(mktemp -d)" \
    && export SWIFT_DOWNLOAD="$(mktemp -d)" \
    && cd "${SWIFT_DOWNLOAD}" \
    && curl -fsSL "$SWIFT_BIN_URL" -o swift.tar.gz "$SWIFT_SIG_URL" -o swift.tar.gz.sig \
    && gpg --batch --quiet --keyserver keyserver.ubuntu.com --recv-keys "$SWIFT_SIGNING_KEY" \
    && gpg --batch --verify swift.tar.gz.sig swift.tar.gz \
    # - Unpack the toolchain, set libs permissions, and clean up.
    && tar -xzf swift.tar.gz --directory / --strip-components=1 \
    && chmod -R o+r /usr/lib/swift \
    && rm -rf "$GNUPGHOME" "${SWIFT_DOWNLOAD}"

# END: Install Swift

# Back to less privileged user
USER 1000

# Install Bazelisk
RUN npm install -g @bazel/bazelisk


# Set required environment variables
ENV CC=clang

# Use the entrypoint from the Renovate image
