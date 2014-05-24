#!/bin/bash

if [ $(dpkg -l curl >/dev/null 2>&1 && echo -n "installed") != "installed" ]; then
  apt-get -y install curl
fi

shrpx_v=$(curl https://api.github.com/repos/tatsuhiro-t/spdylay/releases | grep -o '[0-9]\.[0-9]\.[0-9]' | head -1)

if [ "$(dpkg-deb --field assets/spdylay.deb version)" != "$shrpx_v-1" ]; then
  current_dic="$PWD"
  docker run -v /tmp:/tmp:rw --name spdyproxy-temp ubuntu:latest apt-get update \
    && apt-get -y install wget build-essential autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libevent-dev checkinstall \
    && cd /tmp && wget --no-check-certificate https://github.com/tatsuhiro-t/spdylay/releases/download/v$shrpx_v/spdylay-$shrpx_v.tar.gz \
    && tar -zxvf spdylay-$shrpx_v.tar.gz && cd spdylay-$shrpx_v/ \
    && autoreconf -i && automake && autoconf && ./configure && make \
    && checkinstall -y --requires="libevent-openssl-2.0-5, libevent-2.0-5" --install=no --maintainer=tatsuhiro-t
  mv /tmp/spdylay-$shrpx_v/spdylay_$shrpx_v-1_amd64.deb $current_dic/assets/spdylay.deb
  docker rm -f spdyproxy-temp
  rm -rf /tmp/spdylay-$shrpx_v/ && rm /tmp/spdylay-$shrpx_v.tar.gz
  cd $current_dic
fi

docker build --rm -t catatnight/spdyproxy .
