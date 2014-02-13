#!/bin/bash
sed -i '$a\0 0 * * * root python /root/squid2radius/squid2radius.py --squid-path /usr/sbin/squid3 /var/log/squid3/access.log $radius_server $radius_radpass &> /dev/null' /etc/crontab
sed -i '$a\1 0 * * * root rm /var/log/squid3/access.log.7 &> /dev/null' /etc/crontab

cron -f