#!/bin/bash

# Configure
radius_server_linked=$ALIAS_PORT_1812_UDP_ADDR

# Don't edit below
if [ -n "$radius_server_linked" ]; then
  sed -i "s/$radius_server/$radius_server_linked/" /etc/squid3/squid.conf
  sed -i "s/$radius_server/$radius_server_linked/" /etc/crontab
fi

/usr/sbin/squid3 -N

