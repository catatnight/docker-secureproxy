#!/bin/bash

docker run -p 8222:8222 --name spdyproxy -d catatnight/spdyproxy

#if squid3 is linked to a local docker container running freeradius, please use
#docker run -p 8222:8222 -name spdyproxy -d -link <container>:<alias> catatnight/spdyproxy