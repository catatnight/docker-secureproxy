#!/bin/bash
#note: replace $radius_server by $<alias>_PORT_1812_UDP_ADDR if connected with a local docker radius container 
squid_conf="\
#port\n\
http_port 8000\n\
#https_port 8222 cert=/root/certs/server.crt key=/root/certs/server.key options=NO_SSLv2\n\
#authentication\n\
auth_param basic program /usr/lib/squid3/squid_radius_auth -h $radius_server -p 1812 -w $radius_radpass\n\
auth_param basic children 5\n\
auth_param basic realm Hi, buddy! How are you today?\n\
auth_param basic credentialsttl 6 hours\n\
acl auth_user proxy_auth REQUIRED\n\
http_access allow auth_user\n\
#privacy\n\
via off\n\
forwarded_for delete\n\
#follow_x_forwarded_for deny all\n\
request_header_access From deny all\n\
request_header_access Referer deny all\n\
request_header_access Server deny all\n\
#request_header_access User-Agent deny all\n\
request_header_access WWW-Authenticate deny all\n\
request_header_access Link deny all\n\
#logfile\n\
logfile_rotate 10 \n" 

sed -i "1i $squid_conf" /etc/squid3/squid.conf

/usr/sbin/squid3 -N
