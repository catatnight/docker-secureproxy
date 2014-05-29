## Requirement
+ Docker 0.11
+ SSL certificate issued by Trusted Root Certification Authorities (e.g. [StartSSL.com](https://www.startssl.com))
+ Google Chrome

## Usage
1. Clone the git repo
	
	```bash
	$ git clone https://github.com/catatnight/docker-spdyproxy.git
	$ cd docker-spdyproxy
	```
2. Configure

	```bash
	$ vim Dockerfile 
	# edit Dockerfile
	ENV shrpx_port     Your Proxy Port
	ENV radius_server  Your Radius Server ip or Address       
	ENV radius_radpass Your Radpass
	```
3. Save your own ```.key``` and ```.crt``` files in ```assets/certs/```
4. Build container and then start it as root
	
	```bash
	$ sudo ./build.sh
	$ sudo ./run-server.sh
	```
5. Using a Secure Web Proxy with Chrome by three optional ways
	1. add command-line argument: ```--proxy-server=https://<your.proxy.domain>:<port>```
	2. use pac file: ```function FindProxyForURL(url, host) { return "HTTPS <your.proxy.domain>:<port>"; }```
	3. chrome extension [falcon proxy](https://chrome.google.com/webstore/detail/falcon-proxy/gchhimlnjdafdlkojbffdkogjhhkdepf) 


## Note
+ proxy (squid3) requires authentication by freeradius
+ accounting information (data transfer) will be sent to a RADIUS server everyday by ```squid2radius```
+ swap needed on host machine since docker 0.10 (especially to DigitalOcean user)

## Reference
+ [搭建 Spdy SSL Proxy (二) - 洋白菜的博客](http://blog.chaiyalin.com/2013/07/spdy-ssl-proxy-2.html)
+ [tatsuhiro-t / spdylay](https://github.com/tatsuhiro-t/spdylay)
+ [jiehanzheng / squid2radius](https://github.com/jiehanzheng/squid2radius)
+ [Chrome - Secure Web Proxy](http://www.chromium.org/developers/design-documents/secure-web-proxy)
+ TBD
