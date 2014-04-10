## Requirement
+ Docker 0.8

## Usage
1. configure

	```bash
	# Dockerfile (NO double quotes)
	#Configure
	ENV shrpx_port 8222
	ENV radius_server  Your Radius Server ip or Address       
	ENV radius_radpass Your Radpass

	# run-server.sh (only if shrpx_port above changed)
	docker run -p <NEW_PORT>:<NEW_PORT> --name spdyproxy -d catatnight/spdyproxy
	```
2. save your own ```server.key``` and ```server.crt``` in ```assets/certs/```
3. run ```build.sh``` and ```run-server.sh``` 
4. if squid3 is linked to a local docker container running freeradius, just edit 

	```bash
	# run-server.sh
	docker run -p 8222:8222 --name spdyproxy -d --link <CONTAINER>:<ALIAS> catatnight/spdyproxy

	# assets/link.sh (ALIAS must be capitalized)
	radius_server_linked=$ALIAS_PORT_1812_UDP_ADDR

	```


## Note
+ proxy (squid3) requires authentication by freeradius
+ accounting information (data transfer) will be sent to a RADIUS server everyday by ```squid2radius```

## Reference
+ [搭建 Spdy SSL Proxy (二) - 洋白菜的博客](http://blog.chaiyalin.com/2013/07/spdy-ssl-proxy-2.html)
+ [tatsuhiro-t / spdylay](https://github.com/tatsuhiro-t/spdylay)
+ [jiehanzheng / squid2radius](https://github.com/jiehanzheng/squid2radius)
+ [Link Containers - Docker Documentation](http://docs.docker.io/en/latest/use/working_with_links_names/)
+ TBD


