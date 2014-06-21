#!/bin/bash

cd assets/

bash -c "cat > Dockerfile" <<-EOF
From ubuntu:latest
ADD build-deb.sh /tmp/build-deb.sh
RUN /tmp/build-deb.sh
EOF

if [ -f spdylay.deb ]; then
	sed -i "/From.*/a ADD spdylay.deb \/tmp\/spdylay.deb" Dockerfile
fi

docker build --no-cache --rm -t spdyproxy-temp .
docker run -itd --name spdyproxy-temp spdyproxy-temp tail -f /var/log/dpkg.log
docker cp spdyproxy-temp:/tmp/spdylay.deb . 
docker rm -f spdyproxy-temp && docker rmi spdyproxy-temp && rm Dockerfile

cd ..

docker build --rm -t catatnight/spdyproxy .
