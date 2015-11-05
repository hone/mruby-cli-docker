FROM ubuntu-debootstrap:14.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  automake \
  bison \
  build-essential \
  bzip2 \
  ca-certificates \
  clang \
  cpio \
  curl \
  file \
  g++-multilib \
  gcc-multilib \
  git \
  gzip \
  libssl-dev \
  libtool \
  libxml2-dev \
  llvm-dev \
  make \
  mingw-w64 \
  patch \
  sed \
  uuid-dev \
  xz-utils

# install ruby
RUN mkdir -p /opt/ruby-2.2.2/ && \
  curl -s https://s3-external-1.amazonaws.com/heroku-buildpack-ruby/cedar-14/ruby-2.2.2.tgz | tar xzC /opt/ruby-2.2.2/
ENV PATH /opt/ruby-2.2.2/bin:$PATH

# install osx cross compiling tools
RUN cd /opt/ && \
  git clone https://github.com/tpoechtrager/osxcross.git
COPY MacOSX10.10.sdk.tar.bz2 /opt/osxcross/tarballs/
RUN echo "\n" | bash /opt/osxcross/build.sh
RUN rm /opt/osxcross/tarballs/*
ENV PATH /opt/osxcross/target/bin:$PATH
ENV SHELL /bin/bash

ONBUILD WORKDIR /home/mruby/code
ONBUILD ENV GEM_HOME /home/mruby/.gem/
