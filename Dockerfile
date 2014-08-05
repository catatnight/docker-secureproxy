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
RUN apt-get -y install libevent-openssl-2.0-5 libevent-2.0-5 libjemalloc-dev

# Add files
ADD assets/ /opt/
RUN dpkg -i /opt/*.deb && echo "/usr/local/lib" >> /etc/ld.so.conf.d/usr-local.conf && ldconfig

# Run
CMD /opt/install.sh;/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
