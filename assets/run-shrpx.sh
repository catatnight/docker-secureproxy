#!/bin/bash
mkdir /etc/shrpx
echo -e "\
frontend=0.0.0.0,$shrpx_port\n\
backend=127.0.0.1,8000\n\
private-key-file=/root/certs/server.key\n\
certificate-file=/root/certs/server.crt\n\
spdy-proxy=yes\n\
daemon=no\n\
workers=1\n" \
> /etc/shrpx/shrpx.conf

/usr/local/bin/shrpx