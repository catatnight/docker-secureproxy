#!/bin/bash

#shrpx
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

#squid3
#note: replace $radius_server by $<ALIAS>_PORT_1812_UDP_ADDR if connected with a local radius docker container 
ed -s /etc/squid3/squid.conf <<EOF
0a
#port
http_port 8000
#https_port 8222 cert=/root/certs/server.crt key=/root/certs/server.key options=NO_SSLv2
#authentication
auth_param basic program /usr/lib/squid3/squid_radius_auth -h $radius_server -p 1812 -w $radius_radpass
auth_param basic children 5
auth_param basic realm Hi, buddy! How are you today?
auth_param basic credentialsttl 6 hours
acl auth_user proxy_auth REQUIRED
http_access allow auth_user
#privacy
via off
forwarded_for delete
#follow_x_forwarded_for deny all
request_header_access From deny all
request_header_access Referer deny all
request_header_access Server deny all
#request_header_access User-Agent deny all
request_header_access WWW-Authenticate deny all
request_header_access Link deny all
#cache
cache deny all
cache_mem 0
cache_store_log none
negative_ttl 0 minutes
half_closed_clients off
#logfile
logfile_rotate 10 
.
w
EOF

#crontab
#note: replace $radius_server by $<ALIAS>_PORT_1812_UDP_ADDR if connected with a local radius docker container 
cat >> /etc/crontab <<EOF
0 0 * * * root python /opt/squid2radius/squid2radius.py --squid-path /usr/sbin/squid3 /var/log/squid3/access.log $radius_server $radius_radpass &> /dev/null
1 0 * * * root rm /var/log/squid3/access.log.7 &> /dev/null
EOF

