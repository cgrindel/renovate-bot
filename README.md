# Self-hosted Renovate Instance

This self-hosted Renovate instance uses a custom Docker image that includes Bazelisk and other
pre-requisites so that post-upgrade tasks can run Bazel targets.

## Important Notes

- New Docker images are [published](/.github/workflows/publish_image.yml) when a new release of this
  repository occurs.
  - Image URL: `ghcr.io/cgrindel/renovate-bot`
  - [View published Docker images](https://github.com/cgrindel/renovate-bot/pkgs/container/renovate-bot)
  - [Dockerfile to build the image](/renovate_image/Dockerfile)
- [Renovate workflow](/.github/workflows/renovate.yml)
  - The configuration for the Renovate instance lives in
    [renovate-global.json](/.github/renovate-global.json).
  - The Renovate configuration for this repository lives in [renovate.json](/.github/renovate.json)
