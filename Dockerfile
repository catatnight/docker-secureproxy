From ubuntu:latest
MAINTAINER Elliott Ye

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Upgrade base system packages
RUN apt-get update

### Start editing ###
# Install package here for cache
RUN apt-get -y install supervisor
ADD assets/spdylay_1.2.3.deb /tmp/spdylay.deb
RUN apt-get -y install libevent-openssl-2.0-5 libevent-2.0-5 \
    && dpkg -i /tmp/spdylay.deb
RUN apt-get -y install squid3 wget ed \
    && cd /opt && wget --no-check-certificate https://github.com/jiehanzheng/squid2radius/archive/v1.0.tar.gz \
    && tar -zxvf v1.0.tar.gz && mv squid2radius-1.0 squid2radius \
    && apt-get -y install python-pip \
    && pip install argparse pyrad hurry.filesize

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
