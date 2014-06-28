#!/bin/bash

cd assets/

bash -c "cat > Dockerfile" <<-EOF
From ubuntu:trusty
ADD build-deb.sh /tmp/build-deb.sh
RUN /tmp/build-deb.sh
EOF

if [ -f spdylay.deb ]; then
	sed -i "/From.*/a ADD spdylay.deb \/tmp\/spdylay.deb" Dockerfile
fi
if [ -f nghttp2.deb ]; then
  sed -i "/From.*/a ADD nghttp2.deb \/tmp\/nghttp2.deb" Dockerfile
fi

img='secureproxy'
docker build --no-cache --rm -t $img-temp .
docker run -itd --name $img-temp $img-temp tail -f /var/log/dpkg.log
docker cp $img-temp:/tmp/spdylay.deb . 
docker cp $img-temp:/tmp/nghttp2.deb . 
docker rm -f $img-temp && docker rmi $img-temp && rm Dockerfile

cd ..

docker build --rm -t catatnight/$img .
