From ubuntu:trusty
MAINTAINER Elliott Ye

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Upgrade base system packages
RUN apt-get update

### Start editing ###
# Install package here for cache
RUN apt-get -y install supervisor
RUN apt-get -y install squid3 wget ed apache2-utils \
    && cd /opt && wget --no-check-certificate https://github.com/jiehanzheng/squid2radius/archive/v1.0.tar.gz \
    && tar -zxvf v1.0.tar.gz && mv squid2radius-1.0 squid2radius \
    && apt-get -y install --no-install-recommends python-pip && pip install argparse pyrad hurry.filesize
RUN apt-get -y install libevent-openssl-2.0-5 libevent-2.0-5 openssl libssl1.0.0
ADD assets/spdylay.deb /tmp/spdylay.deb
RUN dpkg -i /tmp/spdylay.deb && ln -s /usr/local/lib/libspdylay.so /lib/x86_64-linux-gnu/libspdylay.so.7

# Add files
#certs
ADD assets/certs /opt/certs 

# Configure
ENV shrpx_port     6789
ENV auth_param     radius|ncsa
ENV radius_server  1.2.3.4
ENV radius_radpass radpass
ENV ncsa_users     user1:pwd1,user2:pwd2,...,userN:pwdN
ENV time_zone      Asia/Shanghai

# Initialization 
ADD assets/install.sh /opt/install.sh
RUN /opt/install.sh 

# Run
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
