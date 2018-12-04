
FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       bison flex gsoap build-essential gawk libgcrypt20-dev libcrypto++-dev \
       python-wheel cython cython3 python3-wheel \
       libxml2-dev libxml2-utils python3-setuptools python-setuptools \
       libcgsi-gsoap-dev libgnutls28-dev libcurl4-gnutls-dev libgnutls-openssl27 \
       mesa-common-dev libglu1-mesa-dev libpcap-dev libglib2.0-dev libssl1.0-dev \
       libfontconfig libldap2-dev libldap-2.4-2  libmysql++-dev \
       unixodbc-dev libgdbm-dev libodb-pgsql-dev libcrossguid-dev  uuid-dev libossp-uuid-dev \
       libghc-uuid-dev libghc-uuid-types-dev ruby ruby-dev libelf-dev  elfutils libelf1 \
       libpulse-dev libssl-dev make gcc-8 g++-8 git unzip  wget curl
       

RUN wget -qO- "https://cmake.org/files/v3.13/cmake-3.13.1-Linux-x86_64.tar.gz" | tar --strip-components=1 -xz -C /opt/cmake

RUN wget https://www.jacorb.org/releases/3.9/jacorb-3.9-binary.zip \
    && unzip jacorb-3.9-binary.zip \
    && mv -v jacorb-3.9 /opt/

RUN wget https://www.jacorb.org/releases/2.3.1/jacorb-2.3.1-bin.zip \
    && unzip jacorb-2.3.1-bin.zip \
    && mv -v jacorb-2.3.1 /opt/

RUN wget https://www-eu.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz \
    && tar -xvzf apache-maven-3.6.0-bin.tar.gz \
    && mv apache-maven-3.6.0/ /opt/

RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "https://download.oracle.com/otn-pub/java/jdk/8u192-b12/750e1c8617c5452694857ad95c3ee230/jdk-8u192-linux-x64.tar.gz" \
    && tar -xvzf jdk-8u192-linux-x64.tar.gz


RUN export JAVA_HOME=/opt/jdk1.8.0_192
RUN export JRE_HOME=/opt/jdk1.8.0_192/jre
RUN export M2_HOME=/opt/apache-maven/
RUN export M2=$M2_HOME/bin
RUN export MAVEN_OPTS="-Xmx1048m -Xms256m -XX:MaxPermSize=312M"
RUN export PATH=$PATH:/opt/apache-maven/bin/:/opt/cmake/bin:/opt/jdk1.8.0_192/bin:/opt/jdk1.8.0_192/jre/bin

