
# Image for build Real Time Innovation`s Data Distribution Services
#

FROM amd64/ubuntu:16.04 AS rti-dds-dev-platform

MAINTAINER "Adrien H."

LABEL vendor=GE\ Healthcare \
      com.ahl.rti.dds.description="RTI DDS Developpement Environment" \
      com.ahl.rti.dds.is-beta= \
      com.ahl.rti.dds.is-production="" \
      com.ahl.rti.dds.vendor="Sloggy Botom" \
      com.ahl.rti.dds.version="0.0.1-beta" \
      com.ahl.rti.dds.homepage="https://github.build.ge.com/100034251/rob-poc-edison-elk-stack/" \
      com.ahl.rti.dds.release-date="2018-12-12" \
      com.ahl.rti.dds.howtouseit="<docker run -d -p 8888:80 imagename> or after repository cloning: <docker-compose up --no-recreate>"

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV LANGUAGE=C.UTF-8

ARG IMAGE_VERSION
ARG TARGET_PLATFORM ${TARGET_PLATFORM:x64Linux}
ARG TARGET_COMPILER ${TARGET_COMPILER:3gcc

RUN apt-get update \
    && apt-get install --assume-yes --no-install-recommends libtool apt-transport-https ca-certificates autotools-dev\
        git xz-utils unzip wget curl openssh-server  openssh-client  automake \
        bison flex build-essential gawk libgcrypt20-dev libcrypto++-dev \
        python-dev python3-dev python-wheel cython cython3 python3-wheel \
        perl-base perl-modules libxml2-dev libxml2-utils python3-setuptools python-setuptools \
        libcgsi-gsoap-dev libgnutls28-dev libcurl4-gnutls-dev libgnutls-openssl27 \
        mesa-common-dev libglu1-mesa-dev libpcap-dev \
        libfontconfig libcrossguid-dev  uuid-dev libossp-uuid-dev \
        libghc-uuid-dev libghc-uuid-types-dev libelf-dev  elfutils libelf1 \
        libpulse-dev  make nfs-common   xauth xterm \
    && apt-get clean --assume-yes  \
    && apt-get --assume-yes --quiet clean \
    && apt-get --assume-yes --quiet autoremove \
    && rm /var/lib/apt/lists/* -r \
    && rm -rf /usr/share/man/

RUN cd /home \
    && curl -L -O -k https://releases.linaro.org/components/toolchain/binaries/5.4-2017.05/aarch64-linux-gnu/gcc-linaro-5.4.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz
    && 
