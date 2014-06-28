#!/bin/bash

img='secureproxy'
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/assets/"

docker run -v $DIR:/tmp --rm --name $img-temp ubuntu sh -c "/tmp/build-deb.sh && echo success"

docker build --rm -t catatnight/$img .
