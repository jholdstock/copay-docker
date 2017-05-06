#!/bin/bash

set -e

OUTPUT_DIR=$(pwd)/build-output
BUILD_TAG=copay-docker

# initialize directory for build artifacts
if [ -d $OUTPUT_DIR ]; then
  rm -rf $OUTPUT_DIR
fi
mkdir $OUTPUT_DIR && chmod 777 $OUTPUT_DIR

docker build -t $BUILD_TAG .

echo
echo "--------------------"
echo " Built $BUILD_TAG " 
echo "--------------------"
echo

docker run --rm -it -v $OUTPUT_DIR:/build-output $BUILD_TAG /bin/bash -c "
	git clone https://github.com/bitpay/copay.git /home/builder/copay;
	cd /home/builder/copay;

	bower install --allow-root;
	npm install;
	npm run apply:copay;
	grunt;

	# build android
	npm run build:android; 
	rsync -ra platforms/android/build/outputs/apk/android-debug.apk /build-output;

	# build chrome-extension
	cd chrome-app; 
	make; 
	rsync -ra copay-chrome-extension.zip /build-output;"
