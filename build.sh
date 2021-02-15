#/usr/bin/env sh

set -e

install_glibc(){
  wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-2.32-r0.apk
  wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-bin-2.32-r0.apk
  wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-dev-2.32-r0.apk
  wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-i18n-2.32-r0.apk
  apk add *.apk --allow-untrusted
}

# apk update && apk upgrade
apk add --no-cache libstdc++ openjdk8
apk add --no-cache --virtual build-dependencies bash curl coreutils gcc g++ linux-headers unzip zip
apk add --no-cache python3 file patch git vim wget
ln -s python3 /usr/bin/python

DIR=$(mktemp -d) && cd ${DIR}
# curl -LO --progress-bar https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-dist.zip
wget https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-dist.zip
curl -sL https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-dist.zip.sha256 | sha256sum --check
unzip -q -o bazel-${BAZEL_VERSION}-dist.zip
# https://github.com/bazelbuild/bazel/issues/12460
# https://stackoverflow.com/questions/41446716/use-temp-failure-retry-on-osx/41446972#41446972
cat >>./src/main/tools/linux-sandbox-pid1.h <<EOF
#ifndef TEMP_FAILURE_RETRY
#define TEMP_FAILURE_RETRY(exp)            \
  ({                                       \
    decltype(exp) _rc;                     \
    do {                                   \
      _rc = (exp);                         \
    } while (_rc == -1 && errno == EINTR); \
    _rc;                                   \
  })
#endif
EOF
# https://qiita.com/naka345/items/e8a052af0834cb9e581c
sed -i -e 's/-classpath/-J-Xmx6096m -J-Xms128m -classpath/g' scripts/bootstrap/compile.sh
# https://docs.bazel.build/versions/master/install-compile-source.html#bootstrap-bazel
env EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" ./compile.sh
cp ${DIR}/output/bazel /usr/local/bin/
install_glibc
rm -rf ${DIR}

# apk del build-dependencies
