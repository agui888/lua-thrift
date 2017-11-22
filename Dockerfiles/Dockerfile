FROM debian:jessie
ENV DEBIAN_FRONTEND noninteractive

# =========================================================
# Install packages required by build
# =========================================================
RUN buildDeps=" \
      automake \
      bison \
      cmake \
      curl \
      flex \
      g++ \
      libboost1.55-all-dev \
      libevent-dev \
      libreadline-dev \
      libssl-dev \
      lua5.2 \
      lua5.2-dev \
      make \
      ncurses-dev \
      pkg-config \
      "; \
  apt-get update && apt-get install -y --no-install-recommends $buildDeps

# =========================================================
# Download and install Thrift
# =========================================================
ARG THRIFT_VERSION=0.9.2
RUN mkdir /thrift \
  && curl -s -k -R -O http://archive.apache.org/dist/thrift/$THRIFT_VERSION/thrift-$THRIFT_VERSION.tar.gz \
  && tar -zxf thrift-$THRIFT_VERSION.tar.gz \
  && mv thrift-$THRIFT_VERSION/* /thrift
WORKDIR /thrift
RUN ./configure --with-lua
RUN make install

# =========================================================
# Configure runtime env
# =========================================================
#CMD ["thrift"]
