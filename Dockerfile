From ubuntu:latest
MAINTAINER Elliott Ye

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Upgrade base system packages
RUN apt-get update

### Start editing ###
# Install package here for cache
RUN apt-get -y install supervisor
RUN apt-get -y install wget curl build-essential autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libevent-dev \
    && export shrpx_v=$(curl https://api.github.com/repos/tatsuhiro-t/spdylay/releases | grep -o '[0-9]\.[0-9]\.[0-9]' | head -1) \
    && cd /tmp/ && wget --no-check-certificate https://github.com/tatsuhiro-t/spdylay/releases/download/v$shrpx_v/spdylay-$shrpx_v.tar.gz \
    && tar -zxvf spdylay-$shrpx_v.tar.gz && cd spdylay-$shrpx_v/ \
    && autoreconf -i && automake && autoconf && ./configure && make && make install
RUN apt-get -y install squid3 wget ed \
    && cd /opt && wget --no-check-certificate https://github.com/jiehanzheng/squid2radius/archive/v1.0.tar.gz \
    && tar -zxvf v1.0.tar.gz && mv squid2radius-1.0 squid2radius \
    && apt-get -y install python-pip && pip install argparse pyrad hurry.filesize

# Add files
#certs
ADD assets/certs /opt/certs 
#supervisor
ADD assets/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure
ENV shrpx_port     Proxy Port
ENV radius_server  Your Radius Server ip or Address
ENV radius_radpass Your Radpass
ENV time_zone      Asia/Shanghai

# Initialization 
ADD assets/install.sh /opt/install.sh
RUN chmod 755 /opt/*.sh 
RUN /opt/install.sh 

# Run
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
