#!/bin/bash

docker run --net=host --name spdyproxy -d catatnight/spdyproxy

#if squid3 is linked to a local docker container running freeradius, please use
#docker run --net=host --name spdyproxy -d --link <container>:<alias> catatnight/spdyproxy
