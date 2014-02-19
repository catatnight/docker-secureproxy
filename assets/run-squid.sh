#!/bin/bash
#note: replace $radius_server by $<alias>_PORT_1812_UDP_ADDR if connected with a local docker radius container 
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

/usr/sbin/squid3 -N
