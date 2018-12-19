# Image for build GitHub Pull Requests for OpenDDS
FROM amd64/ubuntu:18.10
MAINTAINER "Adrien H."
LABEL description="Env for developping c++ application"
LABEL Version="0.1.1"
LABEL Vendor="Sloggy Botom"
LABEL Homepage="https://gitlab..../github/...whatever"
LABEL HowToUseIt="<docker run -d -p 8888:80 imagename> or after repository cloning: <docker-compose up --no-recreate>"


ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN apt-get update \
    && apt-get install --assume-yes \
       apt-transport-https \
       ca-certificates \
       software-properties-common

RUN apt-get update \
    && apt-get install --assume-yes gpg git xz-utils unzip wget curl openssh-server  openssh-client \
    && apt-get clean --assume-yes \
    && apt-get --assume-yes --quiet clean \
    && apt-get --assume-yes --quiet autoremove \
    && rm /var/lib/apt/lists/* -r \
    && rm -rf /usr/share/man/*

RUN apt-get update \
    && apt-get install --assume-yes --no-install-recommends \
        bison flex gsoap build-essential gawk libgcrypt20-dev libcrypto++-dev \
        python-wheel cython cython3 python3-wheel \
        perl-base perl-modules \
        libxml2-dev libxml2-utils python3-setuptools python-setuptools \
        libcgsi-gsoap-dev libgnutls28-dev libcurl4-gnutls-dev libgnutls-openssl27 \
        mesa-common-dev libglu1-mesa-dev libpcap-dev libglib2.0-dev libssl1.0-dev \
        libfontconfig libldap2-dev libldap-2.4-2  libmysql++-dev \
        unixodbc-dev libgdbm-dev libodb-pgsql-dev libcrossguid-dev  uuid-dev libossp-uuid-dev \
        libghc-uuid-dev libghc-uuid-types-dev ruby ruby-dev libelf-dev  elfutils libelf1 \
        libpulse-dev  make gcc-8 g++-8 nfs-common \
    && apt-get --assume-yes --quiet clean \
    && apt-get --assume-yes --quiet autoremove \
    && rm /var/lib/apt/lists/* -r \
    && rm -rf /usr/share/man/*


RUN mkdir -pv /opt/cmake \
   &&  wget -qO- "https://cmake.org/files/v3.13/cmake-3.13.2-Linux-x86_64.tar.gz" \
        | tar --strip-components=1 -xz -C /opt/cmake

RUN export PATH=$PATH:/opt/cmake/bin

# Download boost, untar, setup install with bootstrap and only do the Program Options library,
# and then install
#RUN cd /home && curl -L -O -k https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.gz \
#    && tar xfz boost_1_68_0.tar.gz > /dev/null \
#    && rm boost_1_68_0.tar.gz \
#    && cd boost_1_68_0 \
#    && ./bootstrap.sh --prefix=/usr/local --with-python=python3 \
#    && ./b2 link=shared threading=multi variant=release address-model=64 \
#    && ./b2 install \
#    && cd /home 
#    && rm -rf boost_1_68_0

#RUN cd /home && curl -L -O http://www-us.apache.org/dist//xerces/c/3/sources/xerces-c-3.2.2.tar.gz \
#    && tar -xvzf xerces-c-3.2.2.tar.gz  > /dev/null \
#    && rm xerces-c-3.2.2.tar.gz \
#    && cd xerces-c-3.2.2/ \
#    && ./configure --prefix=/usr/local \
#            --enable-static --enable-shared --enable-netaccessor-socket \
#            --enable-transcoder-gnuiconv --enable-transcoder-iconv \
#            --enable-msgloader-inmemory --enable-xmlch-uint16_t --enable-xmlch-char16_t \
#    && make clean && make && make install \
#    && cd /home \
#    && rm -rf xerces-c-3.2.2/

#RUN cd /home &&  git clone --depth=1 https://github.com/protocolbuffers/protobuf.git \
#    && cd protobuf \
#    && ./autogen.sh \
#    && ./configure --prefix=/usr/local \
#    && make clean && make && make install \
#    && cd /home \
#    && rm -rf protobuf

#ARG GET_DDS_REPO="https://github.com/objectcomputing/OpenDDS.git"
#ARG GET_DDS_VERSION="DDS-3.13"

#RUN git clone ${GET_DDS_REPO} \
#    && OpenDDS \
#    && git fetch origin ${GET_DDS_VERSION} \
#    && git checkout ${GET_DDS_VERSION} \

RUN wget https://www.jacorb.org/releases/3.9/jacorb-3.9-binary.zip \
    && unzip jacorb-3.9-binary.zip \
    && mv -v jacorb-3.9 /opt/

RUN wget https://www.jacorb.org/releases/2.3.1/jacorb-2.3.1-bin.zip \
    && unzip jacorb-2.3.1-bin.zip \
    && mv -v jacorb-2.3.1 /opt/

RUN wget https://www-eu.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz \
    && tar -xvzf apache-maven-3.6.0-bin.tar.gz \
    && mv apache-maven-3.6.0/ /opt/

#RUN wget --no-cookies --no-check-certificate \
#        --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"\
#        "https://download.oracle.com/otn-pub/java/jdk/8u192-b12/750e1c8617c5452694857ad95c3ee230/jdk-8u192-linux-x64.tar.gz" \
#    && tar -xvzf jdk-8u192-linux-x64.tar.gz

RUN export JAVA_HOME=/opt/jdk1.8.0_192
RUN export JRE_HOME=/opt/jdk1.8.0_192/jre
RUN export M2_HOME=/opt/apache-maven/
RUN export M2=$M2_HOME/bin
RUN export MAVEN_OPTS="-Dstyle.info=bold,green -Dstyle.project=bold,magenta -Dstyle.warning=bold,yellow \
        -Dstyle.mojo=bold,cyan -Xmx1048m -Xms256m -XX:MaxPermSize=312M"
RUN export PATH=$PATH:/opt/apache-maven/bin/:/opt/cmake/bin:/opt/jdk1.8.0_192/bin:/opt/jdk1.8.0_192/jre/bin
