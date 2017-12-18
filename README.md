# Docker Alpine Bazel

[![alpine](https://img.shields.io/badge/alpine-v3.6-blue.svg)](https://alpinelinux.org)
[![bazel](https://img.shields.io/badge/bazel-v0.8.0-blue.svg)](https://bazel.build)

Provides a Docker image with Bazel build software running over Alpine Linux.

## Installation
```
$ docker pull alexiskofman/alpine-bazel:3.6_0.8.0
```

Then enjoy what's inside:
```
$ docker run --rm -t alexiskofman/alpine-bazel:latest bazel version
```

# License

MIT Licensed. Copyright (c) Alexis Kofman 2017.
