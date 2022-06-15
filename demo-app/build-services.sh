#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Incorrect parameters"
    echo "Usage: build-services.sh <version> <prefix>"
    exit 1
fi

VERSION=$1
PREFIX=$2
SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#kubectl delete -f demo-app/app/app.yaml

pushd "$SCRIPTDIR/python-main"
  docker build --pull -t "${PREFIX}/jaeger-main-python-v1:${VERSION}" -t "${PREFIX}/jaeger-main-python-v1:latest" .
popd

pushd "$SCRIPTDIR/python-formatter"
  docker build --pull -t "${PREFIX}/jaeger-formatter-python-v1:${VERSION}" -t "${PREFIX}/jaeger-formatter-python-v1:latest" .
popd

pushd "$SCRIPTDIR/java-app"
  mvn clean package
  docker build --pull -t "${PREFIX}/jaeger-demo-a-v1:${VERSION}" -t "${PREFIX}/jaeger-demo-a-v1:latest" .
popd

kubectl apply -f demo-app/app/app-with-values.yaml