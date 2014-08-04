#!/bin/bash

#judgement
if [[ -a /etc/supervisor/conf.d/supervisord.conf ]]; then
	exit 0
fi

#supervisor
cat > /etc/supervisor/conf.d/supervisord.conf <<EOF
[supervisord]
nodaemon=true

[program:nghttpx]
command=/usr/local/bin/nghttpx

[program:squid3]
command=/usr/sbin/squid3 -N

[program:cronjob]
command=/usr/sbin/cron -f
EOF

#nghttpx
mkdir /etc/nghttpx
cat > /etc/nghttpx/nghttpx.conf <<EOF
frontend=0.0.0.0,$proxy_port
backend=127.0.0.1,3128
private-key-file=$(find /opt/certs -iname *.key)
certificate-file=$(find /opt/certs -iname *.crt)
http2-proxy=yes
daemon=no
workers=1
EOF

#squid3
ed -s /etc/squid3/squid.conf <<EOF
0a
#authentication
auth_param basic program
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
if [[ -z "$ncsa_users" ]]; then
	sed -i "s/^\(auth_param basic program\)/\1 \/usr\/lib\/squid3\/basic_radius_auth -h $radius_server -p 1812 -w $radius_radpass/" /etc/squid3/squid.conf
	cat >> /etc/crontab <<-EOF
	0 0 * * * root python /opt/squid2radius/squid2radius.py --squid-path /usr/sbin/squid3 /var/log/squid3/access.log $radius_server $radius_radpass > /dev/null 2>&1
	EOF
else
	> /etc/squid3/passwd
	echo $ncsa_users | tr , \\n > /tmp/passwd
	while IFS=':' read -r _user _pwd; do
		htpasswd -b /etc/squid3/passwd $_user $_pwd
	done < /tmp/passwd
	sed -i "s/^\(auth_param basic program\)/\1 \/usr\/lib\/squid3\/basic_ncsa_auth \/etc\/squid3\/passwd/" /etc/squid3/squid.conf
fi

#timezone
bash -c "echo $time_zone > /etc/timezone"
dpkg-reconfigure -f noninteractive tzdata
