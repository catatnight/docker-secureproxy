#!/bin/bash
mkdir /etc/shrpx
cat > /etc/shrpx/shrpx.conf <<EOF
frontend=0.0.0.0,$shrpx_port
backend=127.0.0.1,8000
private-key-file=/opt/certs/server.key
certificate-file=/opt/certs/server.crt
spdy-proxy=yes
daemon=no
workers=1
EOF

/usr/local/bin/shrpx