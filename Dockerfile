FROM node:7.9.0

# Clone repo + get dependencies
RUN git clone https://github.com/bitpay/copay.git; \
	cd copay; \
	npm install; 
