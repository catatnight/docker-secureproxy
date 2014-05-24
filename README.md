## Requirement
+ Docker 0.11

## Usage
1. configure

	```bash
	# edit Dockerfile
	ENV shrpx_port     Proxy Port
	ENV radius_server  Your Radius Server ip or Address       
	ENV radius_radpass Your Radpass
	```
2. save your own ```.key``` and ```.crt``` files in ```assets/certs/```
3. run ```build.sh``` to build container and then start it by running ```run-server.sh``` (execute as root)


## Note
+ proxy (squid3) requires authentication by freeradius
+ accounting information (data transfer) will be sent to a RADIUS server everyday by ```squid2radius```
+ swap needed on host machine since docker 0.10 (especially to DigitalOcean user)

## Reference
+ [搭建 Spdy SSL Proxy (二) - 洋白菜的博客](http://blog.chaiyalin.com/2013/07/spdy-ssl-proxy-2.html)
+ [tatsuhiro-t / spdylay](https://github.com/tatsuhiro-t/spdylay)
+ [jiehanzheng / squid2radius](https://github.com/jiehanzheng/squid2radius)
+ TBD
