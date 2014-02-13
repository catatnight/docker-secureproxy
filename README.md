## Requirement
+ Docker 0.8

## Usage
1. edit ```Dockerfile``` (NO double quotes)

    ```Shell
    # Configure
    ENV shrpx_port 8222
    ENV radius_server  Your Radius Server ip or Address       
    ENV radius_radpass Your Radpass

    # Ports
    EXPOSE 8222
    ```
2. save your own ```server.key``` and ```server.crt``` in ```assets/certs/```
3. run ```build.sh``` and ```run-server.sh``` 
4. if squid3 is linked to a local docker container running freeradius, just
    1.  edit ```run-server.sh```
        ```Shell
        //replace 
        docker run -p 8222:8222 -name spdyproxy -d catatnight/spdyproxy
        //by
        docker run -p 8222:8222 -name spdyproxy -d -link <container>:<alias> catatnight/spdyproxy
        ```

    2.  edit ```assets/run-squid.sh```

        ```Shell
        //replace
        auth_param basic program /usr/lib/squid3/squid_radius_auth -h $radius_server -p 1812 -w $radius_radpass\n\
        //by
        auth_param basic program /usr/lib/squid3/squid_radius_auth -h $<alias>_PORT_1812_UDP_ADDR -p 1812 -w $radius_radpass\n\
        ```

    3.  edit ```assets/run-cron.sh``` (similar to the step above)


## Note
+ proxy (squid3) requires authentication by freeradius
+ accounting information (data transfer) will be sent to a RADIUS server everyday by ```squid2radius```

## Reference
+ [tatsuhiro-t / spdylay](https://github.com/tatsuhiro-t/spdylay)
+ [jiehanzheng / squid2radius](https://github.com/jiehanzheng/squid2radius)
+ [Link Containers - Docker Documentation](http://docs.docker.io/en/latest/use/working_with_links_names/)
+ TBD


