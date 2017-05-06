# node:7.9.0 is based on Debian GNU/Linux 8 (jessie)
FROM node:7.9.0 

# set up build user and output dir
RUN adduser --disabled-password --gecos '' builder
RUN mkdir /build-output && \
    chown builder /build-output 

# install java 8
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list  && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list  && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886  && \
    apt-get update  && \
	\
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
    DEBIAN_FRONTEND=noninteractive  apt-get install -y --force-yes oracle-java8-installer oracle-java8-set-default  && \
    \
    rm -rf /var/cache/oracle-jdk8-installer  && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# install misc tools
RUN apt-get update; apt-get install -y rsync zip

# install node tools
RUN npm install -g grunt-cli bower

# install android sdk
WORKDIR /opt

ENV ANDROID_SDK_FILENAME android-sdk_r24.4.1-linux.tgz
RUN wget -q http://dl.google.com/android/${ANDROID_SDK_FILENAME} && \
	tar -xzf ${ANDROID_SDK_FILENAME} && \
    rm ${ANDROID_SDK_FILENAME} 

ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

ENV ANDROID_API_LEVELS android-23
ENV ANDROID_BUILD_TOOLS_VERSION 25.0.3
RUN echo y | android update sdk --no-ui -a --filter ${ANDROID_API_LEVELS},build-tools-${ANDROID_BUILD_TOOLS_VERSION},extra-android-m2repository,extra-google-m2repository

RUN chown -R builder:builder ${ANDROID_HOME}


USER builder
