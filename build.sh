#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/assets/"

docker run -it -v $DIR:/tmp --rm ubuntu:trusty sh -c "/tmp/build-deb.sh && echo success"

docker build -t catatnight/secureproxy .
