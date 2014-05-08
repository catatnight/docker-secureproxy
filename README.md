## Requirement
+ Docker 0.11

## Usage
1. configure

	```bash
	# Dockerfile (NO double quotes)
	ENV shrpx_port Proxy Port
	ENV radius_server  Your Radius Server ip or Address       
	ENV radius_radpass Your Radpass
	```
2. save your own ```server.key``` and ```server.crt``` in ```assets/certs/```
3. run ```build.sh``` and ```run-server.sh``` 


## Note
+ proxy (squid3) requires authentication by freeradius
+ accounting information (data transfer) will be sent to a RADIUS server everyday by ```squid2radius```
+ swap needed on host machine since docker 0.10 (especially to DigitalOcean user)

## Reference
+ [搭建 Spdy SSL Proxy (二) - 洋白菜的博客](http://blog.chaiyalin.com/2013/07/spdy-ssl-proxy-2.html)
+ [tatsuhiro-t / spdylay](https://github.com/tatsuhiro-t/spdylay)
+ [jiehanzheng / squid2radius](https://github.com/jiehanzheng/squid2radius)
+ [Link Containers - Docker Documentation](http://docs.docker.io/en/latest/use/working_with_links_names/)
+ TBD


