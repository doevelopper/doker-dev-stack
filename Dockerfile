# Image for build GitHub Pull Requests for OpenDDS
FROM amd64/ubuntu:18.10 AS dev-platform
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
    && apt-get install --assume-yes gpg git xz-utils unzip wget curl openssh-server  openssh-client libtool\
    && apt-get clean --assume-yes \
    && apt-get --assume-yes --quiet clean \
    && apt-get --assume-yes --quiet autoremove \
    && rm /var/lib/apt/lists/* -r \
    && rm -rf /usr/share/man/*

RUN apt-get update \
    && apt-get install --assume-yes --no-install-recommends perl \
#        libcurl4-openssl-dev libcurl4-gnutls-dev libcurl4-nss-dev \
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
    && apt-get autoclean --assume-yes \
    && rm /var/lib/apt/lists/* -r \
    && rm -rf /usr/share/man/*


RUN mkdir -pv /opt/cmake \
   &&  wget -qO- "https://cmake.org/files/v3.13/cmake-3.13.2-Linux-x86_64.tar.gz" \
        | tar --strip-components=1 -xz -C /opt/cmake

RUN export PATH=$PATH:/opt/cmake/bin

RUN  cd /home && export PATH=$PATH:/opt/cmake/bin && cmake --version \
    && git clone --depth=1 https://github.com/uncrustify/uncrustify.git \
    && cd uncrustify \
    && cmake -E make_directory build \
    && cmake -E chdir build cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
    && cmake --build build --target all --clean-first \
    && cmake --build build --target install \
    && cd /home \
    && rm -rvf uncrustify

RUN  cd /home && export PATH=$PATH:/opt/cmake/bin && cmake --version \
    && git clone --depth=1 https://github.com/danmar/cppcheck.git \
    && cd cppcheck \
    && cmake -E make_directory build \
    && cmake -E chdir build cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
    && cmake --build build --target all --clean-first  \
    && cmake --build build --target install \
    && cp --recursive --verbose cfg  /usr/local/bin || true \
    && cd /home \
    && rm -rvf cppcheck

RUN  cd /home && export PATH=$PATH:/opt/cmake/bin && cmake --version \
    && git clone --depth=1 https://github.com/doxygen/doxygen.git  \
    && cd doxygen \
    && cmake -E make_directory build \
    && cmake -E chdir build cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
    && cmake --build build --target all --clean-first  \
    && cmake --build build --target install \
    && cd /home \
    && rm -rvf doxygen

RUN  cd /home && export PATH=$PATH:/opt/cmake/bin && cmake --version \
    && git clone --depth=1 https://github.com/google/googletest.git \
    && cd googletest \
    && cmake -E make_directory build \
    && cmake -E chdir build cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
    && cmake --build build --target all --clean-first  \
    && cmake --build build --target install \
    && cd /home \
    && rm -rvf googletest

RUN  cd /home && export PATH=$PATH:/opt/cmake/bin && cmake --version \
    && git clone --depth=1 https://github.com/google/benchmark.git \
    && cd benchmark \
    && cmake -E make_directory build \
    && cmake -E chdir build cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
    && cmake --build build --target all --clean-first  \
    && cmake --build build --target install \
    && cd /home \
    && rm -rvf benchmark

RUN  cd /home && make --version \
    && curl -L -O -k https://www-us.apache.org/dist/apr/apr-1.6.5.tar.gz  \
    && tar -xvzf apr-1.6.5.tar.gz > /dev/null  \
    && cd apr-1.6.5 \
    && ./configure --prefix=/usr/ --enable-threads --enable-posix-shm \
        --enable-allocator-guard-pages --enable-pool-concurrency-check --enable-other-child \
    && make clean && make && make install  \
    && cd /home \
    && rm -rvf apr-1.6.5.tar.gz apr-1.6.5

RUN  cd /home && export PATH=$PATH:/opt/cmake/bin && cmake --version \
    && git clone --depth=1 https://github.com/libexpat/libexpat.git  \
    && cd libexpat/expat  \
    && cmake -E make_directory build \
    && cmake -E chdir build cmake .. -DCMAKE_INSTALL_PREFIX=/usr/ \
    && cmake --build build --target all --clean-first  \
    && cmake --build build --target install \
    && cd /home \
    && rm -rvf libexpat

RUN  cd /home && make --version \
    && curl -L -O -k https://www-us.apache.org/dist//apr/apr-util-1.6.1.tar.gz  \
    && tar -xvzf apr-util-1.6.1.tar.gz > /dev/null  \
    && cd apr-util-1.6.1 \
    && ./configure --prefix=/usr/ --with-apr=/usr/ --with-expat=/usr/ \
    && make clean && make && make install  \
    && cd /home \
    && rm -rvf apr-util-1.6.1.tar.gz apr-util-1.6.1

RUN  cd /home && make --version \
    && git clone --depth=1 https://gitbox.apache.org/repos/asf/logging-log4cxx.git  \
    && cd logging-log4cxx  \
    && ./autogen.sh \
    && ./configure --prefix=/usr/ --with-apr=/usr/ --with-apr-util=/usr/ \
		--enable-char --enable-wchar_t --with-charset=utf-8 --with-logchar=utf-8 \
    && make clean && make && make install  \
    && cd /home \
    && rm -rvf logging-log4cxx

RUN apt-get update \
    && apt-get install --assume-yes --no-install-recommends python-dev python3-dev 
# Download boost, untar, setup install with bootstrap and only do the Program Options library,
# and then install
RUN cd /home \
	&& curl -L -O -k https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.gz \
    && tar xfz boost_1_69_0.tar.gz > /dev/null \
    && cd boost_1_69_0 \
    && ./bootstrap.sh --prefix=/usr/ \
    && ./b2 --help \
    && ./b2 link=shared threading=multi variant=release address-model=64 \
    && ./b2 install \
    && cd /home \
    && rm -rvf boost_1_68_0 boost_1_69_0.tar.gz

RUN cd /home \
    && curl -L -O http://www-us.apache.org/dist//xerces/c/3/sources/xerces-c-3.2.2.tar.gz \
    && tar -xvzf xerces-c-3.2.2.tar.gz  > /dev/null \
    && rm xerces-c-3.2.2.tar.gz \
    && cd xerces-c-3.2.2/ \
    && ./configure --prefix=/usr \
            --enable-static --enable-shared --enable-netaccessor-socket \
            --enable-transcoder-gnuiconv --enable-transcoder-iconv \
            --enable-msgloader-inmemory --enable-xmlch-uint16_t --enable-xmlch-char16_t \
    && make clean && make && make install \
    && cd /home \
    && rm -rf xerces-c-3.2.2/

RUN cd /home \
    && git clone --depth=1 https://github.com/protocolbuffers/protobuf.git \
    && cd protobuf \
    && ./autogen.sh \
    && ./configure --prefix=/usr/local \
    && make clean && make && make install \
    && cd /home \
    && rm -rf protobuf

RUN apt-get update \
    && apt-get install --assume-yes --no-install-recommends python-pip python3-pip ruby ruby-dev

RUN cd /home && export PATH=$PATH:/opt/cmake/bin \
	&& git clone --depth=1 --recurse-submodules  https://github.com/cucumber/cucumber-cpp.git \
    && cd cucumber-cpp \
    && gem install bundler \
    && bundle install \
    && cmake -E make_directory build \
    && cmake -E chdir build cmake -DCUKE_ENABLE_EXAMPLES=on -DCMAKE_INSTALL_PREFIX=/usr/ .. \
    && cmake --build build --target all --clean-first \
    && cmake --build build --target install \
    && cd /home \
    && rm -rf cucumber-cpp

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

RUN wget --no-cookies --no-check-certificate \
        --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"\
        "https://download.oracle.com/otn-pub/java/jdk/8u192-b12/750e1c8617c5452694857ad95c3ee230/jdk-8u192-linux-x64.tar.gz" \
    && tar -xvzf jdk-8u192-linux-x64.tar.gz

RUN export JAVA_HOME=/opt/jdk1.8.0_192
RUN export JRE_HOME=/opt/jdk1.8.0_192/jre
RUN export M2_HOME=/opt/apache-maven/
RUN export M2=$M2_HOME/bin
RUN export MAVEN_OPTS="-Dstyle.info=bold,green -Dstyle.project=bold,magenta -Dstyle.warning=bold,yellow \
        -Dstyle.mojo=bold,cyan -Xmx1048m -Xms256m -XX:MaxPermSize=312M"
RUN export PATH=$PATH:/opt/apache-maven/bin/:/opt/cmake/bin:/opt/jdk1.8.0_192/bin:/opt/jdk1.8.0_192/jre/bina

CMD ["/bin/bash"]

