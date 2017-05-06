FROM node:7.9.0

# install tools
RUN apt-get update 
RUN apt-get install -y rsync zip
RUN npm install -g grunt-cli bower

# set up user
RUN adduser --disabled-password --gecos '' builder
RUN mkdir /build-output && \
    chown builder /build-output 
USER builder

## pre build (move to build.sh)
RUN git clone https://github.com/bitpay/copay.git /home/builder/copay
WORKDIR /home/builder/copay

RUN bower install --allow-root
RUN npm install
RUN npm run apply:copay

## build mobile (move to build.sh)
# cordova platform ls
