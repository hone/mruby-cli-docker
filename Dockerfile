FROM ubuntu-debootstrap:14.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  bison \
  build-essential \
  bzip2 \
  ca-certificates \
  clang \
  cpio \
  curl \
  file \
  git \
  gzip \
  libssl-dev \
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
ENV PATH /opt/osxcross/target/bin:$PATH

ONBUILD WORKDIR /home/mruby/code
