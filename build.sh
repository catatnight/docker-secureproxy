#!/bin/bash

shrpx_v=$(curl https://api.github.com/repos/tatsuhiro-t/spdylay/releases | grep -o '[0-9]\.[0-9]\.[0-9]' | head -1)

if [ ! -f assets/spdylay.deb ]; then
	cd assets/
	bash -c "cat > Dockerfile" <<-EOF
	From ubuntu:latest
	MAINTAINER Elliott Ye
	RUN apt-get update \
		&& apt-get -y install wget build-essential autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libevent-dev checkinstall \
		&& cd /tmp && wget --no-check-certificate https://github.com/tatsuhiro-t/spdylay/releases/download/v$shrpx_v/spdylay-$shrpx_v.tar.gz \
		&& tar -zxvf spdylay-$shrpx_v.tar.gz && cd spdylay-$shrpx_v/ \
		&& autoreconf -i && automake && autoconf && ./configure && make \
		&& checkinstall -y --requires="libevent-openssl-2.0-5, libevent-2.0-5" --install=no --maintainer=tatsuhiro-t
	EOF
	docker build --no-cache --rm -t spdyproxy-temp .
	docker run -itd --name spdyproxy-temp spdyproxy-temp tail -f /var/log/dpkg.log
	docker cp spdyproxy-temp:/tmp/spdylay-$shrpx_v/spdylay_$shrpx_v-1_amd64.deb . && mv spdylay_$shrpx_v-1_amd64.deb spdylay.deb
	docker rm -f spdyproxy-temp && docker rmi spdyproxy-temp && rm Dockerfile
	cd ..
fi

docker build --rm -t catatnight/spdyproxy .
