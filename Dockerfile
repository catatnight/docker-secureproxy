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
    && apt-get -y install autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libevent-dev
RUN apt-get install -y wget && wget --no-check-certificate https://github.com/tatsuhiro-t/spdylay/releases/download/v1.2.3/spdylay-1.2.3.tar.gz \
    && tar -zxvf spdylay-1.2.3.tar.gz && cd /spdylay-1.2.3 \
    && autoreconf -i && automake && autoconf && ./configure && make && make install
RUN apt-get -y install squid3 \
    && cd /root && wget --no-check-certificate https://github.com/jiehanzheng/squid2radius/archive/v1.0.tar.gz \
    && tar -zxvf v1.0.tar.gz && mv squid2radius-1.0 squid2radius \
    && apt-get -y install python-pip \
    && pip install argparse pyrad hurry.filesize

# Add files
#certs
ADD assets/certs /root/certs 
#shrpx
ADD assets/run-shrpx.sh /root/run-shrpx.sh
#squid3
ADD assets/run-squid.sh /root/run-squid.sh
#cron
ADD assets/run-cron.sh /root/run-cron.sh
#supervisor
ADD assets/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod 755 /root/*.sh

# Configure
ENV shrpx_port 8222
ENV radius_server  Your Radius Server ip or Address       
ENV radius_radpass Your Radpass

# Ports
EXPOSE 8222

CMD ["/usr/bin/supervisord"]
