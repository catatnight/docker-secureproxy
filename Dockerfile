From ubuntu:latest
MAINTAINER Elliott Ye

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# upgrade base system packages
RUN apt-get update

# Start editing
#install package here for cache
RUN apt-get -y install supervisor
RUN apt-get -y install build-essential \
    && apt-get -y install autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libevent-dev \
    && apt-get install -y wget && wget --no-check-certificate https://github.com/tatsuhiro-t/spdylay/releases/download/v1.2.3/spdylay-1.2.3.tar.gz \
    && tar -zxvf spdylay-1.2.3.tar.gz && cd /spdylay-1.2.3 \
    && autoreconf -i && automake && autoconf && ./configure && make && make install \
    && apt-get -y remove binutils build-essential cpp cpp-4.6 dpkg-dev fakeroot g++ g++-4.6 gcc gcc-4.6 libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libc-dev-bin libc6-dev libclass-isa-perl libdpkg-perl libgdbm3 libgmp10 libgomp1 libmpc2 libmpfr4 libquadmath0 libstdc++6-4.6-dev libswitch-perl libtimedate-perl linux-libc-dev make manpages manpages-dev patch perl perl-modules \
    && apt-get -y remove autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libevent-dev 
RUN apt-get -y install squid3 ed \
    && cd /opt && wget --no-check-certificate https://github.com/jiehanzheng/squid2radius/archive/v1.0.tar.gz \
    && tar -zxvf v1.0.tar.gz && mv squid2radius-1.0 squid2radius \
    && apt-get -y install python-pip \
    && pip install argparse pyrad hurry.filesize

# Add files
#certs
ADD assets/certs /opt/certs 
#shrpx
ADD assets/run-shrpx.sh /opt/run-shrpx.sh
#squid3
ADD assets/run-squid.sh /opt/run-squid.sh
#cron
ADD assets/run-cron.sh /opt/run-cron.sh
#supervisor
ADD assets/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod 755 /opt/*.sh

# Configure
ENV shrpx_port 8222
ENV radius_server  Your Radius Server ip or Address       
ENV radius_radpass Your Radpass

# Ports

CMD ["/usr/bin/supervisord"]
