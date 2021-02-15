FROM  alpine

LABEL maintainer="Alexis Kofman <alexis.kofman@gmail.com>"

ENV BAZEL_VERSION="4.0.0" JAVA_HOME="/usr/lib/jvm/default-jvm"

COPY build.sh build.sh

RUN ./build.sh
