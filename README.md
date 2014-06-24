## Requirement
+ Docker 0.11
+ SSL certificate issued by Trusted Root Certification Authorities (e.g. [StartSSL.com](https://www.startssl.com))
+ Google Chrome

## Usage
1. Clone the git repo
	
	```bash
	$ git clone https://github.com/catatnight/docker-sslproxy.git
	$ cd docker-sslproxy
	```
2. Configure

	```bash
	$ vim Dockerfile 
	# edit Dockerfile
	ENV shrpx_port     6789
	# choose auth method (radius or ncsa[htpasswd]) and set related ENV values
	ENV auth_param     radius|ncsa
	ENV radius_server  1.2.3.4
	ENV radius_radpass radpass
	ENV ncsa_users     user1:pwd1,user2:pwd2,...,userN:pwdN
	```
3. Save your own ```.key``` and ```.crt``` files in ```assets/certs/```
4. Build container and then manage it as root
	
	```bash
	$ sudo ./build.sh
	$ sudo ./manage.py [create|start|stop|restart|delete]
	```
5. Using a Secure Web Proxy with Chrome by three optional ways
	1. add command-line argument ```--proxy-server=https://<your.proxy.domain>:<port>```
	2. proxy auto-config (PAC) file

		```
		function FindProxyForURL(url, host) { 
			return "HTTPS <your.proxy.domain>:<port>"; 
		}
		```
	3. chrome extension [falcon proxy](https://chrome.google.com/webstore/detail/falcon-proxy/gchhimlnjdafdlkojbffdkogjhhkdepf) 


## Note
+ accounting information (data transfer) will be sent to a RADIUS server everyday by ```squid2radius```
+ swap needed on host machine since docker 0.10 (especially to DigitalOcean user)

## Reference
+ [搭建 Spdy SSL Proxy (二) - 洋白菜的博客](http://blog.chaiyalin.com/2013/07/spdy-ssl-proxy-2.html)
+ [tatsuhiro-t / spdylay](https://github.com/tatsuhiro-t/spdylay)
+ [jiehanzheng / squid2radius](https://github.com/jiehanzheng/squid2radius)
+ [Chrome - Secure Web Proxy](http://www.chromium.org/developers/design-documents/secure-web-proxy)
+ TBD
