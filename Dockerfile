FROM  python:alpine
LABEL maintainer="Alexis Kofman <alexis.kofman@gmail.com>"

ENV BAZEL_VERSION="4.0.0" \
    JAVA_HOME="/usr/lib/jvm/default-jvm"

RUN apk update && apk upgrade && \
    apk add --no-cache libstdc++ openjdk8 && \
    apk add --no-cache --virtual build-dependencies bash curl coreutils gcc g++ linux-headers unzip zip && \
    DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sLO https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-dist.zip && \
    curl -sL ${_}.sha256 | sha256sum --check && \    
    unzip bazel-${BAZEL_VERSION}-dist.zip && \
    ./compile.sh && \
    cp ${DIR}/output/bazel /usr/local/bin/ && \
    rm -rf ${DIR} && \
    apk del build-dependencies
