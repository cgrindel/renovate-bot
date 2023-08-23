# Self-hosted Renovate Instance

This self-hosted Renovate instance uses a custom Docker image that includes Bazelisk and other
pre-requisites so that post-upgrade tasks can run Bazel targets.

## Important Notes

- Renovate updates dependencies in this repository.
- Any pull request that is merged will trigger the [Create Release workflow].
- The [Create Release workflow] can also be triggered manually specifying which part of the semver
  to increment.
- [Create Release workflow]
  - Creates a release incrementing the semver. The default increment is the `patch` portion of the
    semver.
  - Builds and publishes a Docker image
    - Image URL: `ghcr.io/cgrindel/renovate-bot`
    - [View published Docker images]
    - [Dockerfile to build the image]
- [Renovate workflow]
  - The configuration for the Renovate instance lives in [renovate-global.json].
  - The Renovate configuration for this repository lives in [renovate.json].

[Create Release workflow]: /.github/workflows/create_release.yml
[Dockerfile to build the image]: /renovate_image/Dockerfile
[Renovate workflow]: /.github/workflows/renovate.yml
[View published Docker images]: https://github.com/cgrindel/renovate-bot/pkgs/container/renovate-bot
[renovate-global.json]: /.github/renovate-global.json
[renovate.json]: /.github/renovate.json
[semver]: https://semver.org/
