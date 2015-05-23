## Requirement
+ Docker 1.0
+ A domain and an SSL certificate signed by a trusted CA, (e.g. [StartSSL.com](https://www.startssl.com))
+ Google Chrome

## Installation
1. Build image (as root)

	```bash
	$ docker pull catatnight/secureproxy
	$ wget https://raw.githubusercontent.com/catatnight/docker-secureproxy/master/manage.py
	$ chmod +x manage.py
	```

2. Save SSL certs (same directory as where ```manage.py``` is)

	```bash
	$ mkdir -p certs
	$ cp {file.key,file.crt} certs/
	```

## Usage
1. Create container and manage it (as root)
	+ Uses a RADIUS server for login validation

		```bash
		$ ./manage.py create -p 1234 --radius_server 6.7.8.9 --radius_secret radpass
		```
	+ Uses an NCSA-style username and password file

		```bash
		$ ./manage.py create -p 1234 --ncsa_users user1:pwd1[,user2:pwd2,...]
		```
	+ General usage

		```bash
		$ ./manage.py -h
		usage: manage.py [-h] [-p PROXY_PORT] [--radius_server RADIUS_SERVER]
				 [--radius_secret RADIUS_SECRET] [--ncsa_users NCSA_USERS]
				 {create,start,stop,restart,delete}
		```
2. Using a Secure Web Proxy with Chrome by three optional ways
	1. add command-line argument ```--proxy-server=https://<your.proxy.domain>:<proxy_port>```
	2. proxy auto-config (PAC) file

		```
		function FindProxyForURL(url, host) {
			return "HTTPS <your.proxy.domain>:<proxy_port>";
		}
		```
	3. chrome extension [SwitchyOmega](https://chrome.google.com/webstore/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif)|[falcon proxy](https://chrome.google.com/webstore/detail/falcon-proxy/gchhimlnjdafdlkojbffdkogjhhkdepf)


## Note
+ squid3 needs to use port 3128
+ accounting information (data transfer) will be sent to a RADIUS server everyday by ```squid2radius```
+ swap needed on host machine since docker 0.10 (especially to DigitalOcean user)

## Reference
+ [Chrome - Secure Web Proxy](http://www.chromium.org/developers/design-documents/secure-web-proxy)
+ [tatsuhiro-t / nghttp2](https://github.com/tatsuhiro-t/nghttp2)[ | spdylay](https://github.com/tatsuhiro-t/spdylay)
+ [jiehanzheng / squid2radius](https://github.com/jiehanzheng/squid2radius)
+ [搭建 Spdy SSL Proxy (二) - 洋白菜的博客 (Google's cached page)](http://webcache.googleusercontent.com/search?q=cache:yuB91alsIp4J:blog.chaiyalin.com/2013/07/spdy-ssl-proxy-2.html+&cd=1&hl=zh-CN&ct=clnk&gl=us)
+ TBD
