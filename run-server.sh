#!/bin/bash

docker run -p 8222:8222 -name spdyproxy -d catatnight/spdyproxy

#if shrpx is connected with a local container, please use
#docker run -p 8222:8222 -name spdyproxy -d -link <container>:<alias> catatnight/spdyproxy