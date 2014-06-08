#!/bin/bash

#supervisor
cat > /etc/supervisor/conf.d/supervisord.conf <<EOF
[supervisord]
nodaemon=true

[program:shrpx]
command=/usr/local/bin/shrpx

[program:squid3]
command=/usr/sbin/squid3 -N

[program:cronjob]
command=/usr/sbin/cron -f
EOF

#shrpx
server_key=$(ls /opt/certs | grep "\.key")
server_crt=$(ls /opt/certs | grep "\.crt")
mkdir /etc/shrpx
cat > /etc/shrpx/shrpx.conf <<EOF
frontend=0.0.0.0,$shrpx_port
backend=127.0.0.1,3128
private-key-file=/opt/certs/$server_key
certificate-file=/opt/certs/$server_crt
spdy-proxy=yes
daemon=no
workers=1
EOF

#squid3
ed -s /etc/squid3/squid.conf <<EOF
0a
#authentication
auth_param basic program /usr/lib/squid3/basic_radius_auth -h $radius_server -p 1812 -w $radius_radpass
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
logfile_rotate 4 
.
w
EOF
if [ "$auth_param" == "ncsa" ]; then
	touch /etc/squid3/passwd
	echo $auth_users | tr , \\n > /tmp/passwd
	while IFS=':' read -r _user _pwd; do
		htpasswd -b /etc/squid3/passwd $_user $_pwd 
	done < /tmp/passwd
	sed -i "s/^auth_param basic program.*/auth_param basic program \/usr\/lib\/squid3\/basic_ncsa_auth \/etc\/squid3\/passwd/" /etc/squid3/squid.conf
fi

#cron
if [ "$auth_param" != "ncsa" ]; then
	cat >> /etc/crontab <<-EOF
	MAILTO=""
	0 0 * * * root python /opt/squid2radius/squid2radius.py --squid-path /usr/sbin/squid3 /var/log/squid3/access.log $radius_server $radius_radpass > /dev/null 2>&1
	EOF
fi

#timezone
bash -c "echo $time_zone > /etc/timezone" 
dpkg-reconfigure -f noninteractive tzdata
