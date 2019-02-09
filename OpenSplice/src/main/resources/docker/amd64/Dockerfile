
FROM ubuntu:18.10

ENV LANG=en_US.UTF-8

# Some sub modules could not be cloned due to Proxy not handling ".git" protocol
RUN git config --global url."https://github.com/".insteadOf "git@github.com:"
RUN git config --global url."https://".insteadOf git://
#RUN git config --global url."https".insteadOf "git+https"

ENV JAVA_HOME /opt/jdk1.8.0_192
ENV JRE_HOME /opt/jdk1.8.0_192/jre
ENV JACORB_HOME /opt/jacorb-2.3.1
ENV M2_HOME /opt/apache-maven/
ENV M2 $M2_HOME/bin
ENV MAVEN_OPTS "-Dstyle.info=bold,green -Dstyle.project=bold,magenta -Dstyle.warning=bold,yellow \
        -Dstyle.mojo=bold,cyan -Xmx1048m -Xms256m -XX:MaxPermSize=312M"
ENV PATH $PATH:/opt/apache-maven/bin/:/opt/jdk1.8.0_192/bin:/opt/jdk1.8.0_192/jre/bin

RUN cmake --version \
    && make --version \
    && gcc --version \
    && java -version \
    && mvn --version
    
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

RUN apt-get update \
    && apt-get install -y gcc g++ make gawk bison flex perl git wget libssl-dev unzip \
    && git clone https://github.com/PrismTech/opensplice.git -b $BRANCH $OSPL_SOURCE

RUN cd /home \
    && curl -L -O -k https://freefr.dl.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.74.zip  \
    && unzip gsoap_2.8.74.zip \
    && cd gsoap-2.8 \
    && ./configure --prefix=/usr/ \
    && make clean && make && make install \
    && cd /home \
    && rm -rf gsoap-2.8 gsoap_2.8.74.zip

ENV GSOAPHOME /usr
ENV PROTOBUF_HOME /usr
ENV SPLICE_TARGET x86_64.linux-release
ENV SPLICE_REAL_TARGET x86_64.linux-release
ENV SPLICE_HOST x86_64.linux-release

RUN cd /home \
    && git clone --depth=1 --recurse-submodules https://github.com/ADLINK-IST/opensplice.git\
#    &&  ./configure x86_64.linux-release && make && make install
#  WKRND make[4]: *** No rule to make target '/usr/include/stdsoap2.c', needed by 'stdsoap2.c'.  Stop.
#    && ln -s /opt/gsoap-$GSOAP_MAJ_VER/gsoap/stdsoap2.c /opt/gsoap-$GSOAP_MAJ_VER/usr/include/ \
    && cp -v /home/stdsoap2.c /usr/include/stdsoap2.c \
    && /bin/bash -c "source configure $SPLICE_TARGET && make clean && make && make install" \
    && mv -v install/HDE /opt/ \
    && cd /home \
    && rm -rf opensplice
