FROM  python:3.6.3-alpine3.6
LABEL maintainer="Alexis Kofman <alexis.kofman@gmail.com>"

ENV BAZEL_VERSION="0.8.0" \
    BAZEL_SHA256SUM="aa840321d056abd3c6be10c4a1e98a64f9f73fff9aa89c468dae8c003974a078  bazel-0.8.0-dist.zip" \
    JAVA_HOME="/usr/lib/jvm/default-jvm"

RUN apk update && apk upgrade && \
    apk add --no-cache libstdc++ openjdk8 && \
    apk add --no-cache --virtual build-dependencies bash curl coreutils gcc g++ linux-headers unzip zip && \
    DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sLO https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-dist.zip && \
    echo ${BAZEL_SHA256SUM} | sha256sum --check && \    
    unzip bazel-${BAZEL_VERSION}-dist.zip && \
    ./compile.sh && \
    cp ${DIR}/output/bazel /usr/local/bin/ && \
    rm -rf ${DIR} && \
    apk del build-dependencies