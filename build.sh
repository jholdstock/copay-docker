#!/bin/bash

set -e

DIST_DIR=$(pwd)/build-output

# initialize directory for build artifacts
if [ -d $DIST_DIR ]; then
  rm -rf $DIST_DIR
fi
mkdir $DIST_DIR && chmod 777 $DIST_DIR

docker build -t copay-docker .
docker run --rm -it -v $DIST_DIR:/build-output copay-docker /bin/bash -c "\
	cd chrome-app
	grunt
	make
	rsync -ra copay-chrome-extension.zip /build-output"