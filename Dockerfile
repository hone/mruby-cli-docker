FROM ubuntu-debootstrap:14.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  automake \
  bison \
  build-essential \
  bzip2 \
  ca-certificates \
  ccache \
  clang \
  cpio \
  curl \
  debhelper \
  file \
  g++-multilib \
  gcc-multilib \
  genisoimage \
  git \
  gobject-introspection \
  gzip \
  intltool \
  libgirepository1.0-dev \
  libgsf-1-dev \
  libssl-dev \
  libtool \
  libxml2-dev \
  llvm-dev \
  make \
  mingw-w64 \
  patch \
  rpm \
  sed \
  uuid-dev \
  valac \
  wget \
  xz-utils

# install ruby
RUN mkdir -p /opt/ruby-2.2.5/ && \
  curl -s https://s3-external-1.amazonaws.com/heroku-buildpack-ruby/cedar-14/ruby-2.2.5.tgz | tar xzC /opt/ruby-2.2.5/
ENV PATH /opt/ruby-2.2.5/bin:$PATH

# install fpm to build packages (deb, rpm)
RUN gem install fpm --no-document

# install osx cross compiling tools
RUN cd /opt/ && \
  git clone https://github.com/tpoechtrager/osxcross.git
COPY MacOSX10.10.sdk.tar.bz2 /opt/osxcross/tarballs/
RUN echo "\n" | OSX_VERSION_MIN=10.7 bash -c '/opt/osxcross/build.sh'
RUN rm /opt/osxcross/tarballs/*
ENV PATH /opt/osxcross/target/bin:$PATH
ENV SHELL /bin/bash

# install msitools
RUN cd /tmp && wget https://launchpad.net/ubuntu/+archive/primary/+files/gcab_0.6.orig.tar.xz && tar -xf gcab_0.6.orig.tar.xz && cd gcab-0.6 && ./configure && make && make install

RUN cd /tmp && wget https://launchpad.net/ubuntu/+archive/primary/+files/msitools_0.94.orig.tar.xz && tar -xf msitools_0.94.orig.tar.xz && cd msitools-0.94 && ./configure && make && make install

ENV HOME /home/mruby/

# install rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
  $HOME/.cargo/bin/rustup default stable && \
  $HOME/.cargo/bin/rustup target add i686-unknown-linux-gnu && \
  $HOME/.cargo/bin/rustup target add x86_64-apple-darwin && \
  $HOME/.cargo/bin/rustup target add i686-apple-darwin && \
  $HOME/.cargo/bin/rustup target add x86_64-pc-windows-gnu && \
  $HOME/.cargo/bin/rustup target add i686-pc-windows-gnu

ADD cargo_config $HOME/.cargo/config

WORKDIR /home/mruby/code

ONBUILD ENV GEM_HOME /home/mruby/.gem/

ONBUILD ENV PATH $HOME/.cargo/bin/:$GEM_HOME/bin/:$PATH
ONBUILD ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/
