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

ARG IMAGE_VERSION
ARG TARGET_PLATFORM ${TARGET_PLATFORM:x64Linux}
ARG TARGET_COMPILER ${TARGET_COMPILER:3gcc5.4.0}
ENV IMAGE_VERSION ${IMAGE_VERSION:-0.0.1}

RUN apt-get update \
    && apt-get install --assume-yes --no-install-recommends libtool apt-transport-https ca-certificates autotools-dev\
        git xz-utils unzip wget curl openssh-server  openssh-client  automake \
        bison flex gsoap build-essential gawk libgcrypt20-dev libcrypto++-dev \
        python-dev python3-dev python-wheel cython cython3 python3-wheel \
        perl-base perl-modules \
        libxml2-dev libxml2-utils python3-setuptools python-setuptools \
        libcgsi-gsoap-dev libgnutls28-dev libcurl4-gnutls-dev libgnutls-openssl27 \
        mesa-common-dev libglu1-mesa-dev libpcap-dev \
        libfontconfig libldap2-dev libldap-2.4-2  libmysql++-dev \
        unixodbc-dev libgdbm-dev libodb-pgsql-dev libcrossguid-dev  uuid-dev libossp-uuid-dev \
        libghc-uuid-dev libghc-uuid-types-dev ruby ruby-dev libelf-dev  elfutils libelf1 \
        libpulse-dev  make nfs-common   xauth xterm iputils-ping  libswt-gtk-3-java \
    && apt-get clean --assume-yes  \
    && apt-get --assume-yes --quiet clean \
    && apt-get --assume-yes --quiet autoremove \
    && rm -rvf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*
    && rm /var/lib/apt/lists/* -vr \
    && rm -rvf /usr/share/man/

RUN curl -L -O -k https://cmake.org/files/v3.14/cmake-3.14.0-rc1-Linux-x86_64.tar.gz \
    && tar -xvf cmake-3.14.0-rc1-Linux-x86_64.tar.gz > /dev/null \
    && rm -v cmake-3.14.0-rc1-Linux-x86_64.tar.gz \
    && mv -v cmake-3.14.0-rc1-Linux-x86_64 /opt/cmake

ENV PATH $PATH:/opt/cmake/bin

RUN wget --no-cookies --no-check-certificate \
       --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"\
       "https://download.oracle.com/otn-pub/java/jdk/8u202-b08/1961070e4c9b4e26a04e7f5a083f551e/jdk-8u202-linux-x64.tar.gz" \
    && tar -xvzf jdk-8u202-linux-x64.tar.gz -C /opt/ \
    && rm -v jdk-8u202-linux-x64.tar.gz

RUN cd /home \
    &&  wget --no-check-certificate https://www-eu.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz \
    && tar -xvzf apache-maven-3.6.0-bin.tar.gz \
    && mv apache-maven-3.6.0/ /opt/apache-maven \
    && rm -v apache-maven-3.6.0-bin.tar.gz

ENV JAVA_HOME /opt/jdk1.8.0_202
ENV JRE_HOME /opt/jdk1.8.0_202/jre
ENV M2_HOME /opt/apache-maven/
ENV M2 $M2_HOME/bin
ENV MAVEN_OPTS "-Dstyle.info=bold,green -Dstyle.project=bold,magenta -Dstyle.warning=bold,yellow \
        -Dstyle.mojo=bold,cyan -Xmx1048m -Xms256m -XX:MaxPermSize=312M"
ENV PATH $PATH:/opt/apache-maven/bin/:/opt/jdk1.8.0_192/bin:/opt/jdk1.8.0_192/jre/bin

RUN cd /home \
    && curl -L -O -k https://downloads.gradle.org/distributions/gradle-5.1.1-bin.zip \
    && mkdir -pv /opt/gradle \
#    && unzip -d /opt/gradle gradle-5.1.1-bin.zip \
    && unzip gradle-5.1.1-bin.zip \
    && mv -v gradle-5.1.1  /opt/gradle/ \
    && rm -vf gradle-5.1.1-bin.zip

ENV PATH $PATH:/opt/gradle/gradle-5.1.1/bin

RUN cmake --version \
    && make --version \
    && gcc --version \
    && java -version \
    && mvn --version \
    && gradle -v


RUN cd /home \
    && curl -L -O -k https://www-us.apache.org/dist/apr/apr-1.6.5.tar.gz  \
    && tar -xvzf apr-1.6.5.tar.gz > /dev/null  \
    && cd apr-1.6.5 \
    && ./configure --prefix=/usr/ --enable-threads --enable-posix-shm \
        --enable-allocator-guard-pages --enable-pool-concurrency-check --enable-other-child \
    && make clean && make && make install  \
    && cd /home \
    && rm -rvf apr-1.6.5.tar.gz apr-1.6.5

RUN cd /home \
    && git clone --depth=1 https://github.com/libexpat/libexpat.git  \
    && cd libexpat/expat  \
    && cmake -E make_directory build \
    && cmake -E chdir build cmake .. -DCMAKE_INSTALL_PREFIX=/usr/ \
    && cmake --build build --target all --clean-first  \
    && cmake --build build --target install \
    && cd /home \
    && rm -rvf libexpat

RUN cd /home \
    && curl -L -O -k https://www-us.apache.org/dist//apr/apr-util-1.6.1.tar.gz  \
    && tar -xvzf apr-util-1.6.1.tar.gz > /dev/null  \
    && cd apr-util-1.6.1 \
    && ./configure --prefix=/usr/ --with-apr=/usr/ --with-expat=/usr/ \
    && make clean && make && make install  \
    && cd /home \
    && rm -rvf apr-util-1.6.1.tar.gz apr-util-1.6.1

RUN cd /home \
    && GIT_SSL_NO_VERIFY=1 git clone --depth=1 https://gitbox.apache.org/repos/asf/logging-log4cxx.git  \
    && cd logging-log4cxx  \
    && ./autogen.sh \
    && ./configure --prefix=/usr/ --with-apr=/usr/ --with-apr-util=/usr/ \
        --enable-char --enable-wchar_t --with-charset=utf-8 --with-logchar=utf-8 \
    && make clean && make && make install  \
    && cd /home \
    && rm -rvf logging-log4cxx

# kept OpenSSL_1_0_2 for compatibility with the one provided by RTI (openssl-1.0.2n-5.3.1-host-x64Linux.rtipkg)
RUN cd /home \
    && GIT_SSL_NO_VERIFY=1 git clone --depth=1 -b OpenSSL_1_0_2-stable https://github.com/openssl/openssl.git  openssl \
    && cd openssl \
#    && ./config --prefix=/usr shared enable-ec enable-ecdh enable-ecdsa \
    && ./config --prefix=/usr  \
    && make \
    && make install \
    && cd /home \
    && rm -rvf openssl

#    && pip install --upgrade pip \
RUN cd /home \
    && GIT_SSL_NO_VERIFY=1 git clone --depth=1 https://github.com/conan-io/conan.git \
    && cd conan  \
    && pip3 install --upgrade pip \
    && pip install -r conans/requirements.txt
#    using local server.... ussu in dicker
#   https://docs.conan.io/en/latest/uploading_packages/running_your_server.html
#    && pip install -r conans/requirements_server.txt
#    && pip install gunicorn

COPY support/rti_connext_dds-5.3.1-pro-host-x64Linux.run  /tmp/

RUN cd /tmp/ \
     && chmod +x /tmp/rti_connext_dds-5.3.1-pro-host-x64Linux.run  \
     && ./rti_connext_dds-5.3.1-pro-host-x64Linux.run  --mode unattended --prefix /opt \
     && rm -rvf /tmp/rti_connext_dds-5.3.1-pro-host-x64Linux.run

COPY support/rti_license.dat /opt/rti_connext_dds-5.3.1/
COPY support/*.rtipkg  /tmp/
COPY support/*.tar.gz  /tmp/

ENV PATH="${PATH}:/opt/rti_connext_dds-5.3.1/bin"
ENV NDDSHOME=/opt/rti_connext_dds-5.3.1

RUN cd /tmp/ \
    && rtipkginstall -unattended rti_connext_dds-5.3.1-pro-target-armv8Linux4.4gcc5.4.0.rtipkg \
    && rtipkginstall -unattended rti_connext_dds-5.3.1-pro-target-x64Linux3gcc5.4.0.rtipkg \
    && rtipkginstall -unattended rti_limited_bandwidth_plugins-5.3.1-x64Linux3gcc5.4.0.rtipkg \
    && rtipkginstall -unattended rti_secure_wan-5.3.1-x64Linux3gcc5.4.0.rtipkg \
    && rtipkginstall -unattended rti_security_plugins-5.3.1-target-x64Linux3gcc5.4.0.rtipkg \
    && rtipkginstall -unattended openssl-1.0.2n-5.3.1-host-x64Linux.rtipkg  \
    && rtipkginstall -unattended rti_tls_support-5.3.1-x64Linux3gcc5.4.0.rtipkg \
    && rtipkginstall -unattended rti_web_integration_service-5.3.1-x64Linux.rtipkg \
    && rtipkginstall -unattended rti_connext_dds-5.3.1-pro-target-armv8Linux4.4gcc5.4.0.rtipkg \
    && rtipkginstall -unattended rti_connext_dds-5.3.1-pro-target-x64Linux3gcc5.4.0.rtipkg \
    && rtipkginstall -unattended rti_secure_wan-5.3.1-armv8Linux4.4gcc5.4.0.rtipkg \
    && rtipkginstall -unattended rti_security_plugins-5.3.1-target-armv8Linux4.4gcc5.4.0.rtipkg \
    && rtipkginstall -unattended rti_tls_support-5.3.1-armv8Linux4.4gcc5.4.0.rtipkg \
    && rm -rvf /tmp/*.rtipkg /tmp/*.tar.gz

RUN cd /home \
    && git clone --depth=1 https://github.com/uncrustify/uncrustify.git \
    && cd uncrustify \
    && cmake -E make_directory build \
    && cmake -E chdir build cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
    && cmake --build build --target all --clean-first \
    && cmake --build build --target install \
    && cd /home \
    && rm -rvf uncrustify

RUN cd /home \
    && git clone --depth=1 https://github.com/danmar/cppcheck.git \
    && cd cppcheck \
    && cmake -E make_directory build \
    && cmake -E chdir build cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
    && cmake --build build --target all --clean-first  \
    && cmake --build build --target install \
    && cp --recursive --verbose cfg  /usr/local/bin || true \
    && cd /home \
    && rm -rvf cppcheck

RUN cd /home \
    && git clone --depth=1 https://github.com/doxygen/doxygen.git  \
    && cd doxygen \
    && cmake -E make_directory build \
    && cmake -E chdir build cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
    && cmake --build build --target all --clean-first  \
    && cmake --build build --target install \
    && cd /home \
    && rm -rvf doxygen

RUN cd /home \
    && git clone --depth=1 https://github.com/google/googletest.git \
    && cd googletest \
    && cmake -E make_directory build \
    && cmake -E chdir build cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
    && cmake --build build --target all --clean-first  \
    && cmake --build build --target install \
    && cd /home \
    && rm -rvf googletest

RUN cd /home \
    && git clone --depth=1 https://github.com/google/benchmark.git \
    && cd benchmark \
    && cmake -E make_directory build \
    && cmake -E chdir build cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
    && cmake --build build --target all --clean-first  \
    && cmake --build build --target install \
    && cd /home \
    && rm -rvf benchmark

RUN cd /home \
    && curl -L -O -k https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.gz \
    && tar xfz boost_1_69_0.tar.gz > /dev/null \
    && cd boost_1_69_0 \
    && ./bootstrap.sh --prefix=/usr/ \
    && ./b2 --help \
    && ./b2 link=shared threading=multi variant=release address-model=64 \
    && ./b2 install \
    && cd /home \
    && rm -rvf boost_1_69_0 boost_1_69_0.tar.gz

RUN cd /home \
    && git clone --depth=1 --recurse-submodules https://github.com/cucumber/cucumber-cpp.git \
    && cd cucumber-cpp \
    && gem install bundler -v 1.17.3 \
    && bundle install \
    && cmake -E make_directory build \
    && cmake -E chdir build cmake -DCUKE_ENABLE_EXAMPLES=on -DCMAKE_INSTALL_PREFIX=/usr/local .. \
    && cmake --build build --target all --clean-first \
    && cmake --build build --target install \
    && cd /home \
    && rm -rf cucumber-cp

RUN cd /home \
    && git clone --depth=1 https://github.com/protocolbuffers/protobuf.git \
    && cd protobuf \
    && ./autogen.sh \
    && ./configure --prefix=/usr/ \
    && make clean && make && make install \
    && cd /home \
    && rm -rf protobuf



# ENTRYPOINT rtilauncher
# ENTRYPOINT ["/opt/rti_connext_dds-5.2.3/bin/rtipersistenceservice"]
# CMD ["-cfgFile","/config.xml","-cfgName","gets_persistence"]
# CMD /usr/bin/openssl genrsa -out /certs/${KEY_NAME}.key 1024 && \
#    /usr/bin/openssl req  -new -newkey rsa:4096 -days 365 -nodes \
#                     -subj "/C=/ST=/L=/O=/CN=${COMMON_NAME}" -keyout /certs/${KEY_NAME}.key \
#                     -out /certs/${KEY_NAME}.csr  && \
#    /usr/bin/openssl x509 -req -days 365 -in /certs/${KEY_NAME}.csr \
#                     -signkey /certs/${KEY_NAME}.key -out /certs/${KEY_NAME}.crt

RUN useradd -ms /bin/bash happyman

USER happyman
WORKDIR /home/happyman

CMD ["/bin/bash"]

