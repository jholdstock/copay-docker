FROM node:7.9.0

RUN git clone https://github.com/bitpay/copay.git /copay
WORKDIR /copay

RUN npm install -g grunt-cli bower
RUN echo 'y' | bower install --allow-root

RUN npm install
RUN	npm run apply:copay;

ENTRYPOINT /bin/bash
