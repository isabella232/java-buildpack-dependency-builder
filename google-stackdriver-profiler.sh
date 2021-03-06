#!/usr/bin/env bash

set -euo pipefail

SOURCE_DIRECTORY="cloud-profiler-java"

build() {
  pushd ${SOURCE_DIRECTORY} > /dev/null

    PATH=/usr/local/bin:$PATH

    make JAVA_PATH="/usr/lib/jvm/java-8-openjdk-amd64" all
    tar zcf profiler_java_agent.tar.gz \
      -C .out \
      NOTICES profiler_java_agent.so

  popd > /dev/null
}

version() {
  pushd ${SOURCE_DIRECTORY} > /dev/null

    local version=$(git describe --tags)
    version="${version##v}"

    echo ${version}

  popd > /dev/null
}

VERSION=$(version)

build
cp ${SOURCE_DIRECTORY}/profiler_java_agent.tar.gz repository/google-stackdriver-profiler-$VERSION.tar.gz
echo ${VERSION} > repository/version
